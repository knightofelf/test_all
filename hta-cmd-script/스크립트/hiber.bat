


@echo off
set VHDPath="H:\Steam.vhd"


@REM VHD 마운트 해제
echo select vdisk file=%VHDPath% > "%temp%\detach_vhd.txt"
echo detach vdisk >> "%temp%\detach_vhd.txt"

diskpart /s "%temp%\detach_vhd.txt"

del "%temp%\detach_vhd.txt"
echo VHD 마운트 해제 완료!


@REM 절전 종료 명령어
powercfg -h off
rundll32.exe powrprof.dll,SetSuspendState Sleep


pause
exit






@REM ---------------------------------

@REM 윈도우 절전모드 종료 -절전모드 종료는 RAM에 데이터를 유지한 채 저전력 상태에서 복귀 - 추천
powercfg -h off
rundll32.exe powrprof.dll,SetSuspendState Sleep
timeout /t 1800 && rundll32.exe powrprof.dll,SetSuspendState Sleep

@REM cmd 최대절전모드 종료 - 최대절전모드 종료는 RAM 내용을 디스크에 저장하고 전원을 완전히 끈 뒤 복구 - 전력 지연발생
powercfg /h off
powercfg /h /type reduced
shutdown /h





@REM ---------------------------------

powershell -Command "@'

<!--
control powercfg.cpl
제어판\시스템 및 보안\전원 옵션 cmd
powercfg /getactivescheme
powercfg /setactive SCHEME_MIN
powercfg /setactive SCHEME_MAX
powercfg /setactive SCHEME_BALANCED
powercfg -h off
powercfg /list
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

절전 완전 해제
powercfg -change -standby-timeout-ac 0
powercfg -change -hibernate-timeout-ac 0
powercfg -h off
//-->

'@ | Out-Null"

