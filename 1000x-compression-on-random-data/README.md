2018년 업데이트 ㅇ_ㅇ'' <BR>
Core2Duo E7400 - GeforceGT 610 기준 ㅇ_ㅇ;; <BR>
1000배 이상. 1초 순간 압축되는 rand length 랜덤 데이터 ㅇ_ㅇ;; LZMA 7zip WinZipX XZ brotli <BR>
Test extreme compression ratios (1000x or more) for random data in around 1 second using 7z and Brotli <BR>
압축효율 0% 면 성공 <BR>
랜덤파일은 생성 속도가 느리니. 미리 생성해서 사용. <BR>
<BR>
<BR>
rand ( ) % 2 ~ 8 <BR>
GetTickCount ( ) % 2 ~ 8 <BR>
~16 ~32도 압축효율 가능성이 보임. ㅇ_ㅇ;; <BR>
- r값 : 랜덤 데이터를 1바이트씩 얻는다. 아스키 문자 숫자 '4' '2' '5'... <BR>
- ar[r] = 1 : 8바이트배열ar의 순서 위치r을 활성화. 비활성화 인 경우만 처리 <BR>
<BR>
랜덤값 위치에 값을. 입력하거나 활성화하고. 이미 값이 있으면. 다음 랜덤값 실행. <BR>
4257201436 실제 생성된 랜덤값 <BR>
42570136  실제 처리된 값 <BR>
[ ][ ][4][ ][ ][ ][ ][ ] <BR>
[ ][2][4][ ][ ][ ][ ][ ] <BR>
[ ][2][4][ ][ ][ ][5][ ] <BR>
[ ][2][4][ ][ ][7][5][ ] <BR>
[ ][2][4][ ][0][7][5][ ] <BR>
[ ][2][4][ ][0][7][5][1] <BR>
[3][2][4][ ][0][7][5][1] <BR>
[3][2][4][6][0][7][5][1] 마지막 결과값 8바이트 문자 <BR>
<BR>
✅10MB 처리시. 대략 67~89배 압축   -  약0.15MB (150KB)  약0.11MB (112KB)  <BR>
✅1GB 처리시. 대략 19~20만배 압축  -  약5.4KB  약5.1KB  <BR>
brotli --quality=11 --large_window --window=24 input_file.txt -o output_file.br <BR>
brotli --quality=11 --large_window --lgwin=30 input_1gb.txt -o output_file.br <BR>
<BR>
<BR>
// 다른값 위치로 한팩씩 모으기 - Z팩? <BR>
Compatibility Pack - Service Pack - HPC Pack - Codec Pack - Media Pack - Feature Pack - Language Packs <BR>
<BR>
alignas(16) 얼라이어스를 위하여 - 호드를 위하여 <BR>
<BR> 
// VC 명령어 대응 값: 도 이와 유사 <BR>
- /Zp1 : 소스 전체에 #pragma pack(1)을 적용한 것과 동일. <BR>
- /Zp8 : 소스 전체에 8바이트 기본 정렬을 적용. <BR>
<BR>
4K 3840x2160 FullScreen ActiveX Flash - CPU 점유율 5% 이하 VPU 사용 <BR>
ATSC 3.0 미국 표준 UHD TV - NTFS ReFS UDF(Live) - NTSC PAL - NTP 네트워크 시간 - Windows NT <BR>
프리즈 frieze 건축 구조 - XPRESS4K 비슷  https://heroes.nexon.com/common/postview?b=63&n=3806 <BR>
<BR>
8바이트씩 묶어서 저장하면. 1000배 이상 압축 가능 ㅇ_ㅇ'' <BR>
예전 노트패드 마저. 대용량 랜덤파일 순간 읽기가 되었다. ㅇ_ㅇ'' <BR>
마치. HyperThreding의 고속 포트 순서 처럼 ㅇ_ㅇ'' <BR> 
XP PC 시절에는 COM Port 도 짝수 홀수 충돌 영향을 받았다.  Core2Duo 도 비슷하다. <BR> 
 <BR>
