#include <windows.h>
#include <iostream>
#include <vector>
#include <random>

#define TOTAL_HANDLES 4096

// 콜백 함수에 전달할 사용자 데이터 구조체
struct ContextData {
    int eventIndex; // 몇 번째 이벤트인지 기록
};

// 1. 이벤트가 시그널 상태가 되면 Windows 스레드 풀이 자동으로 호출하는 콜백 함수
VOID CALLBACK WaitOrTimerCallback(PVOID lpParameter, BOOLEAN TimerOrWaitFired) {
    // 타임아웃으로 깨어난 것이 아니라 실제 신호로 깨어난 경우만 처리
    if (!TimerOrWaitFired) {
        ContextData* data = static_cast<ContextData*>(lpParameter);
        std::cout << "[콜백] " << data->eventIndex << "번 핸들에서 신호 감지! (CPU 점유율 없이 즉시 실행)\n";
    }
}

int main() {
    std::cout << "RegisterWaitForSingleObject 기반 4096개 이벤트 대기 시작...\n";

    // 데이터 저장을 위한 벡터 준비
    std::vector<HANDLE> allEvents(TOTAL_HANDLES);
    std::vector<HANDLE> waitHandles(TOTAL_HANDLES); // 등록된 대기 객체 핸들
    std::vector<ContextData*> contexts(TOTAL_HANDLES);

    // 2. 4,096개의 이벤트 생성 및 스레드 풀에 등록
    for (int i = 0; i < TOTAL_HANDLES; i++) {
        // 자동 리셋 이벤트 생성
        allEvents[i] = CreateEvent(NULL, FALSE, FALSE, NULL);
        
        // 콜백에 넘겨줄 컨텍스트 데이터 생성
        contexts[i] = new ContextData{ i };

        // 무한대기(INFINITE)로 등록하므로, 신호가 오기 전까지 CPU를 전혀 쓰지 않습니다.
        BOOL success = RegisterWaitForSingleObject(
            &waitHandles[i],       // [출력] 등록된 대기 핸들을 저장할 변수
            allEvents[i],          // [입력] 감시할 실제 이벤트 핸들
            WaitOrTimerCallback,   // [입력] 신호 감지 시 실행될 콜백 함수
            contexts[i],           // [입력] 콜백 함수로 넘겨줄 파라미터
            INFINITE,              // [입력] 타임아웃 없음 (무한 대기)
            WT_EXECUTEDEFAULT      // [입력] 스레드 풀의 기본 작업 스레드에서 콜백 실행
        );

        if (!success) {
            std::cerr << i << "번 핸들 등록 실패! 오류 코드: " << GetLastError() << "\n";
        }
    }

    std::cout << "4096개 핸들 등록 완료. 현재 대기 중 (CPU 점유율 0%)\n";

    // 3. 메인 스레드에서 무작위로 이벤트를 발생시키는 시뮬레이션
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> dis(0, TOTAL_HANDLES - 1);

    for (int test = 1; test <= 5; test++) {
        Sleep(1500); // 1.5초 대기 (이 동안 프로그램은 완전히 잠들어 있습니다)

        int luckyNumber = dis(gen);
        std::cout << "\n[메인] " << luckyNumber << "번 핸들에 랜덤 신호 발송!\n";
        
        SetEvent(allEvents[luckyNumber]); // 신호를 주는 순간 콜백 함수가 즉시 실행됩니다.
    }

    Sleep(2000); // 마지막 콜백 처리 대기
    std::cout << "\n테스트 완료. 자원 해제 중...\n";

    // 4. 등록 해제 및 메모리 정리 (Clean up)
    for (int i = 0; i < TOTAL_HANDLES; i++) {
        // UnregisterWaitEx를 호출하여 스레드 풀 대기를 안전하게 해제
        UnregisterWaitEx(waitHandles[i], INVALID_HANDLE_VALUE);
        CloseHandle(allEvents[i]);
        delete contexts[i];
    }

    return 0;
}

