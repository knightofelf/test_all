#include <windows.h>
#include <commctrl.h>
#include <vector>
#include <map>
#include <algorithm>

#pragma comment(lib, "comctl32.lib")

const char g_szClassName[] = "PaletteWeightedSubClassMixer";

// [팔레트 가중치 SubClassing 렌더] 개별 색상 컴포넌트 구조체
struct SubClassComponent {
    DWORD  weightedColor; // 범위 내 가중치 통계 평균으로 믹싱된 고유 색상 (0x00RRGGBB)
    HBITMAP hMaskBmp;     // 이 컴포넌트가 점유할 1비트 초고속 마스크 비트맵 Handle
    HBRUSH  hBrush;       // 이 컴포넌트가 사출할 단일 컬러 고유 브러시
};

std::vector<SubClassComponent> g_SubClassPool;
int g_ImgWidth = 0;
int g_ImgHeight = 0;

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

    // RGB 비중 가중치 데이터 축적 구조체
    struct ColorAccumulator {
        unsigned long long sumR = 0;
        unsigned long long sumG = 0;
        unsigned long long sumB = 0;
        unsigned long count = 0;
    };

    // 256개 해시 범주 분할 (R: 3비트, G: 3비트, B: 2비트 분할 매핑 -> 8*8*4 = 최대 256개)
    std::map<DWORD, ColorAccumulator> bucketMap;
    std::vector<DWORD> pixelBucketKeys(g_ImgWidth * g_ImgHeight);

    for (int i = 0; i < g_ImgWidth * g_ImgHeight; ++i) {
        DWORD rawColor = rawPixels[i];
        BYTE r = (rawColor >> 16) & 0xFF;
        BYTE g = (rawColor >> 8) & 0xFF;
        BYTE b = rawColor & 0xFF;

        BYTE bucketR = r & 0xE0; 
        BYTE bucketG = g & 0xE0; 
        BYTE bucketB = b & 0xC0; 
        DWORD bucketKey = (bucketR << 16) | (bucketG << 8) | bucketB;

        pixelBucketKeys[i] = bucketKey;

        bucketMap[bucketKey].sumR += r;
        bucketMap[bucketKey].sumG += g;
        bucketMap[bucketKey].sumB += b;
        bucketMap[bucketKey].count++;
    }

    // 범위별 픽셀 가중치가 완벽히 결합된 대표색 산출 및 인덱싱
    std::map<DWORD, int> bucketKeyToPoolIdx;
    std::vector<DWORD> finalWeightedColors;

    int currentPoolIdx = 0;
    for (auto& pair : bucketMap) {
        DWORD key = pair.first;
        ColorAccumulator& acc = pair.second;

        BYTE avgR = (BYTE)(acc.sumR / acc.count);
        BYTE avgG = (BYTE)(acc.sumG / acc.count);
        BYTE avgB = (BYTE)(acc.sumB / acc.count);
        DWORD weightedColor = RGB(avgR, avgG, avgB);

        finalWeightedColors.push_back(weightedColor);
        bucketKeyToPoolIdx[key] = currentPoolIdx;
        currentPoolIdx++;
    }

    int finalComponentCount = (int)finalWeightedColors.size();
    int rowStride = ((g_ImgWidth + 31) & ~31) / 8; // GDI 1비트 정렬 스트라이드 규격 반영
    std::vector<std::vector<BYTE>> maskBuffers(finalComponentCount, std::vector<BYTE>(rowStride * g_ImgHeight, 0));

    // 메모리 내 비트마스크 다이렉트 바이너리 매핑
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

    // 최대 256개 확정 인스턴스 서브클래스 컴포넌트 풀 할당
    g_SubClassPool.clear();
    g_SubClassPool.resize(finalComponentCount);
    for (int i = 0; i < finalComponentCount; i++) {
        g_SubClassPool[i].weightedColor = finalWeightedColors[i];
        g_SubClassPool[i].hBrush = CreateSolidBrush(finalWeightedColors[i]);
        g_SubClassPool[i].hMaskBmp = CreateBitmap(g_ImgWidth, g_ImgHeight, 1, 1, maskBuffers[i].data());
    }

    return true;
}

