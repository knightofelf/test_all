#include <windows.h>
#include <math.h>
#include <algorithm>
#include <commctrl.h>

/*
#ifndef max
#define max(a,b) (((a) > (b)) ? (a) : (b))
#endif

#ifndef min
#define min(a,b) (((a) < (b)) ? (a) : (b))
#endif

#include <windows.h>
#include <commctrl.h>
// ... 이하 기존 코드 동일 ...
*/


// 컴파일러 경고 방지 및 라이브러리 링크 (Visual Studio 환경용)
#pragma comment(lib, "comctl32.lib")

// --- 전역 데이터 및 변수 정의 ---
COLORREF MyPalette[3] = {
    RGB(0, 0, 255),   // 인덱스 0: Pure Blue
    RGB(0, 255, 0),   // 인덱스 1: Pure Green
    RGB(255, 0, 0)    // 인덱스 2: Pure Red
};

float g_Weight = 0.0f;          // 0.0f ~ 1.0f 가중치
WNDPROC g_OldScrollProc = NULL; // 기존 스크롤 바 프로시저
HWND hScrollBar = NULL;
RECT g_RenderRect = { 50, 50, 450, 250 }; // 렌더링 범위 사각형

// --- 함수 선언 ---
LRESULT CALLBACK MainWndProc(HWND, UINT, WPARAM, LPARAM);
LRESULT CALLBACK ScrollSubclassProc(HWND, UINT, WPARAM, LPARAM);
COLORREF GetWeightedColor(float weight);

// =========================================================================
// [WinMain] 프로그램의 시작점
// =========================================================================
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
    // 공통 컨트롤 라이브러리 초기화 (스크롤 바 및 기본 컨트롤 사용 위함)
    INITCOMMONCONTROLSEX icex;
    icex.dwSize = sizeof(INITCOMMONCONTROLSEX);
    icex.dwICC = ICC_STANDARD_CLASSES;
    InitCommonControlsEx(&icex);

    const TCHAR szClassName[] = TEXT("PaletteWeightClass");

    // 1. 메인 윈도우 클래스 등록
    WNDCLASSEX wc = { 0 };
    wc.cbSize = sizeof(WNDCLASSEX);
    wc.style = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc = MainWndProc;
    wc.hInstance = hInstance;
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    // 본문 기법 반영: 배경 브러시를 NULL(0)로 주어 시스템이 배경을 지우는 연산을 최소화
    wc.hbrBackground = (HBRUSH)GetStockObject(NULL_BRUSH); 
    wc.lpszClassName = szClassName;

    if (!RegisterClassEx(&wc)) {
        MessageBox(NULL, TEXT("윈도우 클래스 등록 실패!"), TEXT("에러"), MB_ICONERROR);
        return 0;
    }

    // 2. 메인 윈도우 창 생성
    HWND hWnd = CreateWindowEx(
        0,
        szClassName,
        TEXT("Win32 API Palette - Weight Subclassing Render"),
        WS_OVERLAPPEDWINDOW & ~WS_THICKFRAME & ~WS_MAXIMIZEBOX, // 크기 조절 차단 (예제 단순화)
        CW_USEDEFAULT, CW_USEDEFAULT, 515, 380,
        NULL, NULL, hInstance, NULL
    );

    if (!hWnd) {
        MessageBox(NULL, TEXT("윈도우 생성 실패!"), TEXT("에러"), MB_ICONERROR);
        return 0;
    }

    ShowWindow(hWnd, nCmdShow);
    UpdateWindow(hWnd);

    // 3. 표준 Win32 메시지 루프
    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return (int)msg.wParam;
}

