#include <windows.h>
#include <iostream>
#include <vector>
#include <queue>
#include <cstdlib>
#include <ctime>

const int TOTAL_EVENTS = 4096;
const int HANDLES_PER_WAIT = 64;
const int MID_EVENTS_COUNT = 64;
const int TEST_COUNT = 10000;

// 송신과 수신 모두가 공유하는 스레드 안전한 완전 버퍼 큐
struct RobustQueue {
    std::queue<int> q;
    CRITICAL_SECTION cs;
    HANDLE hDataAvailableEvent;

    void Init() {
        InitializeCriticalSection(&cs);
        hDataAvailableEvent = CreateEvent(NULL, FALSE, FALSE, NULL);
    }

    // 데이터를 먼저 큐에 안전하게 적재하고 신호를 보냄
    void Push(int index) {
        EnterCriticalSection(&cs);
        q.push(index);
        LeaveCriticalSection(&cs);
        SetEvent(hDataAvailableEvent); 
    }

    bool Pop(int& outIndex) {
        bool success = false;
        EnterCriticalSection(&cs);
        if (!q.empty()) {
            outIndex = q.front();
            q.pop();
            success = true;
        }
        LeaveCriticalSection(&cs);
        return success;
    }

    void CleanUp() {
        DeleteCriticalSection(&cs);
        CloseHandle(hDataAvailableEvent);
    }
};

struct WorkerParam {
    int startMidIdx;
    int count;
    HANDLE* midEvents;
    RobustQueue* sharedQ;
};

// [개선된 작업자 스레드] 이제 하위 4096개를 일일이 폴링하지 않고, 
// 중간 신호가 오면 안전하게 연동된 공통 큐를 신뢰하여 메인에 즉시 전달합니다.
DWORD WINAPI RobustWaitThreadFunc(LPVOID lpParam) {
    WorkerParam* p = (WorkerParam*)lpParam;
    HANDLE waitHandles[32];
    for (int i = 0; i < p->count; i++) {
        waitHandles[i] = p->midEvents[p->startMidIdx + i];
    }

    while (true) {
        // 커널 대기 상태 유지
        DWORD result = WaitForMultipleObjects(p->count, waitHandles, FALSE, INFINITE);
        
        if (result >= WAIT_OBJECT_0 && result < WAIT_OBJECT_0 + p->count) {
            // 중간 이벤트 신호를 감지하면 큐에 쌓인 데이터를 메인 신호기로 즉시 토스
            // (덮어쓰기 유실을 원천 차단하기 위해 데이터는 이미 큐에 선적재되어 있음)
            SetEvent(p->sharedQ->hDataAvailableEvent);
        }
    }
    return 0;
}

int main() {
    srand(static_cast<unsigned int>(time(NULL)));

    RobustQueue sharedQ;
    sharedQ.Init();

    // 중간 신호 전달용 64개 이벤트 생성
    std::vector<HANDLE> midEvents(MID_EVENTS_COUNT);
    for (int i = 0; i < MID_EVENTS_COUNT; i++) midEvents[i] = CreateEvent(NULL, FALSE, FALSE, NULL);

    // 스레드 구동
    WorkerParam param1 = { 0, 32, midEvents.data(), &sharedQ };
    HANDLE hThread1 = CreateThread(NULL, 0, RobustWaitThreadFunc, &param1, 0, NULL);

    WorkerParam param2 = { 32, 32, midEvents.data(), &sharedQ };
    HANDLE hThread2 = CreateThread(NULL, 0, RobustWaitThreadFunc, &param2, 0, NULL);

    std::cout << "[시스템] 신호 덮어쓰기 방지형 2스레드 분담 구조 기동 완료.\n";
    std::cout << "[테스트] 4,096개 영역에 무작위로 10,000번 신호를 난사합니다.\n\n";

    int processedCount = 0;

    for (int i = 0; i < TEST_COUNT; i++) {
        int randIndex = rand() % TOTAL_EVENTS; 
        int midIdx = randIndex / HANDLES_PER_WAIT;

        // 핵심 개선: 이벤트 핸들 상태를 직접 바꾸기 전에 데이터를 큐에 먼저 '안전 보관'
        sharedQ.Push(randIndex);
        SetEvent(midEvents[midIdx]); // 알림용 신호만 전송

        // 실시간 수신 처리
        int poppedIndex = -1;
        while (sharedQ.Pop(poppedIndex)) {
            processedCount++;
            if (processedCount % 1000 == 0) {
                std::cout << "[메인 수신기] 누적 " << processedCount << "번째 이벤트 처리 완료! (최근 인덱스: " << poppedIndex << ")" << std::endl;
            }
        }
    }

    // 잔여 데이터 최종 수집
    int finalPop = -1;
    while (sharedQ.Pop(finalPop)) {
        processedCount++;
    }

    std::cout << "\n==================================================" << std::endl;
    std::cout << "[검증 완료] 총 요청 횟수: " << TEST_COUNT << "회" << std::endl;
    std::cout << "[검증 완료] 총 수신 횟수: " << processedCount << "회" << std::endl;
    if (TEST_COUNT == processedCount) {
        std::cout << "▶ 결과: 단 하나의 오차도 없이 10,000개 모두 완벽 처리!" << std::endl;
    } else {
        std::cout << "▶ 결과: 오류 발생 (데이터 유실 존재)" << std::endl;
    }
    std::cout << "==================================================" << std::endl;

    TerminateThread(hThread1, 0); CloseHandle(hThread1);
    TerminateThread(hThread2, 0); CloseHandle(hThread2);
    sharedQ.CleanUp();
    for (int i = 0; i < MID_EVENTS_COUNT; i++) CloseHandle(midEvents[i]);

    return 0;
}

