#include <windows.h>
#include <math.h>
#include <commctrl.h>
#include <algorithm>

#pragma comment(lib, "comctl32.lib")


using namespace std;

// --- 1. Colorz 핵심 색상 알고리즘 (RGB ↔ HSL 변환) ---
struct HSL {
    double h; // Hue (0.0 ~ 360.0)
    double s; // Saturation (0.0 ~ 1.0)
    double l; // Lightness (0.0 ~ 1.0)
};

// RGB에서 HSL 변환 공식
HSL RGBtoHSL(COLORREF rgb) {
    double r = GetRValue(rgb) / 255.0;
    double g = GetGValue(rgb) / 255.0;
    double b = GetBValue(rgb) / 255.0;

    double maxVal = max(r, std::max(g, b));
    double minVal = min(r, std::min(g, b));
    
    HSL hsl = { 0.0, 0.0, (maxVal + minVal) / 2.0 };

    if (maxVal != minVal) {
        double d = maxVal - minVal;
        hsl.s = hsl.l > 0.5 ? d / (2.0 - maxVal - minVal) : d / (maxVal + minVal);

        if (maxVal == r)      hsl.h = (g - b) / d + (g < b ? 6.0 : 0.0);
        else if (maxVal == g) hsl.h = (b - r) / d + 2.0;
        else if (maxVal == b) hsl.h = (r - g) / d + 4.0;
        
        hsl.h *= 60.0;
    }
    return hsl;
}

// HSL Helper 함수
double HueToRGB(double v1, double v2, double vH) {
    if (vH < 0.0) vH += 1.0;
    if (vH > 1.0) vH -= 1.0;
    if ((6.0 * vH) < 1.0) return (v1 + (v2 - v1) * 6.0 * vH);
    if ((2.0 * vH) < 1.0) return (v2);
    if ((3.0 * vH) < 2.0) return (v1 + (v2 - v1) * ((2.0 / 3.0) - vH) * 6.0);
    return (v1);
}

// HSL에서 RGB 변환 공식
COLORREF HSLtoRGB(HSL hsl) {
    double r, g, b;

    if (hsl.s == 0) {
        r = g = b = hsl.l; // 무채색 (그레이스케일)
    } else {
        double v2 = hsl.l < 0.5 ? hsl.l * (1.0 + hsl.s) : (hsl.l + hsl.s) - (hsl.l * hsl.s);
        double v1 = 2.0 * hsl.l - v2;

        r = HueToRGB(v1, v2, (hsl.h / 360.0) + (1.0 / 3.0));
        g = HueToRGB(v1, v2, (hsl.h / 360.0));
        b = HueToRGB(v1, v2, (hsl.h / 360.0) - (1.0 / 3.0));
    }

    return RGB((BYTE)(r * 255), (BYTE)(g * 255), (BYTE)(b * 255));
}