// =========================================================================
// [MainWndProc] 메인 윈도우 프로시저
// =========================================================================
LRESULT CALLBACK MainWndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    switch (uMsg) {
    case WM_CREATE: {
        // 스크롤 바 컨트롤 생성 (가로형)
        hScrollBar = CreateWindowEx(0, TEXT("SCROLLBAR"), NULL,
            WS_CHILD | WS_VISIBLE | SBS_HORZ,
            50, 280, 400, 20, hWnd, (HMENU)100, ((LPCREATESTRUCT)lParam)->hInstance, NULL);

        // 스크롤 범위 및 초기 위치 설정 (0 ~ 100)
        SCROLLINFO si = { sizeof(SCROLLINFO), SIF_RANGE | SIF_POS, 0, 100, 0 };
        SetScrollInfo(hScrollBar, SB_CTL, &si, TRUE);

        // [Subclassing] 스크롤 바 프로시저 가로채기 등록
        g_OldScrollProc = (WNDPROC)SetWindowLongPtr(hScrollBar, GWLP_WNDPROC, (LONG_PTR)ScrollSubclassProc);
        return 0;
    }

    case WM_HSCROLL: {
        int curPos = GetScrollPos(hScrollBar, SB_CTL);
        int action = LOWORD(wParam);

        if (action == SB_THUMBTRACK || action == SB_THUMBPOSITION) curPos = HIWORD(wParam);
        else if (action == SB_LINELEFT)  curPos = std::max(0, curPos - 1);
        else if (action == SB_LINERIGHT) curPos = std::min(100, curPos + 1);

        SetScrollPos(hScrollBar, SB_CTL, curPos, TRUE);

        // 가중치 계산 (0.0f ~ 1.0f)
        g_Weight = (float)curPos / 100.0f;

        // [제로 플리커 1] 배경 삭제 메커니즘 차단 상태로 타겟 영역만 무효화 (FALSE)
        InvalidateRect(hWnd, &g_RenderRect, FALSE);
        return 0;
    }

    case WM_ERASEBKGND:
        // [제로 플리커 2] 윈도우 전체 무효화 시 흰 배경으로 미는 동작 강제 차단
        return 1; 

    case WM_PAINT: {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hWnd, &ps);

        // 가중치 적용 보간 컬러 추출
        COLORREF blendedColor = GetWeightedColor(g_Weight);

        // 1. 범위 사각형 내부 색상 채우기
        HBRUSH hBrush = CreateSolidBrush(blendedColor);
        FillRect(hdc, &g_RenderRect, hBrush);
        DeleteObject(hBrush);

        // 2. 텍스트 연산 및 ExtTextOut 처리
        TCHAR szBuf[64];
        wsprintf(szBuf, TEXT(" Weight Ratio: %d%% "), (int)(g_Weight * 100));
        
        SetTextColor(hdc, RGB(255, 255, 255)); // 텍스트 색상: 흰색
        SetBkColor(hdc, blendedColor);         // 텍스트 배경을 보간 컬러와 동기화 (경계선 플리커 제거)
        
        // ExtTextOut 원자적 배경 채우기 기법 사용
        ExtTextOut(hdc, 80, 80, ETO_CLIPPED | ETO_OPAQUE, &g_RenderRect, szBuf, lstrlen(szBuf), NULL);

        EndPaint(hWnd, &ps);
        return 0;
    }

    case WM_DESTROY:
        // 프로그램 종료 시 서브클래싱 원복 (자원 유출 방지 및 안전한 해제)
        if (g_OldScrollProc) {
            SetWindowLongPtr(hScrollBar, GWLP_WNDPROC, (LONG_PTR)g_OldScrollProc);
        }
        PostQuitMessage(0);
        return 0;
    }
    return DefWindowProc(hWnd, uMsg, wParam, lParam);
}

// =========================================================================
// [ScrollSubclassProc] 서브클래싱 함수 (스크롤 바 컨트롤 메시지 후킹)
// =========================================================================
LRESULT CALLBACK ScrollSubclassProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    HWND hMainWnd = GetParent(hWnd);
    if (uMsg == WM_VSCROLL || uMsg == WM_HSCROLL) {
        PostMessage(hMainWnd, uMsg, wParam, lParam);
    }
    return CallWindowProc(g_OldScrollProc, hWnd, uMsg, wParam, lParam);
}

// =========================================================================
// [GetWeightedColor] 가중치 기반 컬러 선형 보간 알고리즘
// =========================================================================
COLORREF GetWeightedColor(float weight) {
    if (weight <= 0.0f) return MyPalette[0];
    if (weight >= 1.0f) return MyPalette[2];

    float scaled = weight * 2.0f; // 3개 노드(구간 2개)이므로 0.0 ~ 2.0 스케일링
    int idx = (int)scaled;        // 하위 인덱스 계산
    float t = scaled - idx;       // 두 인덱스 사이의 세부 가중치(0.0 ~ 1.0)

    COLORREF c1 = MyPalette[idx];
    COLORREF c2 = MyPalette[idx + 1];

    BYTE r = (BYTE)(GetRValue(c1) * (1.0f - t) + GetRValue(c2) * t);
    BYTE g = (BYTE)(GetGValue(c1) * (1.0f - t) + GetGValue(c2) * t);
    BYTE b = (BYTE)(GetBValue(c1) * (1.0f - t) + GetBValue(c2) * t);

    return RGB(r, g, b);
}

