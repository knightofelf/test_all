#include <windows.h>
#include <stdio.h>

const int TARGET_COUNT = 10000;

// IOCP 패킷에 실어 보낼 사용자 정의 구조체 (채널 ID 저장용)
typedef struct _IO_DATA {
    int channelId;
} IO_DATA;

// IOCP 완료 패킷을 수신하여 처리하는 작업자 스레드 (Worker Thread)
DWORD WINAPI IocpWorkerThreadProc(LPVOID lpParam) {
    HANDLE hIOCP = (HANDLE)lpParam;
    DWORD dwBytesTransferred = 0;
    ULONG_PTR completionKey = 0;
    LPOVERLAPPED lpOverlapped = NULL;
    int totalCount = 0;

    printf("[IOCP 스레드] 128채널 실시간 감시 및 대기를 시작합니다. (64개 제한 없음)\n\n");

    while (true) {
        // [핵심 대기] 64개 제한 없이 포트에 쌓이는 모든 신호를 INFINITE로 대기 (CPU 0%)
        // GetQueuedCompletionStatus가 WaitForMultipleObjects의 역할을 완벽히 대체합니다.
        BOOL bSuccess = GetQueuedCompletionStatus(
            hIOCP,
            &dwBytesTransferred,   // 전송된 바이트 수 (여기서는 사용 안 함)
            &completionKey,        // CompletionKey (종료 신호 감지용)
            &lpOverlapped,         // 전달된 데이터 구조체 포인터
            INFINITE               // 무한 대기
        );

        // 종료 패킷 확인 (completionKey가 9999이면 루프 탈출)
        if (completionKey == 9999) {
            break;
        }

        if (bSuccess && lpOverlapped != NULL) {
            // 전달받은 구조체 포인터를 역형변환하여 데이터 복원
            IO_DATA* pData = (IO_DATA*)lpOverlapped;
            totalCount++;

            // 어떤 채널에서 신호가 왔는지 정확하게 유실 없이 출력
            printf("[IOCP 감지] 채널 ID %3d번 신호 처리 완료! (현재 누적: %5d / %d)\n", 
                   pData->channelId, totalCount, TARGET_COUNT);

            // 동적 할당했던 메모리 해제
            delete pData;

            // 목표치에 도달하면 메인 스레드와 통신하지 않고 본인 루프 종료 준비 가능
            if (totalCount >= TARGET_COUNT) {
                break;
            }
        }
    }

    printf("[IOCP 스레드] 10,000번 처리를 무유실 완료하고 안전하게 종료합니다.\n");
    return 0;
}

int main() {
    // 1. IOCP 커널 객체 생성
    // 동시에 실행할 스레드 수를 1개로 제한 (싱글 작업자 스레드 구조)
    HANDLE hIOCP = CreateIoCompletionPort(INVALID_HANDLE_VALUE, NULL, 0, 1);
    if (hIOCP == NULL) {
        printf("IOCP 생성 실패: %lu\n", GetLastError());
        return 1;
    }

    // 2. IOCP 포트를 감시할 작업자 스레드 가동
    HANDLE hWorkerThread = CreateThread(NULL, 0, IocpWorkerThreadProc, hIOCP, 0, NULL);

    printf("IOCP 기반 초고속 무유실 시뮬레이션 시작 (Sleep 없음)\n");
    Sleep(500); // 스레드 대기 상태 안정화

    // 3. [시뮬레이션] 128개 채널 중 무작위로 10,000번 신호 난사
    // IOCP는 커널 큐(Queue)를 사용하므로 Sleep이 없어도 신호가 절대 씹히지 않고 차곡차곡 쌓입니다.
    for (int i = 0; i < TARGET_COUNT; i++) {
        int targetChannelId = rand() % 128; // 0 ~ 127번 채널 무작위 선정

        // 각 신호마다 채널 ID 정보를 담을 메모리 할당
        IO_DATA* pData = new IO_DATA;
        pData->channelId = targetChannelId;

        // ReleaseSemaphore나 SetEvent 대신 PostQueuedCompletionStatus를 사용하여 신호 전송!
        PostQueuedCompletionStatus(hIOCP, 0, 0, (LPOVERLAPPED)pData);
    }

    printf("[메인 스레드] 10,000번 신호 큐 투입 완료. IOCP 처리를 기다립니다...\n\n");

    // 4. 작업자 스레드가 10,000번을 다 처리하고 종료할 때까지 메인이 최종 대기
    WaitForSingleObject(hWorkerThread, INFINITE);

    // 5. 안전한 자원 정리
    // 만약 스레드가 살아있다면 종료 패킷을 보냄 (CompletionKey = 9999)
    PostQueuedCompletionStatus(hIOCP, 0, 9999, NULL);
    
    CloseHandle(hWorkerThread);
    CloseHandle(hIOCP);

    printf("\n[최종 결과] IOCP 모델을 통해 128채널 동시 대기 및 10,000회 무유실 처리에 성공했습니다.\n");
    return 0;
}

