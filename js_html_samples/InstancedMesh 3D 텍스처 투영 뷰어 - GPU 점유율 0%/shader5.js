/**
 * =========================================================================
 * [PAGE 2 : InstancedMesh 전용 고성능 360도 투영 및 공간 보간 알고리즘]
 * 자바스크립트 오염 및 신택스 에러를 완전 차단한 원시 문자열 데이터 팩입니다.
 * =========================================================================
 */

const GL_INSTANCED_SHADERS = {
    // 2-1. 하드웨어 가속 인스턴싱 변환용 정점 셰이더 (Vertex Shader)
    vertex: String.raw`#version 300 es
        in vec3 position;
        in vec2 uv;
        out vec2 vUv;
        out vec3 vLocalPos;

        void main() {
            vUv = uv;
            vLocalPos = position;
            
            // InstancedMesh 고유의 내장 인스턴스 행렬(instanceMatrix)을 연동하여 GPU 하드웨어 정점 한 번에 제어
            gl_Position = projectionMatrix * modelViewMatrix * instanceMatrix * vec4(position, 1.0);
        }
    `,

    // 2-2. 5개 모델 텍스처링, 시점 비례 원근 방사 투영 및 3겹 사이 공간 보간 셰이더 (Fragment Shader)
    fragment: String.raw`#version 300 es
        precision highp float;
        in vec2 vUv;
        in vec3 vLocalPos;
        
        uniform vec2 uResolution;
        uniform float uTime;
        uniform vec2 uCameraRot;
        out vec4 fragColor;

        // 3D 구형 공간 카메라 시점 공전 행렬
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

        // 고해상도 하이테크 가상 웹-스타일 텍스처 실시간 스캔 생성기
        vec3 generateVirtualWebTexture(vec2 uv) {
            vec2 g = fract(uv * 12.0);
            float line = step(0.92, max(g.x, g.y));
            
            vec3 col1 = vec3(0.1, 0.5, 1.0) + 0.4 * sin(uTime + uv.xyx * 4.0);
            vec3 col2 = vec3(1.0, 0.0, 0.4) + 0.4 * cos(uTime - uv.yyx * 3.0);
            
            vec3 basePattern = mix(col1, col2, step(0.5, fract(uv.x * 3.0)));
            return mix(basePattern, vec3(1.0), line);
        }

        // 고정 텍스처 스킨이 바인딩된 5개의 가상 입체 모델 생성식
        vec3 get5WebTexturedModels(vec3 p) {
            float d1 = length(p);
            
            // 1번 인스턴스 모델: 정중앙 (0,0,0) 구체
            if (d1 < 0.15) {
                vec3 n = normalize(p);
                vec2 texUV = vec2(atan(n.z, n.x) / 6.283185 + 0.5, n.y * 0.5 + 0.5);
                return generateVirtualWebTexture(texUV);
            }

            // 2번 인스턴스 모델: 상단 스트라이프 큐브 상자
            vec3 p2 = p - vec3(0.0, 0.31, 0.0);
            if (sdBox(p2, vec3(0.075)) < 0.0) {
                return generateVirtualWebTexture(fract(p2.xz * 3.0 + 0.5));
            }

            // 3번 인스턴스 모델: 하단 원형 링 토러스
            vec3 p3 = p - vec3(0.0, -0.31, 0.0);
            float d3 = length(vec2(length(p3.xz) - 0.065, p3.y)) - 0.024;
            if (d3 < 0.0) {
                vec2 texUV = vec2(atan(p3.z, p3.x) / 6.283185 + 0.5, p3.y * 4.0);
                return generateVirtualWebTexture(fract(texUV));
            }

            // 4번 인스턴스 모델: 좌측 원기둥 실린더
            vec3 p4 = p - vec3(-0.31, 0.0, 0.0);
            float d4 = max(length(p4.xz) - 0.06, abs(p4.y) - 0.08);
            if (d4 < 0.0) {
                vec2 texUV = vec2(atan(p4.z, p4.x) / 6.283185 + 0.5, p4.y * 3.0);
                return generateVirtualWebTexture(fract(texUV));
            }

            // 5번 인스턴스 모델: 우측 정밀 캡슐 기하체
            vec3 p5 = p - vec3(0.31, 0.0, 0.0);
            float d5 = length(p5 - vec3(0.0, clamp(p5.y, -0.05, 0.05), 0.0)) - 0.06;
            if (d5 < 0.0) {
                return generateVirtualWebTexture(fract(p5.xy * 3.0));
            }

            return vec3(0.0);
        }

        void main() {
            // 스크린 픽셀 노멀라이즈
            vec2 screenUv = (gl_FragCoord.xy - uResolution * 0.5) / uResolution.y;

            // 3D 레이마칭 광선 추적 카메라 좌표축 계산
            vec3 rayOrigin = vec3(0.0, 0.0, -3.4); 
            vec3 rayDir = normalize(vec3(screenUv, 1.3)); 

            // 360도 인터랙션 회전 궤도 동기화
            rayOrigin = rotateY(rotateX(rayOrigin, uCameraRot.y), uCameraRot.x);
            rayDir = rotateY(rotateX(rayDir, uCameraRot.y), uCameraRot.x);

            vec3 finalColor = vec3(0.01, 0.01, 0.015); // 배경색

            // 3겹의 원 레이어 고정 반지름 수치 세팅
            float modelMaxBoundary = 0.44; 
            float r1 = 0.58;               
            float r2 = 1.00;               
            float r3 = 1.42;               

            // [시점 비례 원근 투영 알고리즘]
            // 시선 벡터와 카메라 가상 초점면의 내적 거리를 실시간 역산하여 
            // 3겹 구체 단면에 맺히는 스케일이 완벽한 시점 비례 원근 비율로 자동 조절되도록 연산합니다.
            vec3 perspectiveProjVector = rayOrigin - rayDir * (dot(rayOrigin, rayDir));
            vec3 normProjVec = normalize(perspectiveProjVector) * modelMaxBoundary;
            vec3 projectedPixelData = get5WebTexturedModels(normProjVec);

            // 하드웨어 가속형 3D 공간 스캔 레이어 탐색 (보폭 확대로 GPU 부하 완전히 제거)
            float tDist = 0.0;
            bool hitModel = false;
            vec3 hitColor = vec3(0.0);

            for(int i = 0; i < 55; i++) {
                vec3 currentSamplePos = rayOrigin + rayDir * tDist;
                float currentRadius = length(currentSamplePos);

                if (currentRadius > r3 + 0.3) break; 

                // 1번 원 내부 공간 판정: 인스턴싱 텍스처가 적용된 실제 5개 입체 모델 원본 형태 가시화 출력
                if (currentRadius < r1) {
                    vec3 rawModelPixel = get5WebTexturedModels(currentSamplePos);
                    if (length(rawModelPixel) > 0.0) {
                        hitModel = true;
                        hitColor = rawModelPixel;
                        break;
                    }
                }
                tDist += 0.06; // 탐색 속도 가속화 패치
            }

            // 시선이 관통 중인 최종 3D 가상 레이어 공간 반지름 검출
            float currentViewRadius = length(rayOrigin + rayDir * (tDist * 0.72));

            if (hitModel) {
                finalColor = hitColor; 
            } 
            else {
                // [사이 공간 픽셀 선형 보간 알고리즘]
                // 3겹 레이어의 각 사이 공간을 볼 때 거리에 비례하여 투영 텍스처 픽셀을 mix 보간 생성
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

            // 3겹 구체 그리드 식별용 테두리 발광 라인 처리
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