// --- 2. WinAPI UI 윈도우 제어 및 그래픽 렌더링 ---
COLORREF g_SelectedColor = RGB(255, 0, 0); // 기본 전역 색상
HBRUSH g_hColorBrush = NULL;               // 색상 미리보기 브러시

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    static HWND hSliderH, hSliderS, hSliderL;
    static HWND hStaticPreview;

    switch (msg) {
    case WM_CREATE: {
        InitCommonControls();
        g_hColorBrush = CreateSolidBrush(g_SelectedColor);

        // HSL 값 확인
        HSL currentHsl = RGBtoHSL(g_SelectedColor);

        // UI 슬라이더 생성 (Hue, Saturation, Lightness 각각 생성)
        CreateWindowW(L"STATIC", L"Hue:", WS_CHILD | WS_VISIBLE, 20, 20, 80, 20, hwnd, NULL, NULL, NULL);
        hSliderH = CreateWindowW(TRACKBAR_CLASSW, L"", WS_CHILD | WS_VISIBLE | TBS_AUTOTICKS, 100, 20, 200, 30, hwnd, (HMENU)101, NULL, NULL);
        SendMessage(hSliderH, TBM_SETRANGE, TRUE, MAKELPARAM(0, 360));
        SendMessage(hSliderH, TBM_SETPOS, TRUE, (LPARAM)currentHsl.h);

        CreateWindowW(L"STATIC", L"Saturation:", WS_CHILD | WS_VISIBLE, 20, 60, 80, 20, hwnd, NULL, NULL, NULL);
        hSliderS = CreateWindowW(TRACKBAR_CLASSW, L"", WS_CHILD | WS_VISIBLE | TBS_AUTOTICKS, 100, 60, 200, 30, hwnd, (HMENU)102, NULL, NULL);
        SendMessage(hSliderS, TBM_SETRANGE, TRUE, MAKELPARAM(0, 100));
        SendMessage(hSliderS, TBM_SETPOS, TRUE, (LPARAM)(currentHsl.s * 100));

        CreateWindowW(L"STATIC", L"Lightness:", WS_CHILD | WS_VISIBLE, 20, 100, 80, 20, hwnd, NULL, NULL, NULL);
        hSliderL = CreateWindowW(TRACKBAR_CLASSW, L"", WS_CHILD | WS_VISIBLE | TBS_AUTOTICKS, 100, 100, 200, 30, hwnd, (HMENU)103, NULL, NULL);
        SendMessage(hSliderL, TBM_SETRANGE, TRUE, MAKELPARAM(0, 100));
        SendMessage(hSliderL, TBM_SETPOS, TRUE, (LPARAM)(currentHsl.l * 100));

        // 색상 실시간 미리보기 Static 영역 생성
        hStaticPreview = CreateWindowW(L"STATIC", L"", WS_CHILD | WS_VISIBLE | SS_OWNERDRAW, 320, 20, 120, 110, hwnd, (HMENU)201, NULL, NULL);
        break;
    }

    case WM_HSCROLL: { // 슬라이더 바 조작 시 실시간 메시지 가로채기
        HSL targetHsl;
        targetHsl.h = SendMessage(hSliderH, TBM_GETPOS, 0, 0);
        targetHsl.s = SendMessage(hSliderS, TBM_GETPOS, 0, 0) / 100.0;
        targetHsl.l = SendMessage(hSliderL, TBM_GETPOS, 0, 0) / 100.0;

        // 알고리즘을 통해 실시간 변환 후 전역 색상 값 업데이트
        g_SelectedColor = HSLtoRGB(targetHsl);

        // 기존 GDI 브러시 폐기 후 새로 채색
        if (g_hColorBrush) DeleteObject(g_hColorBrush);
        g_hColorBrush = CreateSolidBrush(g_SelectedColor);

        // 미리보기 화면 갱신 유도
        InvalidateRect(hStaticPreview, NULL, TRUE);
        break;
    }

    case WM_DRAWITEM: { // SS_OWNERDRAW 설정된 미리보기 박스 그리기 [1.21]
        LPDRAWITEMSTRUCT lpDIS = (LPDRAWITEMSTRUCT)lParam;
        if (lpDIS->CtlID == 201) {
            FillRect(lpDIS->hDC, &lpDIS->rcItem, g_hColorBrush); // 실시간 변환된 색상으로 박스를 채움
        }
        break;
    }

    case WM_DESTROY:
        if (g_hColorBrush) DeleteObject(g_hColorBrush);
        PostQuitMessage(0);
        break;

    default:
        return DefWindowProc(hwnd, msg, wParam, lParam);
    }
    return 0;
}

// --- 3. WinMain 진입점 ---
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
    WNDCLASSEXW wc = { sizeof(WNDCLASSEXW), CS_HREDRAW | CS_VREDRAW, WndProc, 0, 0, hInstance, NULL, NULL, NULL, NULL, L"ColorzClass", NULL };
    RegisterClassExW(&wc);

    HWND hwnd = CreateWindowExW(0, L"ColorzClass", L"CodeProject Colorz WinAPI 구현", WS_OVERLAPPEDWINDOW ^ WS_THICKFRAME, CW_USEDEFAULT, CW_USEDEFAULT, 480, 190, NULL, NULL, hInstance, NULL);
    ShowWindow(hwnd, nCmdShow);
    UpdateWindow(hwnd);

    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    return (int)msg.wParam;
}

