#include <windows.h>
#include <commctrl.h>
#include <algorithm>
#include <cstdlib>
#include <ctime>

#pragma comment(lib, "comctl32.lib")


#define WM_USER_UPDATE_COLOR 10001


// --- 1. 색상 변환 알고리즘 (순수 HSL to RGB) ---
struct HSL { double h, s, l; };

double HueToRGB(double v1, double v2, double vH) {
    if (vH < 0.0) vH += 1.0;
    if (vH > 1.0) vH -= 1.0;
    if ((6.0 * vH) < 1.0) return (v1 + (v2 - v1) * 6.0 * vH);
    if ((2.0 * vH) < 1.0) return (v2);
    if ((3.0 * vH) < 2.0) return (v1 + (v2 - v1) * ((2.0 / 3.0) - vH) * 6.0);
    return (v1);
}

COLORREF HSLtoRGB(HSL hsl) {
    double r, g, b;
    if (hsl.s == 0) { r = g = b = hsl.l; }
    else {
        double v2 = hsl.l < 0.5 ? hsl.l * (1.0 + hsl.s) : (hsl.l + hsl.s) - (hsl.l * hsl.s);
        double v1 = 2.0 * hsl.l - v2;
        r = HueToRGB(v1, v2, (hsl.h / 360.0) + (1.0 / 3.0));
        g = HueToRGB(v1, v2, (hsl.h / 360.0));
        b = HueToRGB(v1, v2, (hsl.h / 360.0) - (1.0 / 3.0));
    }
    return RGB((BYTE)(r * 255), (BYTE)(g * 255), (BYTE)(b * 255));
}

COLORREF GetRandomColor() {
    HSL hsl;
    hsl.h = rand() % 360;
    hsl.s = (rand() % 60 + 40) / 100.0;
    hsl.l = (rand() % 50 + 30) / 100.0;
    return HSLtoRGB(hsl);
}

// --- 2. 256개 자식 창 각각에 등록할 서브클래스 프로시저 ---
// 메인 윈도우에서 그림을 그리지 않고, 이 서브클래스가 각 자식의 화면을 개별 렌더링합니다.
LRESULT CALLBACK TileSubclassProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam, UINT_PTR uIdSubclass, DWORD_PTR dwRefData) {
    // dwRefData를 통해 각 타일 고유의 색상 데이터를 유지 관리
    COLORREF* pColor = reinterpret_cast<COLORREF*>(dwRefData);

    switch (uMsg) {
    case WM_PAINT: {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hWnd, &ps);
        
        RECT rc;
        GetClientRect(hWnd, &rc);
        
        // 자식 창 스스로가 보관 중인 자신만의 색상으로 배경을 채움
        HBRUSH hBrush = CreateSolidBrush(*pColor);
        FillRect(hdc, &rc, hBrush);
        DeleteObject(hBrush);

        EndPaint(hWnd, &ps);
        return 0; // 메인 윈도우의 기본 그리기 로직을 타지 않고 직접 처리 완료
    }

    case WM_USER_UPDATE_COLOR: { // 사용자가 정의한 색상 변경 커스텀 메시지
        *pColor = GetRandomColor();  // 메모리에 할당된 고유 색상값 갱신
        InvalidateRect(hWnd, NULL, FALSE); // 자식 창 스스로 화면 갱신 요청
        return 0;
    }

    case WM_NCDESTROY:
        // 서브클래싱 안전 해제 및 동적 할당한 색상 메모리 수거
        RemoveWindowSubclass(hWnd, TileSubclassProc, uIdSubclass);
        delete pColor;
        break;
    }

    return DefSubclassProc(hWnd, uMsg, wParam, lParam);
}

// --- 3. 메인 부모 윈도우 프로시저 ---
const int GRID_SIZE = 16;
const int RECT_SIZE = 25;
HWND g_hTiles[256]; // 256개 자식 윈도우 핸들 저장 배열

LRESULT CALLBACK MainWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
    case WM_CREATE: {
        srand((unsigned int)time(NULL));
        InitCommonControls(); // 서브클래싱 API 사용을 위한 초기화

        // 256개의 자식 창을 생성하고 각각 독립 서브클래싱 등록
        for (int i = 0; i < 256; ++i) {
            int row = i / GRID_SIZE;
            int col = i % GRID_SIZE;
            int x = col * RECT_SIZE + 10;
            int y = row * RECT_SIZE + 10;

            // 1. 개별 독립된 Static 자식 컨트롤 생성
            g_hTiles[i] = CreateWindowExW(0, L"STATIC", L"", 
                WS_CHILD | WS_VISIBLE | SS_NOTIFY, 
                x, y, RECT_SIZE - 2, RECT_SIZE - 2, 
                hwnd, (HMENU)(UINT_PTR)(1000 + i), GetModuleHandle(NULL), NULL);

            // 2. 이 자식 타일 고유의 색상 메모리 할당 및 초기화
            COLORREF* pColorData = new COLORREF(GetRandomColor());

            // 3. 자식 창에 개별 서브클래싱 등록 (고유 ID와 색상 데이터 포인터 주소 전달)
            SetWindowSubclass(g_hTiles[i], TileSubclassProc, i, reinterpret_cast<DWORD_PTR>(pColorData));
        }

        // 0.2초마다 타이머 가동
        SetTimer(hwnd, 1, 200, NULL);
        break;
    }

    case WM_TIMER:
        if (wParam == 1) {
            // 메인 윈도우는 그리지 않고, 256개 자식 윈도우에게 "스스로 색 바꾸고 렌더링하라"고 명령 메시지만 전송
            for (int i = 0; i < 256; ++i) {
                SendMessage(g_hTiles[i], WM_USER_UPDATE_COLOR, 0, 0);
            }
        }
        break;

    case WM_DESTROY:
        KillTimer(hwnd, 1);
        PostQuitMessage(0);
        break;

    default:
        return DefWindowProc(hwnd, msg, wParam, lParam);
    }
    return 0;
}

// --- 4. 진입점 ---
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
    WNDCLASSEXW wc = { sizeof(WNDCLASSEXW), CS_HREDRAW | CS_VREDRAW, MainWndProc, 0, 0, hInstance, NULL, NULL, NULL, NULL, L"SubclassMainClass", NULL };
    RegisterClassExW(&wc);

    HWND hwnd = CreateWindowExW(0, L"SubclassMainClass", L"256 Independent Subclassed Tiles", WS_OVERLAPPEDWINDOW ^ WS_THICKFRAME ^ WS_MAXIMIZEBOX, CW_USEDEFAULT, CW_USEDEFAULT, 435, 460, NULL, NULL, hInstance, NULL);
    ShowWindow(hwnd, nCmdShow);
    UpdateWindow(hwnd);

    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    return (int)msg.wParam;
}

