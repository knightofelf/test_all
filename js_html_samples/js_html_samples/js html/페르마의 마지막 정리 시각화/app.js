// DOM 엘리먼트 객체 참조
const nSlider = document.getElementById('nSlider');
const nValue = document.getElementById('nValue');
const inputX = document.getElementById('inputX');
const inputY = document.getElementById('inputY');
const formulaText = document.getElementById('formulaText');
const statusBox = document.getElementById('statusBox');
const canvas = document.getElementById('renderCanvas');
const ctx = canvas.getContext('2d');

// 전역 이벤트 리스너 통합 등록
[nSlider, inputX, inputY].forEach(element => {
    element.addEventListener('input', updateApp);
});

// 앱 메인 업데이트 루틴
function updateApp() {
    const n = parseInt(nSlider.value);
    let x = parseInt(inputX.value) || 1;
    let y = parseInt(inputY.value) || 1;

    nValue.textContent = n;
    
    // 1. 디오판토스 방정식 해 계산 및 연산
    const result = calculateFermat(n, x, y);
    
    // 2. UI 및 텍스트 갱신
    renderUI(n, x, y, result);
    
    // 3. 캔버스 그래픽 렌더링
    drawGeometry(n, x, y, result.z_real);
}

// --- 핵심 알고리즘: 방정식 계산 함수 ---
function calculateFermat(n, x, y) {
    const x_pow = Math.pow(x, n);
    const y_pow = Math.pow(y, n);
    const leftSide = x_pow + y_pow;
    
    const z_real = Math.pow(leftSide, 1 / n); // 실수 범위 해
    const z_integer = Math.round(z_real);       // 가장 가까운 정수 변환
    const isIntegerSolution = Math.pow(z_integer, n) === leftSide;

    return { leftSide, z_real, z_integer, isIntegerSolution };
}

// UI 텍스트 출력 함수
function renderUI(n, x, y, res) {
    const sup = n === 1 ? '' : (['²', '³', '⁴', '⁵'][n-2] || '^' + n);
    formulaText.innerHTML = `${x}${sup} + ${y}${sup} = z${sup}`;

    if (res.isIntegerSolution) {
        statusBox.innerHTML = `
            <span class="badge possible">정수해 존재 (방정식 성립)</span><br>
            좌변 합(${res.leftSide})이 정확히 정수 <b>z = ${res.z_integer}</b>의 ${n}제곱과 일치합니다.
        `;
    } else {
        statusBox.innerHTML = `
            <span class="badge impossible">정수해 없음 (페르마의 정리 준수)</span><br>
            실수 범위 해: <b>z = ${res.z_real.toFixed(4)}...</b><br>
            <span style="font-size:13px; color:#64748b;">(정수 ${res.z_integer}${sup} = ${Math.pow(res.z_integer, n)} 이므로 좌변인 ${res.leftSide}와 일치하지 않는 방정식입니다.)</span>
        `;
    }
}

// 등각 투영 3D 변환 헬퍼
function project(x, y, z, scale) {
    return {
        x: (x - y) * Math.cos(Math.PI / 6) * scale,
        y: (x + y) * Math.sin(Math.PI / 6) * scale - z * scale
    };
}

