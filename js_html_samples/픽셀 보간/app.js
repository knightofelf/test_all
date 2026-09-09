const srcCanvas = document.getElementById('srcCanvas');
const srcCtx = srcCanvas.getContext('2d');
const destCanvas = document.getElementById('destCanvas');
const destCtx = destCanvas.getContext('2d');

const SRC_SIZE = 16;
const DEST_SIZE = 512;

// 1. 테스트용 원본 저해상도 픽셀 그래픽 그리기 (f 모양의 픽셀 아트)
function drawSourcePixelArt() {
    srcCtx.fillStyle = '#000000';
    srcCtx.fillRect(0, 0, SRC_SIZE, SRC_SIZE);
    
    srcCtx.fillStyle = '#ff3366'; // 하이라이트 벡터화할 전경색
    srcCtx.fillRect(5, 3, 6, 2);
    srcCtx.fillRect(5, 5, 2, 8);
    srcCtx.fillRect(5, 7, 5, 2);
}

// 2. 특정 좌표의 픽셀 색상 벡터(RGBA)를 안전하게 가져오는 함수
function getPixel(x, y, data, width) {
    x = Math.max(0, Math.min(width - 1, x));
    y = Math.max(0, Math.min(width - 1, y));
    const idx = (y * width + x) * 4;
    return [data[idx], data[idx+1], data[idx+2], data[idx+3]];
}

// 3. 셰이더의 fwidth 및 mix 연산을 수학적으로 픽셀 벡터 보간에 적용
function renderVectorizedInterpolation() {
    const srcImgData = srcCtx.getImageData(0, 0, SRC_SIZE, SRC_SIZE).data;
    const destImgData = destCtx.createImageData(DEST_SIZE, DEST_SIZE);
    const destData = destImgData.data;

    // 출력 버퍼의 모든 픽셀 벡터 좌표 순회 (x, y)
    for (let destY = 0; destY < DEST_SIZE; destY++) {
        for (let destX = 0; destX < DEST_SIZE; destX++) {
            
            // 3-1. 출력 좌표를 원본 픽셀 스케일 벡터(실수 좌표)로 매핑 (UV 벡터)
            const uvX = (destX / DEST_SIZE) * SRC_SIZE;
            const uvY = (destY / DEST_SIZE) * SRC_SIZE;
            
            // 3-2. 현재 위치 벡터의 정수부(floor)와 소수부(fract) 분리
            const iX = Math.floor(uvX);
            const iY = Math.floor(uvY);
            const fX = uvX - iX;
            const fY = uvY - iY;

            // 3-3. 가상의 미분 벡터값 설정 (화면 픽셀 대비 원본 픽셀의 변화율)
            // OpenGL의 fwidth(uv) 역할을 수동 계산
            const deltaX = SRC_SIZE / DEST_SIZE;
            const deltaY = SRC_SIZE / DEST_SIZE;

            // 3-4. 경계면 필터 가중치 함수 계산 (벡터 안티앨리어싱 핵심 연산)
            // 픽셀 내부의 소수점 위치를 경계면 변화율로 나누어 날카로운 계단면을 보간 선으로 변환
            const blendX = Math.max(0, Math.min(1, (fX - 0.5) / deltaX + 0.5));
            const blendY = Math.max(0, Math.min(1, (fY - 0.5) / deltaY + 0.5));

            // 3-5. 주변 픽셀들 샘플링
            const c00 = getPixel(iX, iY, srcImgData, SRC_SIZE);
            const c10 = getPixel(iX + 1, iY, srcImgData, SRC_SIZE);
            const c01 = getPixel(iX, iY + 1, srcImgData, SRC_SIZE);
            const c11 = getPixel(iX + 1, iY + 1, srcImgData, SRC_SIZE);

            // 3-6. 계산된 경계 가중치 벡터(blendX, blendY)를 이용한 선형 보간 (mix)
            const destIdx = (destY * DEST_SIZE + destX) * 4;
            for (let channel = 0; channel < 4; channel++) {
                const topMix = c00[channel] * (1 - blendX) + c10[channel] * blendX;
                const bottomMix = c01[channel] * (1 - blendX) + c11[channel] * blendX;
                
                // 최종 보간 결과 저장
                destData[destIdx + channel] = topMix * (1 - blendY) + bottomMix * blendY;
            }
        }
    }

    destCtx.putImageData(destImgData, 0, 0);
}

// 초기화 및 실행
drawSourcePixelArt();
renderVectorizedInterpolation();
