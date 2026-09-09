#include <windows.h>
#include <commctrl.h>
#include <vector>
#include <map>
#include <algorithm>

#pragma comment(lib, "comctl32.lib")

const char g_szClassName[] = "PaletteWeightedSubClassMixer";

// 믹싱용 레퍼런스 팔레트 (GitHub 소스코드의 3노드 컬러 세팅 반영)
COLORREF MyPalette[3] = { RGB(0, 0, 255), RGB(0, 255, 0), RGB(255, 0, 0) };

// 가중치 제어용 실시간 전역 변수
float g_Weight = 0.0f; 
HWND hScroll = NULL;

// [팔레트 가중치 SubClassing 렌더] 개별 범위 컴포넌트 구조체
struct SubClassComponent {
    BYTE   baseBrightness; // 범위 내 픽셀들의 평균 밝기/채도 가중치 값 (0~255)
    HBITMAP hMaskBmp;       // 이 컴포넌트가 점유할 1비트 초고속 마스크 비트맵 Handle
};

std::vector<SubClassComponent> g_SubClassPool;
int g_ImgWidth = 0;
int g_ImgHeight = 0;

// GitHub 소스코드의 핵심: 가중치(0.0~1.0)와 기본 밝기(factor)를 결합한 선형 보간 함수
COLORREF GetWeightedColor(float weight, BYTE factor) {
    float r = 0, g = 0, b = 0;
    
    // 3노드 구간 선형 보간 (Blue -> Green -> Red)
    if (weight <= 0.5f) {
        float t = weight / 0.5f;
        r = (1.0f - t) * GetRValue(MyPalette[0]) + t * GetRValue(MyPalette[1]);
        g = (1.0f - t) * GetGValue(MyPalette[0]) + t * GetGValue(MyPalette[1]);
        b = (1.0f - t) * GetBValue(MyPalette[0]) + t * GetBValue(MyPalette[1]);
    } else {
        float t = (weight - 0.5f) / 0.5f;
        r = (1.0f - t) * GetRValue(MyPalette[1]) + t * GetRValue(MyPalette[2]);
        g = (1.0f - t) * GetGValue(MyPalette[1]) + t * GetGValue(MyPalette[2]);
        b = (1.0f - t) * GetBValue(MyPalette[1]) + t * GetBValue(MyPalette[2]);
    }
    
    // 픽셀 고유 가중치(밝기)를 곱하여 원본 텍스처 명암 유지 믹싱
    BYTE finalR = (BYTE)((r * factor) / 255.0f);
    BYTE finalG = (BYTE)((g * factor) / 255.0f);
    BYTE finalB = (BYTE)((b * factor) / 255.0f);
    
    return RGB(finalR, finalG, finalB);
}

