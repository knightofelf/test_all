const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');

// 게임 상태 변수
let turn = 1; 
let isFlying = false;
let buildings = [];

// 고릴라 위치 설정
const gorilla1 = { x: 60, y: 0, width: 32, height: 32 };
const gorilla2 = { x: 680, y: 0, width: 32, height: 32 };

// 물리 상수
const gBig = 10n; // 중력 가속도 정수형 (10 m/s²)
const SCALE = 1000000n; // 삼각함수 정밀도 보정 배율

// 부메랑 객체
let boomerang = { x: 0, y: 0, vx: 0, vy: 0, t: 0, angle: 0 };

// 건물 및 지형 무작위 생성
function generateTerrain() {
    buildings = [];
    let currentX = 0;
    while (currentX < canvas.width) {
        let bWidth = Math.floor(Math.random() * 40) + 50;
        let bHeight = Math.floor(Math.random() * 150) + 100;
        if (currentX + bWidth > canvas.width) bWidth = canvas.width - currentX;
        buildings.push({ x: currentX, y: canvas.height - bHeight, w: bWidth, h: bHeight });
        currentX += bWidth;
    }
    gorilla1.y = buildings[0].y - gorilla1.height;
    gorilla2.y = buildings[buildings.length - 2].y - gorilla2.height;
}

// 화면 그리기 함수
function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    ctx.fillStyle = "#0c0c14";
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    ctx.fillStyle = "#34495e";
    buildings.forEach(b => {
        ctx.fillRect(b.x, b.y, b.w, b.h);
        ctx.fillStyle = "#f1c40f";
        for (let wx = b.x + 10; wx < b.x + b.w - 10; wx += 20) {
            for (let wy = b.y + 10; wy < canvas.height - 10; wy += 30) {
                ctx.fillRect(wx, wy, 8, 12);
            }
        }
        ctx.fillStyle = "#34495e";
    });

    ctx.fillStyle = "#3498db";
    ctx.fillRect(gorilla1.x, gorilla1.y, gorilla1.width, gorilla1.height);
    ctx.fillStyle = "#2980b9";
    ctx.font = "12px Arial";
    ctx.fillText("🦍P1", gorilla1.x + 2, gorilla1.y - 5);

    ctx.fillStyle = "#e74c3c";
    ctx.fillRect(gorilla2.x, gorilla2.y, gorilla2.width, gorilla2.height);
    ctx.fillStyle = "#c0392b";
    ctx.fillText("🦍P2", gorilla2.x + 2, gorilla2.y - 5);

    if (isFlying) {
        ctx.save();
        ctx.translate(boomerang.x, boomerang.y);
        ctx.rotate(boomerang.angle);
        ctx.fillStyle = "#f1c40f";
        ctx.beginPath();
        ctx.arc(0, 0, 8, 0, Math.PI, true);
        ctx.closePath();
        ctx.fill();
        ctx.restore();
    }
}

// 지수 표기 및 거대 숫자를 안전 정수 처리하는 함수
function parseToExactIntegerString(inputValue) {
    let str = inputValue.trim().toLowerCase();
    if (!str) return null;
    if (str.includes('e')) {
        let [base, expStr] = str.split('e');
        let exp = parseInt(expStr, 10);
        let dotIdx = base.indexOf('.');
        if (dotIdx !== -1) {
            let s1 = base.substring(0, dotIdx);
            let s2 = base.substring(dotIdx + 1);
            return exp >= s2.length ? s1 + s2 + '0'.repeat(exp - s2.length) : s1 + s2.substring(0, exp);
        }
        return base + '0'.repeat(exp);
    }
    let dotIdx = str.indexOf('.');
    return dotIdx !== -1 ? str.substring(0, dotIdx) : str;
}

