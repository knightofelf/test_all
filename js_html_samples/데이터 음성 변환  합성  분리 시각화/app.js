const canvas = document.getElementById('visualizer');
const canvasCtx = canvas.getContext('2d');
const btnRecord = document.getElementById('btn-record');

let audioCtx;
let analyser;
let stream;

btnRecord.addEventListener('click', async () => {
    if (audioCtx) return; // 이미 실행 중이면 중복 실행 방지
    
    // 마이크 권한 요청 및 오디오 컨텍스트 생성
    stream = await navigator.mediaDevices.getUserMedia({ audio: true });
    audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    analyser = audioCtx.createAnalyser();
    
    const source = audioCtx.createMediaStreamSource(stream);
    source.connect(analyser);
    
    analyser.fftSize = 2048;
    const bufferLength = analyser.frequencyBinCount;
    const dataArray = new Uint8Array(bufferLength);
    
    // 실시간 그리기 함수
    function draw() {
        requestAnimationFrame(draw);
        analyser.getByteTimeDomainData(dataArray); // 파형 데이터 가져오기
        
        canvasCtx.fillStyle = '#222';
        canvasCtx.fillRect(0, 0, canvas.width, canvas.height);
        canvasCtx.lineWidth = 2;
        canvasCtx.strokeStyle = '#00ffcc';
        canvasCtx.beginPath();
        
        const sliceWidth = canvas.width * 1.0 / bufferLength;
        let x = 0;
        
        for (let i = 0; i < bufferLength; i++) {
            const v = dataArray[i] / 128.0;
            const y = v * canvas.height / 2;
            
            if (i === 0) canvasCtx.moveTo(x, y);
            else canvasCtx.lineTo(x, y);
            
            x += sliceWidth;
        }
        
        canvasCtx.lineTo(canvas.width, canvas.height / 2);
        canvasCtx.stroke();
    }
    draw();
    btnRecord.textContent = "녹음 및 시각화 중...";
    btnRecord.disabled = true;
});


// 브라우저 호환성 처리 (Chrome, Safari 등)
const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
const recognition = new SpeechRecognition();

recognition.lang = 'ko-KR';        // 인식 언어 설정
recognition.interimResults = true; // 중간 결과 반영 여부
recognition.continuous = true;     // 연속 인식 여부

const sttResult = document.getElementById('stt-result');
document.getElementById('btn-stt-start').addEventListener('click', () => recognition.start());
document.getElementById('btn-stt-stop').addEventListener('click', () => recognition.stop());

recognition.onresult = (event) => {
    let text = '';
    for (let i = event.resultIndex; i < event.results.length; i++) {
        text += event.results[i][0].transcript;
    }
    sttResult.textContent = text;
};


const ttsButton = document.getElementById('btn-tts');
const ttsText = document.getElementById('tts-text');

ttsButton.addEventListener('click', () => {
    const textToSpeak = ttsText.value;
    if (!textToSpeak) return;

    // TTS 객체 생성 및 설정
    const utterance = new SpeechSynthesisUtterance(textToSpeak);
    utterance.lang = 'ko-KR'; // 한국어 설정
    utterance.rate = 1.0;     // 발화 속도 (0.1 ~ 10)
    utterance.pitch = 1.0;    // 목소리 톤 (0 ~ 2)

    // 재생
    window.speechSynthesis.speak(utterance);
});



