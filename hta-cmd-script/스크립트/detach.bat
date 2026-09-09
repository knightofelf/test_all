






@echo off
set VHDPath="I:\Steam.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo detach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!



@echo off
set VHDPath="E:\VM\heroes.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo detach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!



@echo off
set VHDPath="J:\heroes.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo detach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!




pause
exit












@REM ------------------------------------------------------------------



@REM 절전 종료 명령어
@REM powercfg /h /type reduced

@REM 시작 명령어
@REM powercfg /h off







@echo off
set VHDPath="G:\TEST\heroes4.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo attach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!




@echo off
set VHDPath="N:\TEST\heroes4.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo attach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!












@echo off
set VHDPath="\\shint-pc\VM\heroes3.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo attach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!



@echo off
set VHDPath="\\shint-pc\VM\Steam2.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo attach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!







@echo off
set VHDPath="E:\heroes3.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo attach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!




@echo off
set VHDPath="E:\Steam2.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo attach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!





@echo off
@REM "C:\Program Files\Mem Reduct\memreduct.exe"





@echo off
set VHDPath="D:\VM\heroes3.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo attach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!



@echo off
set VHDPath="\\shint-pc\N\VM\heroes3.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo attach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!


@echo off
set VHDPath="\\shint-pc\I\Steam2.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo attach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!





@echo off
set VHDPath="\\shint-pc\G VM\cache.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo attach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!





@echo off
set VHDPath="\\shint-pc\N\VM\cache.vhd"

echo select vdisk file=%VHDPath% > "%temp%\mount_vhd.txt"
echo attach vdisk >> "%temp%\mount_vhd.txt"

diskpart /s "%temp%\mount_vhd.txt"

del "%temp%\mount_vhd.txt"
echo VHD 마운트 완료!










@echo off
set VHDPath="H:\Steam.vhd"

echo select vdisk file=%VHDPath% > "%temp%\detach_vhd.txt"
echo detach vdisk >> "%temp%\detach_vhd.txt"

diskpart /s "%temp%\detach_vhd.txt"

del "%temp%\detach_vhd.txt"
echo VHD 마운트 해제 완료!
pause