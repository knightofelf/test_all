

@echo off
setlocal enabledelayedexpansion

set count=0
for /f "delims=" %%A in ('powercfg /a ^| find "\n"') do (
    set /a count+=1
    call setx MYVAR!count! "%%A"
)

echo 저장된 줄 수: %count%


pause
exit



@REM ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ




@echo off
for /f "delims=" %%A in ('powercfg /a ^| find " "') do (
    setx MYVAR "%%A"
echo MYVAR
)



runas /user:Administrator "powercfg.bat"



@echo off
set CMD=powercfg /a | find "Sleep"
for /f "delims=" %%A in ('%CMD%') do echo %%A

@echo off
powercfg /a > temp.txt
find "Sleep" < temp.txt > result.txt
for /f "delims=" %%A in (result.txt) do echo %%A
del temp.txt
del result.txt



@echo off
for /f "delims=" %%A in ('powercfg /a') do echo %%A


@echo off
for /f "delims=" %%A in ('powercfg /a | find " "') do (
    call setx MYVAR "%%A"
)



@echo off
for /f "delims=" %%A in ('powercfg /a ^| find "Sleep") do (
    echo %%A > temp.txt
    goto :done
)
:done
set /p MYVAR=<temp.txt
setx MYVAR "%MYVAR%"
del temp.txt



@echo off
for /f "delims=" %%A in ('powercfg /a  ^| find " "') do (
    setx MYVAR "%%A"
)



for /f "delims=" %%A in ('powercfg /a ^| find "Sleep"') do (
    setx MYVAR "%%A"
)




@echo off
for /f "delims=" %%A in ('powercfg /a') do (
    set MYVAR=%%A
    echo !MYVAR!
)