// 이미지 정보를 읽어 정확히 최대 256개의 가중치 범위 서브클래스 비트마스크 풀 구축
bool LoadAndBuildWeightedSubClasses(const char* filename) {
    HBITMAP hBitmap = (HBITMAP)LoadImageA(NULL, filename, IMAGE_BITMAP, 0, 0,
                                          LR_LOADFROMFILE | LR_CREATEDIBSECTION);
    if (!hBitmap) return false;

    BITMAP bmp;
    GetObject(hBitmap, sizeof(BITMAP), &bmp);
    g_ImgWidth = bmp.bmWidth;
    g_ImgHeight = bmp.bmHeight;

    std::vector<DWORD> rawPixels(g_ImgWidth * g_ImgHeight);
    BITMAPINFO bmi = { 0 };
    bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmi.bmiHeader.biWidth = g_ImgWidth;
    bmi.bmiHeader.biHeight = -g_ImgHeight; // Top-down
    bmi.bmiHeader.biPlanes = 1;
    bmi.bmiHeader.biBitCount = 32;
    bmi.bmiHeader.biCompression = BI_RGB;

    HDC hdc = GetDC(NULL);
    GetDIBits(hdc, hBitmap, 0, g_ImgHeight, rawPixels.data(), &bmi, DIB_RGB_COLORS);
    ReleaseDC(NULL, hdc);
    DeleteObject(hBitmap);

    // 밝기 축적 구조체
    struct BrightnessAccumulator {
        unsigned long long sumBrightness = 0;
        unsigned long count = 0;
    };

    // 256개 해시 범주 분할 (RGB 각각 상위 비트를 취합해 최대 256개 상태 매핑)
    std::map<DWORD, BrightnessAccumulator> bucketMap;
    std::vector<DWORD> pixelBucketKeys(g_ImgWidth * g_ImgHeight);

    for (int i = 0; i < g_ImgWidth * g_ImgHeight; ++i) {
        DWORD rawColor = rawPixels[i];
        BYTE r = (rawColor >> 16) & 0xFF;
        BYTE g = (rawColor >> 8) & 0xFF;
        BYTE b = rawColor & 0xFF;

        // 정확히 최대 256개 슬롯 유도 (R:3bit, G:3bit, B:2bit)
        BYTE bucketR = r & 0xE0; 
        BYTE bucketG = g & 0xE0; 
        BYTE bucketB = b & 0xC0; 
        DWORD bucketKey = (bucketR << 16) | (bucketG << 8) | bucketB;

        pixelBucketKeys[i] = bucketKey;

        // 가중치 믹싱용 밝기 공식 반영 (그레이스케일 계수 활용)
        BYTE brightness = (BYTE)((r * 0.299f) + (g * 0.587f) + (b * 0.114f));
        bucketMap[bucketKey].sumBrightness += brightness;
        bucketMap[bucketKey].count++;
    }

    std::map<DWORD, int> bucketKeyToPoolIdx;
    std::vector<BYTE> finalFactors;

    int currentPoolIdx = 0;
    for (auto& pair : bucketMap) {
        DWORD key = pair.first;
        BrightnessAccumulator& acc = pair.second;

        BYTE avgBrightness = (BYTE)(acc.sumBrightness / acc.count);
        finalFactors.push_back(avgBrightness);
        bucketKeyToPoolIdx[key] = currentPoolIdx;
        currentPoolIdx++;
    }

    int finalComponentCount = (int)finalFactors.size();
    int rowStride = ((g_ImgWidth + 31) & ~31) / 8; // GDI 1비트 정렬 스트라이드 규격
    std::vector<std::vector<BYTE>> maskBuffers(finalComponentCount, std::vector<BYTE>(rowStride * g_ImgHeight, 0));

    for (int y = 0; y < g_ImgHeight; y++) {
        for (int x = 0; x < g_ImgWidth; x++) {
            int pixelIdx = y * g_ImgWidth + x;
            DWORD bKey = pixelBucketKeys[pixelIdx];
            int poolIdx = bucketKeyToPoolIdx[bKey];

            int destByteIdx = y * rowStride + (x / 8);
            int bitShift = 7 - (x % 8);
            maskBuffers[poolIdx][destByteIdx] |= (1 << bitShift);
        }
    }

    g_SubClassPool.clear();
    g_SubClassPool.resize(finalComponentCount);
    for (int i = 0; i < finalComponentCount; i++) {
        g_SubClassPool[i].baseBrightness = finalFactors[i];
        g_SubClassPool[i].hMaskBmp = CreateBitmap(g_ImgWidth, g_ImgHeight, 1, 1, maskBuffers[i].data());
    }

    return true;
}



