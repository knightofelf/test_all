# 64*64WaitForMultipleObjects
가상 중첩 대기 스레드 함수 Virtual nested wait thread function.

WaitForMultipleObjects 2개를 중첩 사용해서. 4096개의 이벤트를 대기 할 수 있다.??

RegisterWaitForSingleObject 추가

// 그냥. push pop... ㅡ_ㅡ;;

<pre>
// 이벤트 스케줄러
대기 = 미래의 기록
transaction push pop

// 기록
A가 대기중 
B가 대기중 

// 실행
읽기
읽기
</pre>
