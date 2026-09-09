#include <windows.h>
#include <stdio.h>

typedef struct _CONTROL_PARAM {
    HANDLE hExternalThreadEvent; // 외부 스레드가 메인 루프를 깨울 때 쓸 이벤트
    HANDLE hAckEvent;            // 메인 루프가 처리를 완료했다고 외부 스레드에 알려줄 응답 이벤트
    bool bShouldExit;            
    int cnt;
} CONTROL_PARAM;

// 1. 외부 작업을 시뮬레이션하는 별도 스레드 함수
DWORD WINAPI ExternalTriggerThreadProc(LPVOID lpParam) {
    CONTROL_PARAM* pParam = (CONTROL_PARAM*)lpParam;
    
    printf("[외부 스레드] 가동 시작. 1초 후 시뮬레이션을 시작합니다...\n");
    Sleep(1000); 

    for(int i = 0; i < 1000; i++) {
        // [작업 1 요청]
        pParam->bShouldExit = false; 
        SetEvent(pParam->hExternalThreadEvent); // 메인 깨우기
        
        // 중요: 메인 스레드가 이 신호를 감지하고 처리할 때까지 대기! (유실 차단)
        WaitForSingleObject(pParam->hAckEvent, INFINITE); 

        pParam->cnt++;

        // [작업 2 요청]
        pParam->bShouldExit = true;  
        SetEvent(pParam->hExternalThreadEvent); // 메인 깨우기
        
        // 메인 스레드가 처리할 때까지 대기!
        WaitForSingleObject(pParam->hAckEvent, INFINITE); 
    }

    printf("[외부 스레드] 2000번의 신호 발송을 유실 없이 완벽히 마쳤습니다.\n");
    return 0;
}

int main() {
    CONTROL_PARAM ctrlParam;
    ctrlParam.hExternalThreadEvent = CreateEvent(NULL, FALSE, FALSE, NULL); // Auto-Reset
    ctrlParam.hAckEvent = CreateEvent(NULL, FALSE, FALSE, NULL);            // Auto-Reset (확인 응답용)
    ctrlParam.bShouldExit = false;
    ctrlParam.cnt = 0;
    
    HANDLE Group1[64];
    HANDLE Group2[64];

    for (int i = 0; i < 63; i++) {
        Group1[i] = CreateEvent(NULL, FALSE, FALSE, NULL);
        Group2[i] = CreateEvent(NULL, FALSE, FALSE, NULL);
    }
    Group1[63] = ctrlParam.hExternalThreadEvent;
    Group2[63] = ctrlParam.hExternalThreadEvent;

    HANDLE hExternalThread = CreateThread(NULL, 0, ExternalTriggerThreadProc, &ctrlParam, 0, NULL);

    printf("메인 공정 루프 가동 시작.\n");

    bool bMainLoopRun = true;
    while (bMainLoopRun) {
        
        // [단계 1] A그룹 대기
        DWORD ret1 = WaitForMultipleObjects(64, Group1, FALSE, INFINITE);
        if (ret1 == WAIT_OBJECT_0 + 63) {
            printf("[메인 루프] 1단계 신호 감지! 현재 cnt: %d\n", ctrlParam.cnt);
            
            // 처리 끝났음을 외부 스레드에 알림 -> 외부 스레드가 다음 루프 진행 가능
            SetEvent(ctrlParam.hAckEvent); 
        }

        // [단계 2] B그룹 대기
        DWORD ret2 = WaitForMultipleObjects(64, Group2, FALSE, INFINITE);
        if (ret2 == WAIT_OBJECT_0 + 63) {
            printf("[메인 루프] 2단계 신호 감지! 현재 cnt: %d\n", ctrlParam.cnt);
            
            // 처리 끝났음을 외부 스레드에 알림
            SetEvent(ctrlParam.hAckEvent); 

            // 안전한 종료 조건 체크 (외부 스레드 발송이 완료된 시점)
            if (ctrlParam.cnt >= 1000) {
                bMainLoopRun = false;
                break;
            }
        }
    }

    WaitForSingleObject(hExternalThread, INFINITE); 
    CloseHandle(hExternalThread);
    
    for (int i = 0; i < 63; i++) {
        CloseHandle(Group1[i]);
        CloseHandle(Group2[i]);
    }
    CloseHandle(ctrlParam.hExternalThreadEvent);
    CloseHandle(ctrlParam.hAckEvent);

    printf("모든 신호가 순서대로 정밀 동기화되어 안전하게 종료되었습니다.\n");
    return 0;
}

