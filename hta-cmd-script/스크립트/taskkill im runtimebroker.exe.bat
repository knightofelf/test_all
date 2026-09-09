




taskkill /im "Widgets.exe" /f /t
taskkill /im "WidgetService.exe" /f /t
taskkill /im "WinStore.App.exe" /f /t
taskkill /im "PhoneExperienceHost.exe" /f /t




@REM ---------------------------------------

sc stop "PcaSvc"				@REM Program Compatibility Assistant Service
sc stop "DPS"				@REM Diagnostic Policy Service
sc stop "EventLog"			@REM Windows Event Log


sc stop "WhiteDefenderServices"
sc stop "TurboCleaner Services"
sc stop "V3 Service"
sc stop "wuauserv"
sc stop "WSearch"
sc stop "MixedRealityOpenXRSvc"
sc stop "Everything"

sc start "VSS"
sc start "vds"
sc start "swprv"
sc start "lltdsvc"
sc start "COMSysApp"
sc start "sppsvc"

taskkill /im "runtimebroker.exe" /f /t
taskkill /im "msedge.exe" /f /t
taskkill /im "Widgets.exe" /f /t
taskkill /im "WidgetService.exe" /f /t
taskkill /im "TCleaner.exe" /f /t
taskkill /im "TCleanerTray.exe" /f /t
taskkill /im "TurboCleaner.exe" /f /t
taskkill /im "YellowPageTray.exe" /f /t
taskkill /im "AYAgent.exe" /f /t
taskkill /im "ASDSvc.exe" /f /t
taskkill /im "WhiteDSvc.exe" /f /t
taskkill /im "WhiteDMain.exe" /f /t
taskkill /im "v3l4sp.exe" /f /t
taskkill /im "ctfmon.exe" /f /t
taskkill /im "NGM.exe" /f /t
taskkill /im "NGM64.exe" /f /t
taskkill /im "ApplicationFrameHost.exe" /f /t
taskkill /im "GoogleCrashHandler.exe" /f /t
taskkill /im "GoogleCrashHandler64.exe" /f /t
taskkill /im "dllhost.exe" /f /t
taskkill /im "spaceman.exe" /f /t
taskkill /im "WhiteDMain.exe" /f /t
taskkill /im "WhiteDSvc.exe" /f /t
taskkill /im "YelloPageTray.exe" /f /t
taskkill /im "SmartDefrag.exe" /f /t
taskkill /im "TiWorker.exe" /f /t
taskkill /im "trayicon.exe" /f /t

@REM taskkill /im "explorer.exe" /f /t
@REM explorer.exe

cd "C:\Users\%UserName%\AppData\Local\Microsoft\Terminal Server Client\Cache"
del bcache24.bmc


cleanmgr.exe /AUTOCLEAN


PAUSE
EXIT


sc stop SharedAccess
sc config SharedAccess start= disabled

sc start SharedAccess
sc config SharedAccess start= enable



@REM ---------------------------------------

cd %WinDir%\Microsoft.NET\Framework\v4.0.30319 
Ngen.exe eqi 
​
cd %WinDir%\Microsoft.NET\Framework64\v4.0.30319 
Ngen.exe eqi 


@REM ---------------------------------------

cleanmgr.exe /SAGESET:7
cleanmgr.exe /SAGERUN:7
cleanmgr.exe /TUNEUP:7
cleanmgr.exe /LOWDISK
cleanmgr.exe /VERYLOWDISK
cleanmgr.exe /AUTOCLEAN


@REM ---------------------------------------

cd c:\windows\system32
lodctr /R
cd c:\windows\sysWOW64
lodctr /R

lodctr /e:PerfOS
lodctr /Q


WINMGMT.EXE /RESYNCPERF


Lodtr infoctrs.ini
lodctr w3ctrs.ini

net stop pla
net start pla
net stop winmgmt
net start winmgmt


EXIT


@REM ---------------------------------------

reg add "HKLM\SYSTEM\CurrentControlSet\Services\PartMgr" /v EnableCounterForIoctl /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\FltMgr" /v EnableCounterForIoctl /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\VolMgr" /v EnableCounterForIoctl /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "CountOperations" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "DisableDiskCounters" /t REG_DWORD /d "1" /f

diskperf –n

Get-Service -Name "pla" | Restart-Service -Verbose
Get-Service -Name "winmgmt" | Restart-Service -Force -Verbose



@REM ---------------------------------------

@REM 비트맵 캐싱 파일을 제거 해도 접속 유지가 된다.
C:\Users\magun\AppData\Local\Microsoft\Terminal Server Client\Cache
C:\Users\%UserName%\AppData\Local\Microsoft\Terminal Server Client\Cache

cd "C:\Users\%UserName%\AppData\Local\Microsoft\Terminal Server Client\Cache"
del bcache24.bmc



@REM ---------------------------------------

bcdedit.exe /set groupsize 8
bcdedit.exe /set groupsize maxsize
bcdedit.exe /set maxgroup on
bcdedit.exe /set groupaware on


@REM ---------------------------------------

Dism /online /cleanup-image /restorehealth
sfc /scannow
Dism /Online /Cleanup-Image /ScanHealth
Dism /Online /Cleanup-Image /CheckHealth
Dism /Cleanup-Mountpoints



@REM ---------------------------------------

Compact.exe /CompactOs:always