// [마스터 서브클래싱 프로시저] 보이지 않는 오프스크린 백버퍼 내에서 256개 믹스컬러 적층 결합
LRESULT CALLBACK MainWndSubclassProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam, 
                                     UINT_PTR uIdSubclass, DWORD_PTR dwRefData) 
{
    switch (uMsg) {
    case WM_ERASEBKGND:
        return 1; // 윈도우 기본 배경 지우기를 인터셉트하여 깜빡임 근본 제거

    case WM_PAINT: {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hWnd, &ps);

        // A. 더블 버퍼링 가상 백버퍼 자원 할당
        HDC hMemDC = CreateCompatibleDC(hdc);
        HBITMAP hMemBmp = CreateCompatibleBitmap(hdc, g_ImgWidth, g_ImgHeight);
        HBITMAP hOldBmp = (HBITMAP)SelectObject(hMemDC, hMemBmp);

        // B. 백버퍼 베이스 클리어 (기본 블랙 믹싱)
        HBRUSH hBg = CreateSolidBrush(RGB(0, 0, 0));
        RECT rc = { 0, 0, g_ImgWidth, g_ImgHeight };
        FillRect(hMemDC, &rc, hBg);
        DeleteObject(hBg);

        // 1비트 마스크 공급을 통제할 믹서 DC 생성
        HDC hMaskDC = CreateCompatibleDC(hdc);

        // C. 정확히 256개 이내의 가중치 색상 컴포넌트들만 순회하며 고속 적층 (MixColor)
        // 35,553번 도는 것이 아니기 때문에 프레임 드랍이 완전히 소멸합니다.
        // C. 정확히 256개 이내의 가중치 색상 컴포넌트들만 순회하며 고속 적층 (MixColor)
        int totalComponents = (int)g_SubClassPool.size();
        for (int i = 0; i < totalComponents; i++) {
            if (g_SubClassPool[i].hMaskBmp) {
                HBITMAP hOldMaskBmp = (HBITMAP)SelectObject(hMaskDC, g_SubClassPool[i].hMaskBmp);
                HBRUSH hOldBrush = (HBRUSH)SelectObject(hMemDC, g_SubClassPool[i].hBrush);

                // [교정 완료] 대문자 C(g_SubclassPool)를 사용하여 마스크 패스 바인딩
                MaskBlt(
                    hMemDC, 0, 0, g_ImgWidth, g_ImgHeight,
                    hMaskDC, 0, 0,
                    g_SubClassPool[i].hMaskBmp, 0, 0,
                    MAKEROP4(PATCOPY, 0xAA0029)
                );

                SelectObject(hMemDC, hOldBrush);
                SelectObject(hMaskDC, hOldMaskBmp);
            }
        }

        DeleteDC(hMaskDC);

        // D. 믹싱 조립이 완료된 더블 버퍼 레이어를 실제 하드웨어 화면 DC에 단 1회 플립 전송!
        BitBlt(hdc, 0, 0, g_ImgWidth, g_ImgHeight, hMemDC, 0, 0, SRCCOPY);

        // 가상 백버퍼 청소
        SelectObject(hMemDC, hOldBmp);
        DeleteObject(hMemBmp);
        DeleteDC(hMemDC);

        EndPaint(hWnd, &ps);
        return 0;
    }
    case WM_SIZE:
        // 창 크기가 변형될 때 서브클래스 화면을 칼같이 갱신하여 드래그 잔상 유발 차단
        InvalidateRect(hWnd, NULL, FALSE);
        return 0;

    case WM_WINDOWPOSCHANGING:
        // 창이 윈도우 스케줄러 계층에서 밀리지 않도록 다이렉트 그리기 강제 동기화
        UpdateWindow(hWnd);
        break;

    case WM_NCDESTROY:
        RemoveWindowSubclass(hWnd, MainWndSubclassProc, uIdSubclass);
        break;
    }
    return DefSubclassProc(hWnd, uMsg, wParam, lParam);
}

// 윈도우 메인 기본 프로시저 (GDI 풀 자원 반환 관리)
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
    if (message == WM_DESTROY) {
        // 커널 리소스 회수 규격 준수
        for (size_t i = 0; i < g_SubClassPool.size(); i++) {
            if (g_SubClassPool[i].hBrush) DeleteObject(g_SubClassPool[i].hBrush);
            if (g_SubClassPool[i].hMaskBmp) DeleteObject(g_SubClassPool[i].hMaskBmp);
        }
        PostQuitMessage(0);
        return 0;
    }
    return DefWindowProc(hWnd, message, wParam, lParam);
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int nCmdShow) {
    // 대용량 원본 파일 로딩 및 가중치 분할 매핑 가동
    if (!LoadAndBuildWeightedSubClasses("test.bmp")) {
        MessageBoxA(NULL, "test.bmp 이미지 파일을 찾을 수 없습니다!", "에러", MB_ICONERROR);
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

    HWND hWnd = CreateWindowExA(
        0, g_szClassName, "팔레트 가중치 SubClassing 렌더 (MixColor 더블버퍼)",
        WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, g_ImgWidth + 16, g_ImgHeight + 39,
        NULL, NULL, hInstance, NULL
    );

    if (!hWnd) return 0;

    // 마스터 윈도우에 서브클래스 믹서 인터페이스 마운트
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

