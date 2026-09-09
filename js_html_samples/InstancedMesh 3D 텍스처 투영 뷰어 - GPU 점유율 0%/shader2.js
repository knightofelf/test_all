/**
 * =========================================================================
 * [PAGE 2 : 기하학적 방사형 투영 및 다중 레이어 공간 픽셀 보간 알고리즘 코어]
 * 중심점으로부터 광선이 뻗어 나가듯 픽셀을 정밀하게 구형 직선 투영하고,
 * 각 원 레이어 경계 사이의 거리를 판별해 실시간 보간(Mix) 처리를 연산합니다.
 * =========================================================================
 */

const customVertexShader = `
  varying vec3 vNormal;
  varying vec3 vWorldPosition;
  varying vec2 vUv;

  void main() {
    vUv = uv;
    vNormal = normalize(normalMatrix * normal);
    
    // 월드 공간 상의 기하학적 정점 위치 산출 (투영 계산용)
    vec4 worldPosition = modelMatrix * vec4(position, 1.0);
    vWorldPosition = worldPosition.xyz;
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  }
`;

const customFragmentShader = `
  uniform sampler2D tex;
  uniform float uInnerRadius;
  uniform float uOuterRadius;
  uniform float uCurrentRadius;
  uniform mat4 uCameraMatrix;

  varying vec3 vNormal;
  varying vec3 vWorldPosition;
  varying vec2 vUv;

  void main() {
    // 1. 방사형 직선 투영(Radial Projection) 수식 알고리즘 구현
    // 중심(0,0,0)에서 현재 레이어 표면 픽셀로 향하는 3차원 방향 벡터 추출
    vec3 radialDir = normalize(vWorldPosition);

    // 3차원 구면 좌표계를 2D 투영 텍스처 좌표(UV)로 정밀 변환
    float phi = atan(radialDir.z, radialDir.x);
    float theta = acos(radialDir.y);


// 3.141592 뒤에 수치(배율)를 나누거나 곱해줌으로써 압축도를 조절합니다.
// 예시: 아래처럼 작성하면 가로세로 투영 크기가 2배 더 작아집니다.

//    vec2 projectedUv = vec2((phi / 3.141592) * 0.5 + 0.5, theta / 3.141592);
vec2 projectedUv = vec2((phi / (3.141592 * 2.0)) * 0.5 + 0.5, theta / (3.141592 * 2.0));



    // 투영 버퍼로부터 모델의 픽셀 데이터 추출
    vec4 projectedColor = texture2D(tex, projectedUv);

    // 빈 투영 영역(배경) 처리
    if (projectedColor.a < 0.1) {
       projectedColor = vec4(0.02, 0.02, 0.05, 0.1);
    }

    // 2. 요구사항: [각 원 사이 공간을 볼 때 사이 픽셀을 보간해서 생성]
    // 현재 픽셀이 위치한 원통/구체의 반지름(uCurrentRadius)과 이웃 레이어 간의 상대적 거리를 측정
    float spaceDistance = uOuterRadius - uInnerRadius;
    float currentOffset = uCurrentRadius - uInnerRadius;
    
    // 거리 비율에 따른 선형 보간 계수 도출 (0.0 ~ 1.0)
    float interpolationFactor = clamp(currentOffset / spaceDistance, 0.0, 1.0);

    // [핵심 보간 연산]: 안쪽 영역의 불투명한 픽셀 정보와 
    // 바깥쪽 영역으로 진행하며 조밀하게 압축 분해되는 보간 데이터를 실시간 융합(mix) 생성
    vec4 innerInterpolated = vec4(projectedColor.rgb * 1.0, 0.85);
    vec4 outerInterpolated = vec4(projectedColor.rgb * 0.25, 0.20);
    
    vec4 finalPixelColor = mix(innerInterpolated, outerInterpolated, interpolationFactor);

    // 3. 시각화 장치: 3겹 원의 물리적 구조를 식별할 수 있도록 테두리 링 격자 효과 부여
    if (vUv.y < 0.02 || vUv.y > 0.98 || fract(vUv.x * 20.0) < 0.03) {
      finalPixelColor = mix(finalPixelColor, vec4(0.0, 1.0, 0.65, 0.9), 0.5);
    }

    gl_FragColor = finalPixelColor;
  }
`;
