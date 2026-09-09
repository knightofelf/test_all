







@REM 시작 명령어


chkdsk C: /f /r
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth





cd %WinDir%\Microsoft.NET\Framework\v4.0.30319 
Ngen.exe eqi 
​
cd %WinDir%\Microsoft.NET\Framework64\v4.0.30319 
Ngen.exe eqi 
​
setx PATH=%PATH%;%WinDir%\Microsoft.NET\Framework\v4.0.30319 
setx PATH=%PATH%;%WinDir%\Microsoft.NET\Framework64\v4.0.30319
​
C:\Windows\Microsoft.NET\Framework64\v4.0.30319



PAUSE
EXIT








powercfg /hibernate off

powershell -Command "Clear-Host; [System.GC]::Collect()"



