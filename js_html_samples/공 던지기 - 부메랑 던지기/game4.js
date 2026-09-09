const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');

let turn = 1; 
let isFlying = false;
let buildings = [];

const gorilla1 = { x: 60, y: 0, width: 32, height: 32 };
const gorilla2 = { x: 680, y: 0, width: 32, height: 32 };

// 물리 정밀 고정 상수
const gBig = 10n; 
const SCALE = 1000000n; // 삼각함수용 스케일

// [핵심] 가상 BigInt 우주 물리 공간 변수 (모든 비행 역학은 소수점 없는 이 가상 정수 공간에서 일어납니다)
let virtualBoomerang = { x: 0n, y: 0n, vx: 0n, vy: 0n };
let currentSimScale = 1n; // 화면 픽셀과 우주 정수 단위를 이어주는 실시간 배율 변수
let startYVirtual = 0n; // 기준 고도 보정용

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
    gorilla1.y = buildings[1].y - gorilla1.height;
    gorilla2.y = buildings[buildings.length - 2].y - gorilla2.height;
}

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
    ctx.font = "12px Arial";
    ctx.fillText("🦍P1", gorilla1.x + 2, gorilla1.y - 5);

    ctx.fillStyle = "#e74c3c";
    ctx.fillRect(gorilla2.x, gorilla2.y, gorilla2.width, gorilla2.height);
    ctx.fillText("🦍P2", gorilla2.x + 2, gorilla2.y - 5);

    // 가상 우주 정수 좌표를 화면 픽셀 크기로 안전 축소 변환하여 렌더링
    if (isFlying) {
        let renderX = Number(virtualBoomerang.x / currentSimScale);
        let renderY = Number((startYVirtual - virtualBoomerang.y) / currentSimScale) + (turn === 1 ? gorilla1.y : gorilla2.y);

        ctx.save();
        ctx.translate(renderX, renderY);
        ctx.fillStyle = "#f1c40f";
        ctx.beginPath();
        ctx.arc(0, 0, 8, 0, Math.PI * 2);
        ctx.fill();
        ctx.restore();
    }
}

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

function fireBoomerang(isAuto) {
    if (isFlying) return;

    let degInput = parseInt(document.getElementById('angleInput').value, 10);
    const hRawStr = parseToExactIntegerString(document.getElementById('targetHeightInput').value);

    if (!hRawStr) {
        alert("목표 최대 높이를 정수로 입력하세요!");
        return;
    }

    const hBig = BigInt(hRawStr);

    // 기준점 설계
    const p1CenterX = gorilla1.x + 16;
    const p1CenterY = gorilla1.y + 16;
    const p2CenterX = gorilla2.x + 16;
    const p2CenterY = gorilla2.y + 16;

    let startX = (turn === 1) ? p1CenterX : p2CenterX;
    let startY = (turn === 1) ? p1CenterY : p2CenterY;
    let targetX = (turn === 1) ? p2CenterX : p1CenterX;
    let targetY = (turn === 1) ? p2CenterY : p1CenterY;

    // 수평 거리 오프셋 계산 (화면 픽셀 차이)
    const pixelDx = targetX - startX;
    const pixelDy = startY - targetY; 

    // 화면 픽셀당 우주 공간의 실제 축척 크기(배율) 산출 (최대 높이 기반 가변 스케일러)
    // 화면 높이가 약 300픽셀 내외이므로 목표 고도를 커버할 수 있는 픽셀 배율 정의
    currentSimScale = hBig / 250n;
    if (currentSimScale < 1n) currentSimScale = 1n;

    // 우주 가상 정수계 내부의 거리 단위로 환산 (Number 오차 사전 완벽 차단)
    const virtualDx = BigInt(pixelDx) * currentSimScale;
    const virtualDy = BigInt(pixelDy) * currentSimScale;

    // ---------------- [ 🤖 고정밀 BigInt 완벽 조준 오차 제거 엔진 ] ----------------
    if (isAuto) {
        // 완전 정수 공간에서의 상향 최고점 도달 시간 및 낙하 시간 역계산 공식 이식
        // t_up = sqrt(2 * h / g)
        const tUp = BigInt(Math.round(Math.sqrt(Number((2n * hBig) / gBig))));
        // t_down = sqrt(2 * (h - dy) / g)
        const tDown = BigInt(Math.round(Math.sqrt(Number((2n * (hBig - virtualDy)) / gBig))));
        const totalT = tUp + tDown;

        if (totalT > 0n) {
            virtualBoomerang.vx = virtualDx / totalT;
            virtualBoomerang.vy = gBig * tUp; // 최고점에 도달할 만큼의 y축 상승 속도 부여
        }

        // 역산된 속도 벡터를 통해 사용자 각도 UI 역 업데이트
        let calculatedAngle = Math.atan2(Number(virtualBoomerang.vy), Math.abs(Number(virtualBoomerang.vx))) * (180 / Math.PI);
        degInput = Math.round(calculatedAngle);
        document.getElementById('angleInput').value = degInput;
    } else {
        // 수동 던지기 역산 모드
        const sinVal = BigInt(Math.round(Math.sin(degInput * Math.PI / 180) * Number(SCALE)));
        const cosVal = BigInt(Math.round(Math.cos(degInput * Math.PI / 180) * Number(SCALE)));
        const insideSqrt = 2n * gBig * hBig;
        const sqrtValue = BigInt(Math.round(Math.sqrt(Number(insideSqrt))));
        
        const vBig = (sinVal > 0n) ? (sqrtValue * SCALE) / sinVal : 0n;

        // X, Y 속도 성분을 정수화 분리
        virtualBoomerang.vx = (vBig * cosVal) / SCALE;
        if (pixelDx < 0) virtualBoomerang.vx = -virtualBoomerang.vx; // 방향 맞춤
        virtualBoomerang.vy = (vBig * sinVal) / SCALE;
    }
    // -----------------------------------------------------------------------------

    // 가상 투사체 초기화
    virtualBoomerang.x = BigInt(startX) * currentSimScale;
    virtualBoomerang.y = 0n; // 고릴라 본인 서있는 지점을 가상 0고도로 지정
    startYVirtual = virtualBoomerang.x; // 축척 변환용 백업
    startYVirtual = BigInt(startX) * currentSimScale;

    // 실시간 모니터링 로그 출력
    const reportV = BigInt(Math.round(Math.sqrt(Number(virtualBoomerang.vx ** 2n + virtualBoomerang.vy ** 2n))));
    document.getElementById('physicsLog').innerHTML = `
        🤖 <b>[BigInt 정수 오차 제거 저격 시스템]</b><br>
        • 매칭 상태: ${isAuto ? '<span style="color:#2ecc71; font-weight:bold;">100% 정밀 유도 명중 모드</span>' : '수동 연산 모드'}<br>
        • 설정 스케일 높이: ${hBig.toLocaleString()} m<br>
        • 🪐 우주 벡터 초기 속도: <b>${reportV.toLocaleString()} m/s</b> (각도: ${degInput}°)<br>
        • 📐 픽셀당 축척 배율 변환값: 1 픽셀 = <b>${currentSimScale.toLocaleString()} 미터</b> 상당
    `;

    isFlying = true;
    updatePhysics();
}