// [마스터 서브클래싱 프로시저] 백버퍼 공간에서 GitHub 스타일 실시간 가중치 믹싱 렌더링
LRESULT CALLBACK MainWndSubclassProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam, 
                                     UINT_PTR uIdSubclass, DWORD_PTR dwRefData) 
{
    switch (uMsg) {
    case WM_ERASEBKGND:
        return 1; // 배경 지우기 무시로 깜빡임 방지

    case WM_PAINT: {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hWnd, &ps);

        // A. 더블 버퍼링 백버퍼 자원 할당
        HDC hMemDC = CreateCompatibleDC(hdc);
        HBITMAP hMemBmp = CreateCompatibleBitmap(hdc, g_ImgWidth, g_ImgHeight);
        HBITMAP hOldBmp = (HBITMAP)SelectObject(hMemDC, hMemBmp);

        // B. 백버퍼 베이스 클리어 (기본 블랙 믹싱)
        HBRUSH hBg = CreateSolidBrush(RGB(0, 0, 0));
        RECT rc = { 0, 0, g_ImgWidth, g_ImgHeight };
        FillRect(hMemDC, &rc, hBg);
        DeleteObject(hBg);

        // 1비트 마스크 공급용 DC 생성
        HDC hMaskDC = CreateCompatibleDC(hdc);

        // C. 정확히 256개 이내의 가중치 컴포넌트 풀을 순회하며 실시간 보간 렌더링
        int totalComponents = (int)g_SubClassPool.size();
        for (int i = 0; i < totalComponents; i++) {
            if (g_SubClassPool[i].hMaskBmp) {
                // 실시간 스크롤바 가중치와 각 컴포넌트의 고유 밝기를 결합하여 보간 컬러 계산
                COLORREF blendedColor = GetWeightedColor(g_Weight, g_SubClassPool[i].baseBrightness);
                
                // 보간된 믹스컬러로 매 프레임 임시 브러시 생성 및 장착
                HBRUSH hDynamicBrush = CreateSolidBrush(blendedColor);
                HBRUSH hOldBrush = (HBRUSH)SelectObject(hMemDC, hDynamicBrush);
                HBITMAP hOldMaskBmp = (HBITMAP)SelectObject(hMaskDC, g_SubClassPool[i].hMaskBmp);

                // 고속 하드웨어 가속 래스터 연산 결합 (1비트 마스크 영역에 믹싱된 브러시 투하)
                MaskBlt(
                    hMemDC, 0, 0, g_ImgWidth, g_ImgHeight,
                    hMaskDC, 0, 0,
                    g_SubClassPool[i].hMaskBmp, 0, 0,
                    MAKEROP4(PATCOPY, 0xAA0029) // Foreground: 브러시 복사, Background: 대상 보존
                );

                // 자원 원상 복구 및 생성된 동적 브러시 즉시 삭제 (GDI 핸들 부족 방지)
                SelectObject(hMaskDC, hOldMaskBmp);
                SelectObject(hMemDC, hOldBrush);
                DeleteObject(hDynamicBrush);
            }
        }
        DeleteDC(hMaskDC);

        // D. 믹싱 조립이 완료된 백버퍼를 화면에 단 1회 플립 전송
        BitBlt(hdc, 0, 0, g_ImgWidth, g_ImgHeight, hMemDC, 0, 0, SRCCOPY);

        // 백버퍼 정리
        SelectObject(hMemDC, hOldBmp);
        DeleteObject(hMemBmp);
        DeleteDC(hMemDC);

        EndPaint(hWnd, &ps);
        return 0;
    }
    case WM_HSCROLL: {
        // 하단 스크롤바 조작에 따른 실시간 가중치 값 업데이트
        int hScrollPos = GetScrollPos((HWND)lParam, SB_CTL);
        switch (LOWORD(wParam)) {
        case SB_LINELEFT:   hScrollPos -= 5;  break;
        case SB_LINERIGHT:  hScrollPos += 5;  break;
        case SB_PAGELEFT:   hScrollPos -= 20; break;
        case SB_PAGERIGHT:  hScrollPos += 20; break;
        case SB_THUMBTRACK: hScrollPos = HIWORD(wParam); break;
        }
        if (hScrollPos < 0) hScrollPos = 0;
        if (hScrollPos > 100) hScrollPos = 100;
        
        SetScrollPos((HWND)lParam, SB_CTL, hScrollPos, TRUE);
        
        // 0~100의 범위를 GetWeightedColor가 인식하는 0.0f ~ 1.0f 범위로 정규화
        g_Weight = (float)hScrollPos / 100.0f;
        
        // 화면을 다시 그리도록 무효화 요청
        InvalidateRect(hWnd, NULL, FALSE);
        return 0;
    }
    case WM_SIZE:
        // 창 크기가 변경될 때 잔상 제거 및 최적화
        InvalidateRect(hWnd, NULL, FALSE);
        return 0;

    case WM_WINDOWPOSCHANGING:
        UpdateWindow(hWnd);
        break;

    case WM_NCDESTROY:
        RemoveWindowSubclass(hWnd, MainWndSubclassProc, uIdSubclass);
        break;
    }
    return DefSubclassProc(hWnd, uMsg, wParam, lParam);
}



