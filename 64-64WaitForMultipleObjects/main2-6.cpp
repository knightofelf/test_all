#include <windows.h>
#include <stdio.h>

#define MAX_OBJECTS_PER_THREAD 64

CRITICAL_SECTION g_cs;
int g_totalEventCount = 0;
const int TARGET_COUNT = 10000;

typedef struct _THREAD_PARAM {
    HANDLE hSemaphores[MAX_OBJECTS_PER_THREAD]; // 세마포어 63개 + 종료 이벤트 1개
    int objectIds[MAX_OBJECTS_PER_THREAD];     // ID 매핑 배열
    HANDLE hExitEvent;
    int threadId;
} THREAD_PARAM;

DWORD WINAPI IdSemaphoreThreadProc(LPVOID lpParam) {
    THREAD_PARAM* pParam = (THREAD_PARAM*)lpParam;

    while (true) {
        // 세마포어 배열 대기 (신호 유실 없음!)
        DWORD dwResult = WaitForMultipleObjects(MAX_OBJECTS_PER_THREAD, pParam->hSemaphores, FALSE, INFINITE);

        // 종료 신호 확인
        if (dwResult == WAIT_OBJECT_0 + (MAX_OBJECTS_PER_THREAD - 1)) break;

        if (dwResult >= WAIT_OBJECT_0 && dwResult < WAIT_OBJECT_0 + (MAX_OBJECTS_PER_THREAD - 1)) {
            int localIndex = dwResult - WAIT_OBJECT_0;
            int uniqueId = pParam->objectIds[localIndex]; 

            EnterCriticalSection(&g_cs);
            g_totalEventCount++;
            
            printf("[스레드 %d] 세마포어 ID %d번 처리 완료! (현재 누적: %d)\n", 
                   pParam->threadId, uniqueId, g_totalEventCount);

            if (g_totalEventCount >= TARGET_COUNT) {
                SetEvent(pParam->hExitEvent); // 목표 달성 시 종료 신호 발생
                LeaveCriticalSection(&g_cs);
                break;
            }
            LeaveCriticalSection(&g_cs);
        }
    }
    return 0;
}

int main() {
    InitializeCriticalSection(&g_cs);
    HANDLE hGlobalExitEvent = CreateEvent(NULL, TRUE, FALSE, NULL);

    // 1. 126개의 세마포어 배열 선언 및 생성 (초기값 0, 최대치 10000)
    HANDLE hAllSemaphores[126];
    for (int i = 0; i < 126; i++) {
        hAllSemaphores[i] = CreateSemaphore(NULL, 0, TARGET_COUNT, NULL);
    }

    THREAD_PARAM param1, param2;
    param1.threadId = 1; param1.hExitEvent = hGlobalExitEvent;
    param2.threadId = 2; param2.hExitEvent = hGlobalExitEvent;

    for (int i = 0; i < 63; i++) {
        param1.hSemaphores[i] = hAllSemaphores[i];
        param1.objectIds[i] = i;

        param2.hSemaphores[i] = hAllSemaphores[i + 63];
        param2.objectIds[i] = i + 63;
    }
    param1.hSemaphores[63] = hGlobalExitEvent;
    param2.hSemaphores[63] = hGlobalExitEvent;

    HANDLE hWorkerThreads[2]; // 크기 2의 배열로 올바르게 선언
    hWorkerThreads[0] = CreateThread(NULL, 0, IdSemaphoreThreadProc, &param1, 0, NULL);
    hWorkerThreads[1] = CreateThread(NULL, 0, IdSemaphoreThreadProc, &param2, 0, NULL);

    printf("세마포어 ID 기반 10,000번 무유실 동기화 테스트 시작\n");

    // 2. Sleep 없이 초고속으로 신호 방출
    for (int i = 0; i < TARGET_COUNT; i++) {
        int targetId = rand() % 126;
        ReleaseSemaphore(hAllSemaphores[targetId], 1, NULL); // 카운트를 1씩 올림 (유실 안 됨)
    }

    // 3. 메인 스레드에서 스레드 종료 대기
    SetEvent(hGlobalExitEvent);
    WaitForMultipleObjects(2, hWorkerThreads, TRUE, INFINITE);

    printf("\n최종 목적 달성! 총 처리 횟수: %d\n", g_totalEventCount);

    // 자원 해제
    for (int i = 0; i < 2; i++) CloseHandle(hWorkerThreads[i]);
    for (int i = 0; i < 126; i++) CloseHandle(hAllSemaphores[i]);
    CloseHandle(hGlobalExitEvent);
    DeleteCriticalSection(&g_cs);
    return 0;
}

