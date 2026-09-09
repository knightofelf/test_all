/**
 * =========================================================================
 * [PAGE 2 : 시점 비례 원근 매핑 및 고성능 픽셀 공간 보간 알고리즘 코어]
 * 자바스크립트 문자열 이스케이프 오염을 차단한 완전 격리 데이터 레이어입니다.
 * =========================================================================
 */

const GL_CORE_SHADERS = {
    // 2-1. 정점 셰이더 소스 레코드
    vertex: `#version 300 es
        in vec2 position;
        out vec2 vUv;
        void main() {
            vUv = position * 0.5 + 0.5;
            gl_Position = vec4(position, 0.0, 1.0);
        }
    `,

    // 2-2. 프래그먼트 셰이더 소스 레코드 (핵심 공간 수학 그래픽 연산 파트)
    fragment: `#version 300 es
        precision highp float;
        in vec2 vUv;
        uniform vec2 uResolution;
        uniform float uTime;
        uniform vec2 uCameraRot;
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

        vec3 get5FixedModels3D(vec3 p) {
            float d1 = length(p);
            if (d1 < 0.14) {
                float ch = step(0.5, fract(atan(p.z, p.x) * 3.0 / 3.141592)) == step(0.5, fract(p.y * 14.0)) ? 1.0 : 0.0;
                return mix(vec3(1.0, 0.25, 0.25), vec3(0.12, 0.04, 0.04), ch);
            }

            vec3 p2 = p - vec3(0.0, 0.30, 0.0);
            if (sdBox(p2, vec3(0.075)) < 0.0) {
                float st = step(0.5, fract(p2.y * 28.0));
                return mix(vec3(0.1, 0.9, 0.4), vec3(0.01, 0.2, 0.05), st);
            }

            vec3 p3 = p - vec3(0.0, -0.30, 0.0);
            float d3 = length(vec2(length(p3.xz) - 0.065, p3.y)) - 0.022;
            if (d3 < 0.0) {
                float rad = step(0.5, fract(atan(p3.z, p3.x) * 4.0 / 3.141592));
                return mix(vec3(0.95, 0.85, 0.1), vec3(0.2, 0.15, 0.0), rad);
            }

            vec3 p4 = p - vec3(-0.30, 0.0, 0.0);
            if (length(p4) < 0.085) {
                float dots = step(0.65, sin(p4.x * 45.0) * sin(p4.y * 45.0) * sin(p4.z * 45.0));
                return mix(vec3(0.1, 0.55, 1.0), vec3(0.9, 0.95, 1.0), dots);
            }

            vec3 p5 = p - vec3(0.30, 0.0, 0.0);
            if (sdBox(p5, vec3(0.075)) < 0.0) {
                float grid = step(0.8, max(fract(p5.x * 24.0), max(fract(p5.y * 24.0), fract(p5.z * 24.0))));
                return mix(vec3(0.85, 0.1, 0.95), vec3(0.08, 0.0, 0.12), grid);
            }

            return vec3(0.0);
        }

        void main() {
            vec2 screenUv = (gl_FragCoord.xy - uResolution * 0.5) / uResolution.y;

            vec3 rayOrigin = vec3(0.0, 0.0, -3.4); 
            vec3 rayDir = normalize(vec3(screenUv, 1.3)); 

            rayOrigin = rotateY(rotateX(rayOrigin, uCameraRot.y), uCameraRot.x);
            rayDir = rotateY(rotateX(rayDir, uCameraRot.y), uCameraRot.x);

            vec3 finalColor = vec3(0.01, 0.01, 0.015);

            float modelMaxBoundary = 0.44; 
            float r1 = 0.58;               
            float r2 = 1.00;               
            float r3 = 1.42;               

            vec3 perspectiveProjVector = rayOrigin - rayDir * (dot(rayOrigin, rayDir));
            vec3 normProjVec = normalize(perspectiveProjVector) * modelMaxBoundary;
            vec3 projectedPixelData = get5FixedModels3D(normProjVec);

            float tDist = 0.0;
            bool hitModel = false;
            vec3 hitColor = vec3(0.0);

            for(int i = 0; i < 55; i++) {
                vec3 currentSamplePos = rayOrigin + rayDir * tDist;
                float currentRadius = length(currentSamplePos);

                if (currentRadius > r3 + 0.3) break; 

                if (currentRadius < r1) {
                    vec3 rawModelPixel = get5FixedModels3D(currentSamplePos);
                    if (length(rawModelPixel) > 0.0) {
                        hitModel = true;
                        hitColor = rawModelPixel;
                        break;
                    }
                }
                tDist += 0.06;
            }

            float currentViewRadius = length(rayOrigin + rayDir * (tDist * 0.72));

            if (hitModel) {
                finalColor = hitColor; 
            } 
            else {
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
