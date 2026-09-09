/**
 * =========================================================================
 * [PAGE 2 : 웹 텍스처 매핑 3D 모델 및 시점 비례 원근 투영/보간 셰이더 코어]
 * 문법 오염 에러를 방지하도록 격리 구조화된 순수 모듈 컨테이너입니다.
 * =========================================================================
 */

const TEXTURE_VIEWER_SHADERS = {
    // 2-1. 정점 셰이더
    vertex: `#version 300 es
        in vec2 position;
        out vec2 vUv;
        void main() {
            vUv = position * 0.5 + 0.5;
            gl_Position = vec4(position, 0.0, 1.0);
        }
    `,

    // 2-2. 프래그먼트 셰이더 (웹 텍스처 좌표계 스캔 및 다중 공간 보간 제어)
    fragment: `#version 300 es
        precision highp float;
        in vec2 vUv;
        uniform vec2 uResolution;
        uniform float uTime;
        uniform vec2 uCameraRot;
        uniform sampler2D uTexture; // PAGE 1에서 수신한 실시간 웹 이미지 텍스처 버퍼
        out vec4 fragColor;

        vec3 rotateX(vec3 p, float a) {
            float c = cos(a), s = sin(a);
            return vec3(p.x, c * p.y - s * p.z, s * p.y + c * p.z);
        }
        vec3 rotateY(vec3 p, float a) {
            float c = cos(a), s = sin(a);
            return vec3(c * p.x + s * p.z, p.y, -s * p.x + c * p.z);
        }

        float sdBox(vec3 p, vec3 b) {
            vec3 q = abs(p) - b;
            return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
        }

        // [알고리즘 1] 입체 모델 표면에 실시간 웹 텍스처 무늬 좌표를 결합 매핑하는 함수
        vec3 getWebTexturedModels(vec3 p) {
            float d1 = length(p);
            
            // 1번 모델: 정중앙 (0,0,0) 구체 모델 - 구면 좌표 투영 방식으로 웹 텍스처를 스킨처럼 입힙니다
            if (d1 < 0.16) {
                vec3 n = normalize(p);
                vec2 texCoord = vec2(atan(n.z, n.x) / 6.283185 + 0.5, n.y * 0.5 + 0.5);
                return texture(uTexture, texCoord).rgb;
            }

            // 2번 모델: 상단 - 웹 텍스처가 포장지처럼 입혀진 정육면체 상자 모델
            vec3 p2 = p - vec3(0.0, 0.32, 0.0);
            if (sdBox(p2, vec3(0.08)) < 0.0) {
                vec2 texCoord = fract(p2.xz * 4.0 + 0.5); // 평면 프로젝션 맵
                return texture(uTexture, texCoord).rgb;
            }

            // 3번 모델: 하단 - 파동형 고리 모델
            vec3 p3 = p - vec3(0.0, -0.32, 0.0);
            float d3 = length(vec2(length(p3.xz) - 0.07, p3.y)) - 0.025;
            if (d3 < 0.0) {
                vec2 texCoord = vec2(atan(p3.z, p3.x) / 6.283185 + 0.5, p3.y * 5.0 + 0.5);
                return texture(uTexture, fract(texCoord)).rgb;
            }

            // 4번 모델: 좌측 - 원통 모델
            vec3 p4 = p - vec3(-0.32, 0.0, 0.0);
            float d4 = max(length(p4.xz) - 0.06, abs(p4.y) - 0.08);
            if (d4 < 0.0) {
                vec2 texCoord = vec2(atan(p4.z, p4.x) / 6.283185 + 0.5, p4.y * 4.0 + 0.5);
                return texture(uTexture, fract(texCoord)).rgb;
            }

            // 5번 모델: 우측 - 경사 캡슐 모델
            vec3 p5 = p - vec3(0.32, 0.0, 0.0);
            float d5 = length(p5 - vec3(0.0, clamp(p5.y, -0.05, 0.05), 0.0)) - 0.06;
            if (d5 < 0.0) {
                vec2 texCoord = vec2(p5.x * 4.0 + 0.5, p5.z * 4.0 + 0.5);
                return texture(uTexture, fract(texCoord)).rgb;
            }

            return vec3(0.0);
        }

        void main() {
            vec2 screenUv = (gl_FragCoord.xy - uResolution * 0.5) / uResolution.y;

            // 가상 3D 카메라 광선 축 수립
            vec3 rayOrigin = vec3(0.0, 0.0, -3.4); 
            vec3 rayDir = normalize(vec3(screenUv, 1.3)); 

            // 360도 마우스 제어 인터랙션 3D 궤도 변환 적용
            rayOrigin = rotateY(rotateX(rayOrigin, uCameraRot.y), uCameraRot.x);
            rayDir = rotateY(rotateX(rayDir, uCameraRot.y), uCameraRot.x);

            vec3 finalColor = vec3(0.01, 0.01, 0.015);

            // 바깥쪽 3겹 원 고정 반지름 레이아웃 정의
            float modelMaxBoundary = 0.44; 
            float r1 = 0.58;               
            float r2 = 1.00;               
            float r3 = 1.42;               

            // [알고리즘 2 : 시점 비례 원근 투영 수식 연산]
            // 카메라와 시선 위치의 벡터적 외연을 역계산하여, 모델 표면의 실시간 웹 텍스처 픽셀 정보가
            // 외부 3겹 구체 벽면으로 원근 비례 확대/축소 스케일에 맞춰 정확하게 직선 투영되도록 연산합니다.
            vec3 perspectiveProjVector = rayOrigin - rayDir * (dot(rayOrigin, rayDir));
            vec3 normProjVec = normalize(perspectiveProjVector) * modelMaxBoundary;
            vec3 projectedPixelData = getWebTexturedModels(normProjVec);

            // 3D 스캔 가동
            float tDist = 0.0;
            bool hitModel = false;
            vec3 hitColor = vec3(0.0);

            for(int i = 0; i < 55; i++) {
                vec3 currentSamplePos = rayOrigin + rayDir * tDist;
                float currentRadius = length(currentSamplePos);

                if (currentRadius > r3 + 0.3) break; 

                // 1번 원 내부 공간 판정: 웹 텍스처를 적용한 실제 5개 입체 모델 원본 형태 출력
                if (currentRadius < r1) {
                    vec3 rawModelPixel = getWebTexturedModels(currentSamplePos);
                    if (length(rawModelPixel) > 0.0) {
                        hitModel = true;
                        hitColor = rawModelPixel;
                        break;
                    }
                }
                tDist += 0.06;
            }

            // 시선 단면 레이어의 가상 물리 반지름 탐지
            float currentViewRadius = length(rayOrigin + rayDir * (tDist * 0.72));

            if (hitModel) {
                finalColor = hitColor; 
            } 
            else {
                // [알고리즘 3 : 공간 픽셀 선형 보간 구현]
                // 레이어 사이의 거리에 비례하여 웹 텍스처의 투영 입자 픽셀을 거리 기반 mix 보간하여 부드럽게 융합 생성
                if (currentViewRadius >= r1 && currentViewRadius < r2) {
                    float factor = (currentViewRadius - r1) / (r2 - r1);
                    finalColor = mix(projectedPixelData * 0.98, projectedPixelData * 0.38, factor);
                } 
                else if (currentViewRadius >= r2 && currentViewRadius < r3) {
                    float factor = (currentViewRadius - r2) / (r3 - r2);
                    finalColor = mix(projectedPixelData * 0.38, projectedPixelData * 0.06, factor);
                }
                else if (currentViewRadius >= r3 && currentViewRadius < r3 + 0.30) {
                    float factor = (currentViewRadius - r3) / 0.30;
                    finalColor = mix(projectedPixelData * 0.06, vec3(0.0), factor);
                }
            }

            // 3겹 구형 그리드 식별용 테두리 발광 라인 처리
            float lineThick = 0.006;
            if (abs(currentViewRadius - r1) < lineThick || abs(currentViewRadius - r2) < lineThick || abs(currentViewRadius - r3) < lineThick) {
                if (length(projectedPixelData) > 0.0) {
                    finalColor = mix(vec3(0.0, 1.0, 0.7), finalColor * 1.6, 0.45);
                }
            }

            fragColor = vec4(finalColor, 1.0);
        }
    `
};
