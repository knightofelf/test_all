#include <windows.h>
#include <commctrl.h>
#include <algorithm>
#include <cstdlib>
#include <ctime>

#pragma comment(lib, "comctl32.lib")

// --- 사용자 정의 메시지 선언 ---
#define WM_USER_UPDATE_COLOR (WM_USER + 1)

// --- 1. 독립 타일 전역 설정 및 색상 데이터 구조 ---
const int GRID_SIZE = 16;
const int RECT_SIZE = 25;

struct TileData {
    COLORREF color;     // 타일 고유 색상
    bool isSubclassed;  // 현재 서브클래싱 활성화 여부 상태값
};

HWND g_hTiles[256];     // 256개 자식 핸들 배열

// 랜덤 RGB 생성 함수
COLORREF GetRandomColor() {
    return RGB(rand() % 256, rand() % 256, rand() % 256);
}

// --- 2. 256개 자식 창 각각에 물려있는 서브클래스 프로시저 ---
// 부모의 별도 렌더링 없이 이 프로시저가 256개 공간을 각각 제어합니다.
LRESULT CALLBACK TileSubclassProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam, UINT_PTR uIdSubclass, DWORD_PTR dwRefData) {
    TileData* pData = reinterpret_cast<TileData*>(dwRefData);

    switch (uMsg) {
    case WM_PAINT: {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hWnd, &ps);
        
        RECT rc;
        GetClientRect(hWnd, &rc);
        
        // 메인 부모 창의 도움 없이 자식 스스로 보관 중인 색상으로 자신을 채색 [1.21]
        HBRUSH hBrush = CreateSolidBrush(pData->color);
        FillRect(hdc, &rc, hBrush);
        DeleteObject(hBrush);

        EndPaint(hWnd, &ps);
        return 0; // 부모 창으로 메시지를 넘기지 않고 독점 렌더링 완료 [1.21]
    }

    case WM_USER_UPDATE_COLOR: {
        // 서브클래싱이 작동 중일 때만 색상을 바꾸고 그리기를 갱신 [1.21]
        pData->color = GetRandomColor();
        InvalidateRect(hWnd, NULL, FALSE);
        return 0;
    }

    case WM_LBUTTONDOWN: { // 마우스 좌클릭 시 동작
        if (pData->isSubclassed) {
            pData->isSubclassed = false;
            
            // ? [핵심 요구사항] 실행 중에 해당 자식 윈도우의 서브클래싱을 '등록 해지'
            RemoveWindowSubclass(hWnd, TileSubclassProc, uIdSubclass);
            
            // 해지되었음을 시각적으로 알리기 위해 윈도우 스타일 변경 (경계선 투명화 등)
            SetWindowTextW(hWnd, L"X"); 
            
            // 해지된 이후에는 부모의 기본 STATIC 클래스가 제어하므로 색상 타이머 갱신이 완전히 멈춥니다.
            InvalidateRect(hWnd, NULL, TRUE);
        }
        return 0;
    }

    case WM_NCDESTROY:
        // 프로그램 종료 시 잔존 메모리 안전 수거 및 자동 해지
        if (pData->isSubclassed) {
            RemoveWindowSubclass(hWnd, TileSubclassProc, uIdSubclass);
        }
        delete pData;
        break;
    }

    return DefSubclassProc(hWnd, uMsg, wParam, lParam);
}

// --- 3. 메인 부모 윈도우 프로시저 (메인 렌더링 없음) ---
LRESULT CALLBACK MainWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
    case WM_CREATE: {
        srand((unsigned int)time(NULL));
        InitCommonControls(); // 서브클래싱 API 활성화

        // 256개의 개별 자식 윈도우 생성 후 독립 서브클래스 주입
        for (int i = 0; i < 256; ++i) {
            int row = i / GRID_SIZE;
            int col = i % GRID_SIZE;
            int x = col * RECT_SIZE + 10;
            int y = row * RECT_SIZE + 10;

            // 1. 별도 렌더링 공간 매칭을 위한 STATIC 컴포넌트 생성 [1.21]
            // SS_NOTIFY를 주어야 자식 창이 마우스 클릭 메시지(WM_LBUTTONDOWN)를 직접 수신할 수 있습니다.
            g_hTiles[i] = CreateWindowExW(0, L"STATIC", L"", 
                WS_CHILD | WS_VISIBLE | SS_NOTIFY | SS_CENTER | SS_CENTERIMAGE, 
                x, y, RECT_SIZE - 2, RECT_SIZE - 2, 
                hwnd, (HMENU)(UINT_PTR)(1000 + i), GetModuleHandle(NULL), NULL);

            // 2. 동적 인스턴스 데이터 생성
            TileData* pData = new TileData();
            pData->color = GetRandomColor();
            pData->isSubclassed = true;

            // 3. 자식 인덱스(i)를 고유 서브클래스 ID로 사용하여 개별 등록 완료
            SetWindowSubclass(g_hTiles[i], TileSubclassProc, i, reinterpret_cast<DWORD_PTR>(pData));
        }

        // 150ms 단위로 전체 갱신 타이머 작동
        SetTimer(hwnd, 1, 150, NULL);
        break;
    }

    case WM_TIMER:
        if (wParam == 1) {
            // 부모는 화면을 건드리지 않고 256개 창에 갱신 신호만 라우팅 전달
            for (int i = 0; i < 256; ++i) {
                // 서브클래싱이 해지된 창은 메시지를 보내도 무시되거나 반응하지 않습니다.
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
    WNDCLASSEXW wc = { sizeof(WNDCLASSEXW), CS_HREDRAW | CS_VREDRAW, MainWndProc, 0, 0, hInstance, NULL, NULL, NULL, NULL, L"SubclassGroupClass", NULL };
    RegisterClassExW(&wc);

    HWND hwnd = CreateWindowExW(0, L"SubclassGroupClass", L"256 Multi-Subclass Registry", WS_OVERLAPPEDWINDOW ^ WS_THICKFRAME ^ WS_MAXIMIZEBOX, CW_USEDEFAULT, CW_USEDEFAULT, 435, 460, NULL, NULL, hInstance, NULL);
    ShowWindow(hwnd, nCmdShow);
    UpdateWindow(hwnd);

    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    return (int)msg.wParam;
}

