#include <windows.h>
#include <process.h>
#include <iostream>
#include <vector>

#define TOTAL_HANDLES 4096
#define BATCH_SIZE 64
#define GROUPS_PER_THREAD 32 // 32그룹 * 64개 = 2048개 (스레드당 담당 개수)

// 스레드 파라미터 구조체
struct VirtualWaitParam {
    std::vector<HANDLE> myHandles; // 담당할 2048개의 핸들
};

// 가상 중첩 대기 스레드 함수
unsigned __stdcall VirtualWaitThread(void* pParam) {
    VirtualWaitParam* data = static_cast<VirtualWaitParam*>(pParam);
    HANDLE currentBatch[BATCH_SIZE];

    while (true) {
        // 2,048개의 핸들을 64개씩 쪼개서 32번 루프 순회 (가상 트리 시프트)
        for (int g = 0; g < GROUPS_PER_THREAD; g++) {
            
            // 64개 묶음 세팅
            for (int i = 0; i < BATCH_SIZE; i++) {
                currentBatch[i] = data->myHandles[g * BATCH_SIZE + i];
            }

            // 타임아웃을 1ms로 주어 4,096개를 아주 빠르게 훑음 (체크 앤 패스)
            DWORD result = WaitForMultipleObjects(BATCH_SIZE, currentBatch, FALSE, 1);

            if (result >= WAIT_OBJECT_0 && result < WAIT_OBJECT_0 + BATCH_SIZE) {
                int localIndex = result - WAIT_OBJECT_0;
                int globalIndex = (g * BATCH_SIZE) + localIndex;
                
                std::cout << "신호 발생 감지! 내부 인덱스: " << globalIndex << std::endl;
                // [주의] 수동 리셋 이벤트라면 여기서 ResetEvent 처리 필요
            }
            else if (result == WAIT_TIMEOUT) {
                // 신호가 없으면 즉시 다음 64개 그룹으로 이동
                continue; 
            }
        }
        // CPU 과점유 방지를 위한 미세한 휴식
        Sleep(1); 
    }
    return 0;
}

int main() {
    // 1. 가상 테스트용 4,096개 이벤트 핸들 생성
    std::vector<HANDLE> allHandles(TOTAL_HANDLES);
    for (int i = 0; i < TOTAL_HANDLES; i++) {
        allHandles[i] = CreateEvent(NULL, FALSE, FALSE, NULL); // 자동 리셋 이벤트
    }

    // 2. 스레드 2개에 각각 2,048개씩 분배
    VirtualWaitParam param1, param2;
    for (int i = 0; i < 2048; i++) param1.myHandles.push_back(allHandles[i]);
    for (int i = 2048; i < 4096; i++) param2.myHandles.push_back(allHandles[i]);

    // 3. 2개의 스레드만 구동
    HANDLE hThread1 = (HANDLE)_beginthreadex(NULL, 0, VirtualWaitThread, &param1, 0, NULL);
    HANDLE hThread2 = (HANDLE)_beginthreadex(NULL, 0, VirtualWaitThread, &param2, 0, NULL);

    // 테스트용: 500번 핸들을 강제로 시그널 상태로 만듦
    SetEvent(allHandles[500]);

    // 메인 스레드 대기
    HANDLE threads[2] = { hThread1, hThread2 };
    WaitForMultipleObjects(2, threads, TRUE, INFINITE);

    // 핸들 정리
    for (int i = 0; i < TOTAL_HANDLES; i++) CloseHandle(allHandles[i]);
    return 0;
}