// 부메랑 발사 및 지정된 최대 높이 기준 역산 프로세스
function fireBoomerang() {
    if (isFlying) return;

    const degInput = parseInt(document.getElementById('angleInput').value, 10);
    const hRawStr = parseToExactIntegerString(document.getElementById('targetHeightInput').value);

    if (!hRawStr || isNaN(degInput) || degInput <= 0 || degInput >= 90) {
        alert("정확한 각도(1~89)와 목표 최대 높이를 입력하세요!");
        return;
    }

    const hBig = BigInt(hRawStr);
    const realDeg = (turn === 1) ? degInput : 180 - degInput;
    const rad = realDeg * (Math.PI / 180);

    // ---------------- [ BigInt 최대 높이 역산 물리 엔진 ] ----------------
    const sinVal = BigInt(Math.round(Math.sin(degInput * Math.PI / 180) * Number(SCALE)));
    const sin2Theta = BigInt(Math.round(Math.sin(2 * realDeg * Math.PI / 180) * Number(SCALE)));

    // 공식 역산: v = sqrt(2 * g * H) / sin(theta)
    // 소수점 오차 유실을 차단하기 위해 배율(SCALE)을 고려하여 연산
    const insideSqrt = 2n * gBig * hBig;
    const sqrtValue = BigInt(Math.round(Math.sqrt(Number(insideSqrt))));
    
    // 최종 필요한 초기 속도(v) 도출
    const vBig = (sqrtValue * SCALE) / sinVal;

    // 총 체공 시간 및 최종 수평 도달 거리 계산
    const totalTimeMs = (2n * vBig * sinVal * 1000n) / (gBig * SCALE);
    const totalDistanceBig = (vBig * vBig * sin2Theta) / (gBig * SCALE);

    // 로그 인쇄
    document.getElementById('physicsLog').innerHTML = `
        🚀 <b>[지정 높이 역산 데이터 보고서]</b><br>
        • 던진 주체: 플레이어 ${turn} 고릴라 (조준 각도: ${degInput}°)<br>
        • 📐 <b>설정된 목표 최대 높이:</b> <span style="color:#e74c3c; font-weight:bold;">${hBig.toLocaleString()} m</span><br>
        • ⚡ <b>역산된 필요 초기 속도:</b> <b>${vBig.toLocaleString()} m/s</b><br>
        • ⏱️ 예상 총 체공 시간: <b>${totalTimeMs.toLocaleString()}</b> 밀리초<br>
        • 🎯 예상 최종 비행 거리: <b>${totalDistanceBig.toString()} m</b>
    `;
    // ---------------------------------------------------------------------

    // 픽셀 스케일 변환 렌더링 세팅
    const simSpeedFactor = 0.1;
    const startX = (turn === 1) ? gorilla1.x + 16 : gorilla2.x + 16;
    const startY = (turn === 1) ? gorilla1.y : gorilla2.y;
    const vSim = Math.min(Number(vBig), 3000) * simSpeedFactor; 
    
    boomerang.x = startX;
    boomerang.y = startY;
    boomerang.vx = vSim * Math.cos(rad);
    boomerang.vy = -vSim * Math.sin(rad);
    boomerang.t = 0;
    boomerang.angle = 0;
    isFlying = true;

    updatePhysics();
}

// 애니메이션 및 충돌 루프
function updatePhysics() {
    if (!isFlying) return;

    boomerang.x += boomerang.vx;
    boomerang.y += boomerang.vy;
    boomerang.vy += 0.4; 
    boomerang.angle += 0.2;

    // 플레이어 충돌 판정
    if (turn === 1 && boomerang.x >= gorilla2.x && boomerang.x <= gorilla2.x + gorilla2.width &&
        boomerang.y >= gorilla2.y && boomerang.y <= gorilla2.y + gorilla2.height) {
        alert("🎉 플레이어 1 명중 승리!");
        resetGame();
        return;
    }
    if (turn === 2 && boomerang.x >= gorilla1.x && boomerang.x <= gorilla1.x + gorilla1.width &&
        boomerang.y >= gorilla1.y && boomerang.y <= gorilla1.y + gorilla1.height) {
        alert("🎉 플레이어 2 명중 승리!");
        resetGame();
        return;
    }

    // 구조물 및 화면 아웃 판정
    let hitBuilding = buildings.find(b => boomerang.x >= b.x && boomerang.x <= b.x + b.w && boomerang.y >= b.y);
    if (hitBuilding || boomerang.y > canvas.height || boomerang.x < 0 || boomerang.x > canvas.width) {
        isFlying = false;
        turn = (turn === 1) ? 2 : 1;
        document.getElementById('turnText').innerText = `📢 플레이어 ${turn} 턴`;
        document.getElementById('turnText').style.color = (turn === 1) ? "#3498db" : "#e74c3c";
        draw();
        return;
    }

    draw();
    requestAnimationFrame(updatePhysics);
}

function resetGame() {
    isFlying = false;
    turn = 1;
    document.getElementById('turnText').innerText = `📢 플레이어 1 턴`;
    document.getElementById('turnText').style.color = "#3498db";
    generateTerrain();
    draw();
}

// 초기 로딩 가동
generateTerrain();
draw();
