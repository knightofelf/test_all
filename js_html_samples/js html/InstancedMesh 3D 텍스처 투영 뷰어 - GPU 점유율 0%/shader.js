/**
 * =========================================================================
 * [PAGE 2 : 5개 고정 모델 다중 투영 및 공간 보간 그래픽스 알고리즘]
 * 5개 모델의 기하학적 형태 구현, 3겹 원 기둥 방향 방사형 투영 매핑, 
 * 레이어 사이의 거리별 선형 데이터 보간(Mix) 공식을 처리하는 파일입니다.
 * =========================================================================
 */

const fsSource = `#version 300 es
precision highp float;
in vec2 vUv;
uniform vec2 uResolution;
uniform float uTime;
uniform vec2 uMouse;
out vec4 fragColor;

// 시점 드래그용 2D 회전 제어 변환 행렬
mat2 rotate(float a) {
    return mat2(cos(a), -sin(a), sin(a), cos(a));
}

// 2D 공간 경계 판정용 부호거리함수 (SDF)
float boxSDF(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// [핵심 1] 중심 원점에 완전히 고정된 고유 텍스처를 지닌 5개의 독립 모델 생성 함수
vec3 get5FixedModels(vec2 coord) {
    // 1번 모델: 정중앙 - 체커보드 구체 모델
    float d1 = length(coord);
    if (d1 < 0.12) {
        float ch = step(0.5, fract(atan(coord.y, coord.x) * 2.0 / 3.141592)) == step(0.5, fract(d1 * 22.0)) ? 1.0 : 0.0;
        return mix(vec3(1.0, 0.25, 0.25), vec3(0.15, 0.05, 0.05), ch);
    }

    // 2번 모델: 12시 상단 - 스트라이프 사각형 모델
    vec2 p2 = coord - vec2(0.0, 0.28);
    float d2 = boxSDF(p2, vec2(0.07));
    if (d2 < 0.0) {
        float st = step(0.5, fract(p2.y * 35.0));
        return mix(vec3(0.1, 0.9, 0.4), vec3(0.02, 0.2, 0.08), st);
    }

    // 3번 모델: 6시 하단 - 방사 파형 고리 도넛 모델
    vec2 p3 = coord - vec2(0.0, -0.28);
    float d3 = abs(length(p3) - 0.06) - 0.02;
    if (d3 < 0.0) {
        float rad = step(0.5, fract(atan(p3.y, p3.x) * 4.0 / 3.141592));
        return mix(vec3(0.95, 0.85, 0.1), vec3(0.25, 0.2, 0.0), rad);
    }

    // 4번 모델: 9시 좌측 - 디지털 매트릭스 도트 마름모 모델
    vec2 p4 = coord - vec2(-0.28, 0.0);
    p4 *= rotate(0.785398); 
    float d4 = boxSDF(p4, vec2(0.06));
    if (d4 < 0.0) {
        float dotPattern = step(0.65, sin(p4.x * 55.0) * sin(p4.y * 55.0));
        return mix(vec3(0.1, 0.55, 1.0), vec3(0.9, 0.95, 1.0), dotPattern);
    }

    // 5번 모델: 3시 우측 - 그물망 삼각형 크로스 모델
    vec2 p5 = coord - vec2(0.28, 0.0);
    float d5 = max(boxSDF(p5, vec2(0.07)), -p5.y - p5.x - 0.04);
    if (d5 < 0.0) {
        float gridLines = step(0.82, max(fract(p5.x * 28.0), fract(p5.y * 28.0)));
        return mix(vec3(0.85, 0.1, 0.95), vec3(0.15, 0.0, 0.2), gridLines);
    }

    return vec3(0.0); // 빈 공간 데이터
}

void main() {
    // 마우스 및 시간 변화에 따른 가상 3D 회전 제어 및 원점 정규화
    vec2 uv = (gl_FragCoord.xy - uResolution * 0.5) / uResolution.y * 2.8;
    vec2 mouseRot = (uMouse - uResolution * 0.5) / uResolution.y * 3.141592;
    uv *= rotate(mouseRot.x * 0.75 + uTime * 0.03); 

    float dist = length(uv);
    float angle = atan(uv.y, uv.x);

    // 5개 고정 모델 영역 마스크 임계값 설정
    float modelMaxRadius = 0.42;

    // [투영 연산] 3겹 원통 벽면 바깥 방향으로 360도 방사선 직선 정밀 투영 매핑
    vec2 projectedCoordinates = vec2(cos(angle), sin(angle)) * modelMaxRadius;
    vec3 projectedPixelData = get5FixedModels(projectedCoordinates);

    // 기본 배경색 암막 세팅
    vec3 finalColor = vec3(0.01, 0.01, 0.02);

    // 요구된 바깥쪽 3겹 원 레이어 반지름 수치 고정 정의
    float r1 = 0.52;
    float r2 = 0.92;
    float r3 = 1.32;

    // [핵심] 거리 판독 루프 제어 및 각 원 레이어의 사이 공간 픽셀 실시간 선형 보간(Linear Interpolation)
    if (dist < r1) {
        // 1번 원 내부 공간: 5개 고정 모델 원본 픽셀 그대로 배치 출력
        finalColor = get5FixedModels(uv);
    } 
    else if (dist >= r1 && dist < r2) {
        // [1겹 원 ~ 2겹 원 사이 공간]: 거리 비례 픽셀 데이터 보간 처리 구간
        float factor = (dist - r1) / (r2 - r1); // 0.0 ~ 1.0 보간 계수
        
        vec3 innerPixel = projectedPixelData * 0.95;
        vec3 outerPixel = projectedPixelData * 0.45;
        finalColor = mix(innerPixel, outerPixel, factor); // 두 레이어 단면 사이 공간 픽셀 융합 생성
    } 
    else if (dist >= r2 && dist < r3) {
        // [2겹 원 ~ 3겹 원 사이 공간]: 거리 비례 픽셀 데이터 보간 처리 구간
        float factor = (dist - r2) / (r3 - r2);
        
        vec3 innerPixel = projectedPixelData * 0.45;
        vec3 outerPixel = projectedPixelData * 0.12;
        finalColor = mix(innerPixel, outerPixel, factor); // 두 레이어 단면 사이 공간 픽셀 융합 생성
    }
    else if (dist >= r3 && dist < r3 + 0.35) {
        // [3겹 원 바깥 영역]: 잔상 감쇠 페이드 보간
        float factor = (dist - r3) / 0.35;
        finalColor = mix(projectedPixelData * 0.12, vec3(0.0), factor);
    }

    // 구조적 레이어 경계 구분을 위한 3겹 원 기둥 실선(Ring) 가시화 프로세스
    float ringThickness = 0.008;
    if (abs(dist - r1) < ringThickness || abs(dist - r2) < ringThickness || abs(dist - r3) < ringThickness) {
        // 투영 모델 컬러의 에너지와 화이트 빔 광선을 결합하여 원형 테두리 라인 강조
        finalColor = mix(vec3(1.0), projectedPixelData * 2.0, 0.4);
    }

    fragColor = vec4(finalColor, 1.0);
}
`;