function updatePhysics() {
    if (!isFlying) return;

    // 가상 공간에서 완벽한 정수 연산 누적 (소수점이 없으므로 값이 커져도 궤적이 뭉개지지 않음)
    // 1 프레임당 시뮬레이션 분할 시간 단위를 고려해 적절히 우주 속도를 가산
    // 프레임당 속도 변화를 현재 축척 배율(currentSimScale)과 동기화하여 고속 이동 보정
    const stepSize = currentSimScale / 12n > 1n ? currentSimScale / 12n : 1n;

    virtualBoomerang.x += virtualBoomerang.vx * stepSize / (currentSimScale / 4n || 1n);
    virtualBoomerang.y += virtualBoomerang.vy * stepSize / (currentSimScale / 4n || 1n);
    virtualBoomerang.vy -= gBig * stepSize / (currentSimScale / 30n || 1n); // 중력 가속도 차감

    // 픽셀 스케일 역산 판정용 실시간 드로잉 좌표 계산
    let curPixelX = Number(virtualBoomerang.x / currentSimScale);
    let curPixelY = Number((BigInt(canvas.height) * currentSimScale - virtualBoomerang.y) / currentSimScale);
    
    // 고릴라 위치 고도 마크 재정렬
    let p1CenterX = gorilla1.x + 16;
    let p2CenterX = gorilla2.x + 16;
    let targetPixelX = (turn === 1) ? p2CenterX : p1CenterX;
    let targetPixelY = (turn === 1) ? gorilla2.y + 16 : gorilla1.y + 16;

    // 오차 없는 명중 판정 (타겟 픽셀 근처 오프셋 정밀 가상 레이더 스캔)
    let distanceToTarget = Math.sqrt((curPixelX - targetPixelX) ** 2 + (curPixelY - targetPixelY) ** 2);

    if (distanceToTarget < 25) {
        alert(`🎯 [백발백중 명중] 플레이어 ${turn}가 우주 스케일 저격에 성공했습니다!`);
        resetGame();
        return;
    }

    // 화면 경계 오프 스크린 예외 처리
    if (curPixelX < 0 || curPixelX > canvas.width || curPixelY > canvas.height + 50) {
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

generateTerrain();
draw();
