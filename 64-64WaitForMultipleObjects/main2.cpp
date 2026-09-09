#include <windows.h>
#include <process.h>
#include <iostream>
#include <vector>
#include <random> // 랜덤 발생용 헤더

#define TOTAL_HANDLES 4096
#define BATCH_SIZE 64
#define GROUPS_PER_THREAD 32 

struct VirtualWaitParam {
    int threadId;
    std::vector<HANDLE> myHandles; 
};

// 가상 중첩 대기 스레드 함수
unsigned __stdcall VirtualWaitThread(void* pParam) {
    VirtualWaitParam* data = static_cast<VirtualWaitParam*>(pParam);
    HANDLE currentBatch[BATCH_SIZE];

    while (true) {
        for (int g = 0; g < GROUPS_PER_THREAD; g++) {
            for (int i = 0; i < BATCH_SIZE; i++) {
                currentBatch[i] = data->myHandles[g * BATCH_SIZE + i];
            }

            // 1ms 동안만 대기하고 다음 64개 묶음으로 이동
            DWORD result = WaitForMultipleObjects(BATCH_SIZE, currentBatch, FALSE, 1);

            if (result >= WAIT_OBJECT_0 && result < WAIT_OBJECT_0 + BATCH_SIZE) {
                int localIndex = result - WAIT_OBJECT_0;
                // 전역 인덱스 계산 (스레드 담당 구역에 맞춰 보정)
                int globalIndex = (data->threadId * 2048) + (g * BATCH_SIZE) + localIndex;
                
                std::cout << "[스레드 " << data->threadId << "] " 
                          << globalIndex << "번 핸들에서 신호 감지 완료!" << std::endl;
            }
        }
        Sleep(1); // CPU 과부하 방지
    }
    return 0;
}

int main() {
    std::cout << "4096개 가상 중첩 대기 및 랜덤 이벤트 테스트 시작..." << std::endl;

    // 1. 4,096개의 자동 리셋 이벤트 생성
    std::vector<HANDLE> allHandles(TOTAL_HANDLES);
    for (int i = 0; i < TOTAL_HANDLES; i++) {
        allHandles[i] = CreateEvent(NULL, FALSE, FALSE, NULL); 
    }

    // 2. 스레드 2개에 각각 2,048개씩 분배
    VirtualWaitParam param1, param2;
    param1.threadId = 0;
    param2.threadId = 1;
    for (int i = 0; i < 2048; i++) param1.myHandles.push_back(allHandles[i]);
    for (int i = 2048; i < 4096; i++) param2.myHandles.push_back(allHandles[i]);

    // 3. 작업 스레드 2개 가동
    HANDLE hThread1 = (HANDLE)_beginthreadex(NULL, 0, VirtualWaitThread, &param1, 0, NULL);
    HANDLE hThread2 = (HANDLE)_beginthreadex(NULL, 0, VirtualWaitThread, &param2, 0, NULL);

    // 4. 메인 스레드에서 랜덤하게 이벤트를 발생시키는 시뮬레이션 루프
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> dis(0, TOTAL_HANDLES - 1); // 0 ~ 4095 사이 난수

    for (int test = 1; test <= 5; test++) {
        Sleep(1500); // 1.5초마다 한 번씩 이벤트 트리거

        int luckyNumber = dis(gen); // 무작위 타깃 인덱스 추출
        std::cout << "\n[메인] " << luckyNumber << "번 핸들에 랜덤 신호 발송!" << std::endl;
        
        SetEvent(allHandles[luckyNumber]); // 해당 이벤트 시그널링
    }

    Sleep(2000); // 마지막 신호 처리 대기 시간
    std::cout << "\n테스트 종료." << std::endl;

    // 핸들 및 스레드 정리
    TerminateThread(hThread1, 0);
    TerminateThread(hThread2, 0);
    for (int i = 0; i < TOTAL_HANDLES; i++) CloseHandle(allHandles[i]);
    CloseHandle(hThread1);
    CloseHandle(hThread2);

    return 0;
}