// --- 그래픽스: 차원별 드로잉 마스터 함수 ---
function drawGeometry(n, x, y, z_real) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.lineWidth = 2;
    const cx = canvas.width / 2;
    const cy = canvas.height / 2;

    if (n === 1) {
        const unit = 300 / (x + y);
        const lenX = x * unit;
        const lenY = y * unit;

        ctx.strokeStyle = '#2563eb';
        ctx.beginPath(); ctx.moveTo(100, cy - 20); ctx.lineTo(100 + lenX, cy - 20); ctx.stroke();
        ctx.fillStyle = '#2563eb'; ctx.fillText(`x = ${x}`, 100 + lenX/2 - 10, cy - 35);

        ctx.strokeStyle = '#dc2626';
        ctx.beginPath(); ctx.moveTo(100 + lenX, cy - 20); ctx.lineTo(100 + lenX + lenY, cy - 20); ctx.stroke();
        ctx.fillStyle = '#dc2626'; ctx.fillText(`y = ${y}`, 100 + lenX + lenY/2 - 10, cy - 35);

        ctx.strokeStyle = '#16a34a';
        ctx.beginPath(); ctx.moveTo(100, cy + 30); ctx.lineTo(100 + lenX + lenY, cy + 30); ctx.stroke();
        ctx.fillStyle = '#16a34a'; ctx.fillText(`z = x + y = ${z_real.toFixed(1)}`, 100 + (lenX+lenY)/2 - 40, cy + 55);

    } else if (n === 2) {
        const baseScale = Math.min(18, 120 / Math.max(x, y));
        const ox = cx - 30, oy = cy + 50;

        ctx.fillStyle = 'rgba(37, 99, 235, 0.35)'; ctx.strokeStyle = '#2563eb';
        ctx.fillRect(ox, oy, x * baseScale, x * baseScale);
        ctx.strokeRect(ox, oy, x * baseScale, x * baseScale);

        ctx.fillStyle = 'rgba(220, 38, 38, 0.35)'; ctx.strokeStyle = '#dc2626';
        ctx.fillRect(ox - y * baseScale, oy - y * baseScale, y * baseScale, y * baseScale);
        ctx.strokeRect(ox - y * baseScale, oy - y * baseScale, y * baseScale, y * baseScale);

        ctx.fillStyle = 'rgba(22, 163, 74, 0.25)'; ctx.strokeStyle = '#16a34a';
        ctx.beginPath();
        ctx.moveTo(ox + x * baseScale, oy);
        ctx.lineTo(ox + x * baseScale + y * baseScale, oy - x * baseScale);
        ctx.lineTo(ox + y * baseScale, oy - x * baseScale - y * baseScale);
        ctx.lineTo(ox, oy - y * baseScale);
        ctx.closePath(); ctx.fill(); ctx.stroke();

        ctx.strokeStyle = '#0f172a'; ctx.beginPath();
        ctx.moveTo(ox, oy); ctx.lineTo(ox + x * baseScale, oy); ctx.lineTo(ox, oy - y * baseScale);
        ctx.closePath(); ctx.stroke();

    } else if (n === 3) {
        const maxVal = Math.max(x, y);
        const cubeScale = 60 / maxVal; 

        drawCubeGrid(cx - 130, cy + 30, x, cubeScale, 'rgba(37, 99, 235, 0.55)', '#1d4ed8');
        drawCubeGrid(cx + 40, cy + 50, y, cubeScale, 'rgba(220, 38, 38, 0.55)', '#b91c1c');

        ctx.fillStyle = '#475569'; ctx.font = '13px sans-serif'; ctx.textAlign = 'center';
        ctx.fillText(`두 고체 부피의 총합 (x³ + y³) = ${(Math.pow(x, 3) + Math.pow(y, 3))}`, cx, cy + 130);

    } else {
        ctx.save(); ctx.translate(cx, cy - 20);
        for (let i = 0; i < n * 4; i++) {
            ctx.rotate((Math.PI * 2) / (n * 4));
            ctx.strokeStyle = `rgba(147, 51, 234, ${0.8 - (i*0.04)})`;
            const size = 130 - (i * 7);
            ctx.strokeRect(-size/2, -size/2, size, size);
        }
        ctx.restore();
        ctx.textAlign = 'center'; ctx.fillStyle = '#7c3aed';
        ctx.fillText(`고차원 초부피 공간 왜곡 격자 패턴 (n=${n})`, cx, cy + 120);
    }
}

// 입체 큐브 렌더링 서브 함수 (인덱스 수정 반영)
function drawCubeGrid(bx, by, val, scale, fillColor, strokeColor) {
    const size = scale * val;
    const v = [
        project(0, 0, 0, size), // 0
        project(1, 0, 0, size), // 1
        project(1, 1, 0, size), // 2
        project(0, 1, 0, size), // 3
        project(0, 0, 1, size), // 4
        project(1, 0, 1, size), // 5
        project(1, 1, 1, size), // 6
        project(0, 1, 1, size)  // 7
    ];
    
    v.forEach(pt => { pt.x += bx; pt.y += by; });
    ctx.strokeStyle = strokeColor;
    ctx.fillStyle = fillColor;
    
    const drawFace = (p1, p2, p3, p4) => {
        ctx.beginPath(); 
        ctx.moveTo(p1.x, p1.y); ctx.lineTo(p2.x, p2.y);
        ctx.lineTo(p3.x, p3.y); ctx.lineTo(p4.x, p4.y); 
        ctx.closePath(); ctx.fill(); ctx.stroke();
    };

    // 입체면 렌더링 순서 매핑
    drawFace(v[0], v[3], v[7], v[4]); // 왼쪽 면
    drawFace(v[0], v[1], v[5], v[4]); // 오른쪽 면
    drawFace(v[4], v[5], v[6], v[7]); // 윗면 캡
}

// 앱 최초 기동 실행
updateApp();