// 유사한 속도 향상 사례<BR>
QCOW WinSPD 1GB 읽기 쓰기 벤치마크 테스트 기록 <BR>
CreateFileMapping () x1.5배 읽기 쓰기 <BR>
PWSa 2번째 쓰기부터. 1초 순간 복사 <BR>
FP8 > FP16 > FP32 > FP64 2배씩 작은쪽 속도 우선 <BR>
SFTP 압축전송 향상 <BR>
VirtualBox UDMA6 가상 지원 <BR>

Intel Multicore Hyperthreading 
https://www.youtube.com/watch?v=VcoVYfDVEww <BR> 
<BR> 
<BR> 
[전세계 RSA 물리적 총용량: 약 22.5 GB] <BR>
  ├── 중복 데이터 (85%~90%) : 약 19.5 GB (호스팅 기본 키, 클라우드 복제본, 와일드카드) <BR>
  └── 순수 고유 데이터 (10%~15%) : 약 3.0 GB (실제 활성화되어 운영 중인 고유 인증서) <BR>
<BR> 
<BR> 
1111111111... 2222222222... 처럼. 길게. 효율적으로. 활용할만 하다. <BR> 
그렇다고. 초고속?에 만능?인것은 아니다. ㅇ_ㅇ;; <BR> 
<BR> 
<BR> 
<BR> 
------------------------------ <BR>
## 1. C++ 파일 생성 처리 시간 (10MB vs 1GB) <BR>
컴퓨터의 성능(특히 SSD 저장 속도)과 나노초 타이머(std::chrono) 호출 비용에 따라 결정됩니다. <BR>
 <BR>
* 10MB 데이터 생성: 약 0.05초 ~ 0.1초 내외 (찰나의 순간에 완료) <BR>
* 1GB 데이터 생성: 약 4초 ~ 8초 내외 <BR>
* 속도 분석: 나노초 타이머(high_resolution_clock)를 매번 호출하는 연산 비용이 생각보다 크기 때문에, 순수 rand()나 버그 상태였던 GetTickCount() 시절(1~2초)보다는 몇 초 더 걸립니다. 하지만 여전히 대용량 파일을 수 초 만에 고속으로 뽑아냅니다. <BR>
 <BR>
------------------------------ <BR>
## 2. 압축 프로그램 처리 시간 (최고 압축 옵션 기준) <BR>
데이터의 크기가 커질수록, 그리고 알고리즘의 사전을 넓게 열수록 CPU 연산량이 급격히 늘어납니다. <BR>
## 📊 10MB 원본 파일 압축 시 <BR>
* 7-Zip / XZ (LZMA2 Ultra): 약 0.5초 ~ 1초 (사전 크기가 작아 순식간에 끝남) <BR>
* Brotli (Quality 11): 약 1초 ~ 2초 (Brotli 특유의 정교한 콘텍스트 분석 연산 때문에 LZMA보다 약간 더 걸림) <BR>
## 📊 1GB 원본 파일 압축 시   <BR>
* 7-Zip / XZ (사전 1024MB 강제 지정): 약 3분 ~ 8분 내외 <BR>
* 이유: 1GB 크기의 사전을 메모리(RAM)에 통째로 올려두고 데이터 블록 간의 연관 관계를 끊임없이 대조(매칭)해야 하므로 CPU 코어를 풀가동하며 수 분의 시간이 소요됩니다. <BR>
* Brotli (기본 옵션): 약 15초 ~ 30초 <BR>
* 이유: 기억 창(Window) 크기가 16MB로 제한되어 있어 과거 데이터를 빠르게 잊어버리기 때문에 연산할 양이 적어 압축이 매우 빨리 끝납니다. (대신 압축 후 크기가 11MB로 커짐) <BR>
* Brotli (극한 옵션 --lgwin=30): 약 5분 ~ 10분 이상 <BR>
<BR>
<BR>

