// processor.js
class DataSonifierProcessor extends AudioWorkletProcessor {
    constructor() {
        super();
        this.phase = 0;
        this.currentHz = 150; // 기본 주파수
        this.volume = 0.1;    // 기본 볼륨

        // 메인 스레드(html)로부터 실시간 데이터를 비동기로 전달받음
        this.port.onmessage = (event) => {
            const { cpu, error } = event.data;
            
            // 데이터 수치를 주파수로 변환
            this.currentHz = 100 + (cpu * 3); // 100Hz ~ 400Hz

            if (error) {
                this.volume = 0.3; // 에러 시 소리 키움
                this.currentHz = 440; // 에러 사이렌 주파수 고정
            } else {
                this.volume = 0.1;
            }
        };
    }

    // 오디오 카드가 소리를 필요로 할 때마다 128샘플씩 비동기로 호출됨 (용량 제한 없음)
    process(inputs, outputs, parameters) {
        const output = outputs[0];
        const channel = output[0]; // 모노 채널 기준

        for (let i = 0; i < channel.length; i++) {
            // 사인파 실시간 합성 연산
            channel[i] = Math.sin(this.phase) * this.volume;
            
            // 주파수에 따른 위상 누적 (샘플레이트 44100 기준)
            this.phase += (2 * Math.PI * this.currentHz) / sampleRate;
        }

        return true; // 스레드를 계속 유지
    }
}

registerProcessor('data-sonifier-processor', DataSonifierProcessor);
