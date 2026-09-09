// 전역 변수 및 오디오 컨텍스트 선언
let audioCtx;
let mixedAudioBuffer = null; // 합성된 데이터가 저장될 공간
let sourceNode = null;
let animationId;

// HTML 요소 맵핑
const btnMix = document.getElementById('btn-mix');
const btnPlay = document.getElementById('btn-play');
const btnStop = document.getElementById('btn-stop');
const mixStatus = document.getElementById('mix-status');

const canvasLeft = document.getElementById('canvas-left');
const canvasRight = document.getElementById('canvas-right');
const ctxLeft = canvasLeft.getContext('2d');
const ctxRight = canvasRight.getContext('2d');

// 크기 초기화
canvasLeft.width = canvasRight.width = 600;
canvasLeft.height = canvasRight.height = 120;

/**
 * [기능 1 & 2] 데이터 변환 및 여러 음원 합성
 * 브라우저의 TTS(SpeechSynthesis) 결과물을 오디오 데이터(Buffer)로 가져와
 * 각각 좌/우 채널에 배치하여 하나의 스테레오 파일로 합성합니다.
 */
btnMix.addEventListener('click', async () => {
    mixStatus.textContent = "음성 변환 및 합성 중...";
    btnMix.disabled = true;

    if (!audioCtx) {
        audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    }

    const textL = document.getElementById('text-left').value;
    const textR = document.getElementById('text-right').value;

    try {
        // 두 개의 독립된 오디오 데이터를 가상으로 생성 (여기서는 예시를 위해 4초짜리 가상 버퍼 공간에 두 목소리 주파수 성분을 믹싱하는 시뮬레이션을 생성합니다)
        // 실제 TTS 오디오 캡처는 MediaRecorder를 쓰거나, 브라우저가 제공하는 가상 오디오 노드를 활용합니다.
        const duration = 4.0; 
        const sampleRate = audioCtx.sampleRate;
        const frameCount = sampleRate * duration;
        
        // 2채널(스테레오) 오디오 버퍼 생성
        mixedAudioBuffer = audioCtx.createBuffer(2, frameCount, sampleRate);
        
        const leftChannelData = mixedAudioBuffer.getChannelData(0);  // 1번 트랙 공간
        const rightChannelData = mixedAudioBuffer.getChannelData(1); // 2번 트랙 공간

        // [합성 연산] 간단한 주파수 신호 조합으로 두 개의 서로 다른 신호 데이터를 물리적 합성
        // 현실에서는 서로 다른 오디오 파일을 fetch로 받아와서 섞는 연산과 동일합니다.
        for (let i = 0; i < frameCount; i++) {
            // 트랙 1 신호 생성 (예: 220Hz 소리 + 랜덤 변조 = 가상 목소리 1)
            leftChannelData[i] = Math.sin(2 * Math.PI * 220 * (i / sampleRate)) * (0.5 * Math.sin(i/5000));
            // 트랙 2 신호 생성 (예: 440Hz 소리 + 랜덤 변조 = 가상 목소리 2)
            rightChannelData[i] = Math.sin(2 * Math.PI * 440 * (i / sampleRate)) * (0.5 * Math.cos(i/6000));
        }

        mixStatus.textContent = "✅ 합성 완료! '분리 재생' 버튼을 누르세요.";
        btnPlay.disabled = false;
    } catch (e) {
        mixStatus.textContent = "오류 발생: " + e.message;
    } finally {
        btnMix.disabled = false;
    }
});

/**
 * [기능 3 & 4] 음원 분리 및 독립 시각화
 * 합성된 2채널 버퍼를 재생하면서, ChannelSplitter를 이용해 
 * 실시간으로 2개의 단일 채널로 쪼개고 각각 다른 비주얼라이저로 보냅니다.
 */
btnPlay.addEventListener('click', () => {
    if (!mixedAudioBuffer) return;

    // 기존 재생 중인 노드가 있다면 정지
    if (sourceNode) sourceNode.stop();

    // 1. 소스 노드 생성 및 합성 데이터 할당
    sourceNode = audioCtx.createBufferSource();
    sourceNode.buffer = mixedAudioBuffer;

    // 2. [분리 핵심] 채널 스플리터 노드 생성 (2개의 출력 채널로 분리)
    const splitter = audioCtx.createChannelSplitter(2);

    // 3. 각 트랙(채널)을 독립적으로 분석할 분석기(Analyser) 생성
    const analyserLeft = audioCtx.createAnalyser();
    const analyserRight = audioCtx.createAnalyser();
    analyserLeft.fftSize = analyserRight.fftSize = 1024;

    // 4. 파이프라인 연결 (소스 ➔ 분리 기기 ➔ 각각의 분석기)
    sourceNode.connect(splitter);
    
    splitter.connect(analyserLeft, 0);  // 0번 채널(Left)을 왼쪽 분석기에 연결
    splitter.connect(analyserRight, 1); // 1번 채널(Right)을 오른쪽 분석기에 연결

    // 최종 스피커 출력에는 두 채널이 모두 들리도록 메인 출력에 연결
    analyserLeft.connect(audioCtx.destination);
    analyserRight.connect(audioCtx.destination);

    // 5. 실시간 시각화 데이터 배열 생성
    const bufferLength = analyserLeft.frequencyBinCount;
    const dataArrayL = new Uint8Array(bufferLength);
    const dataArrayR = new Uint8Array(bufferLength);

    // 6. 렌더링 루프 실행
    function render() {
        animationId = requestAnimationFrame(render);

        // 각각의 분석기에서 독립된 파형 데이터 추출 (분리 검증)
        analyserLeft.getByteTimeDomainData(dataArrayL);
        analyserRight.getByteTimeDomainData(dataArrayR);

        // 왼쪽 채널 그리기 (녹색 파형)
        drawWaveform(ctxLeft, canvasLeft, dataArrayL, bufferLength, '#00ff66');
        // 오른쪽 채널 그리기 (부드러운 청록색 파형)
        drawWaveform(ctxRight, canvasRight, dataArrayR, bufferLength, '#00bcff');
    }

    sourceNode.start();
    render();

    btnPlay.disabled = true;
    btnStop.disabled = false;

    sourceNode.onended = () => {
        btnPlay.disabled = false;
        btnStop.disabled = true;
        cancelAnimationFrame(animationId);
    };
});

// 재생 정지
btnStop.addEventListener('click', () => {
    if (sourceNode) {
        sourceNode.stop();
        cancelAnimationFrame(animationId);
    }
});

/**
 * 공통 캔버스 파형 드로잉 함수
 */
function drawWaveform(ctx, canvas, dataArray, bufferLength, color) {
    ctx.fillStyle = '#111';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.lineWidth = 2;
    ctx.strokeStyle = color;
    ctx.beginPath();

    const sliceWidth = canvas.width / bufferLength;
    let x = 0;

    for (let i = 0; i < bufferLength; i++) {
        const v = dataArray[i] / 128.0;
        const y = (v * canvas.height) / 2;

        if (i === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);

        x += sliceWidth;
    }
    ctx.lineTo(canvas.width, canvas.height / 2);
    ctx.stroke();
}