// 윈도우 메인 기본 프로시저 (GDI 마스크 비트맵 자원 해제 관리)
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
    if (message == WM_DESTROY) {
        // 프로그램 종료 시 256개 풀에 누적되었던 GDI 마스크 비트맵 핸들 완전 해제
        for (size_t i = 0; i < g_SubClassPool.size(); i++) {
            if (g_SubClassPool[i].hMaskBmp) {
                DeleteObject(g_SubClassPool[i].hMaskBmp);
            }
        }
        PostQuitMessage(0);
        return 0;
    }
    return DefWindowProc(hWnd, message, wParam, lParam);
}

// 엔트리 포인트 (WinMain)
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int nCmdShow) {
    // 1. 대용량 원본 파일 로딩 및 가중치 분할 매핑 가동
    if (!LoadAndBuildWeightedSubClasses("test.bmp")) {
        MessageBoxA(NULL, "test.bmp 이미지 파일을 찾을 수 없습니다!\n실행 파일과 같은 폴더에 배치해 주세요.", "에러", MB_ICONERROR);
        return 0;
    }

    char status[128];
    wsprintfA(status, "아키텍처 확정: [ 팔레트 가중치 SubClassing 렌더 ]\n%d개의 가중치 믹스컬러 컴포넌트 풀 생성 완료!", (int)g_SubClassPool.size());
    MessageBoxA(NULL, status, "성공", MB_OK | MB_ICONINFORMATION);

    WNDCLASSEXA wc = { 0 };
    wc.cbSize = sizeof(WNDCLASSEX);
    wc.style = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc = WndProc;
    wc.hInstance = hInstance;
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.lpszClassName = g_szClassName;

    if (!RegisterClassExA(&wc)) return 0;

    // 이미지 해상도 + 하단 스크롤바 여유 공간(60px)을 감안하여 창 크기 자동 할당
    int wndWidth = g_ImgWidth + 16;
    int wndHeight = g_ImgHeight + 39 + 60;

    HWND hWnd = CreateWindowExA(
        0, g_szClassName, "팔레트 가중치 SubClassing 렌더 (MixColor 3노드 보간)",
        WS_OVERLAPPEDWINDOW & ~WS_MAXIMIZEBOX, // 해상도 고정을 위해 최대화 락
        CW_USEDEFAULT, CW_USEDEFAULT, wndWidth, wndHeight,
        NULL, NULL, hInstance, NULL
    );

    if (!hWnd) return 0;

    // 2. 가중치(g_Weight)를 실시간 통제할 하단 윈도우 스크롤바 생성
    hScroll = CreateWindowExA(
        0, "SCROLLBAR", NULL,
        WS_CHILD | WS_VISIBLE | SBS_HORZ,
        10, g_ImgHeight + 10, g_ImgWidth - 20, 25,
        hWnd, (HMENU)201, hInstance, NULL
    );

    // 스크롤바 가동 범위 세팅 (0 ~ 100)
    SetScrollRange(hScroll, SB_CTL, 0, 100, TRUE);
    SetScrollPos(hScroll, SB_CTL, 0, TRUE);

    // 3. 마스터 윈도우에 서브클래스 믹서 인터페이스 장착
    SetWindowSubclass(hWnd, MainWndSubclassProc, 0, 0);

    ShowWindow(hWnd, nCmdShow);
    UpdateWindow(hWnd);

    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    return (int)msg.wParam;
}

