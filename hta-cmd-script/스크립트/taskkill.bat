








REM --------------------------------------
REM GC 시작
REM --------------------------------------
powershell -Command "Clear-Host; [System.GC]::Collect()"





REM --------------------------------------
REM 프로세 종료 시작
REM --------------------------------------


taskkill /im "StoreDesktopExension.exe" /f /t

taskkill /im "ZOOKServer.exe" /f /t

taskkill /im "OneDrive.Sync.Service.exe" /f /t
taskkill /im "OneDrive.Sync.Service.exe" /f /t

taskkill /im "updater.exe" /f /t
taskkill /im "updater.exe" /f /t


taskkill /im "SearchHost.exe" /f /t
taskkill /im "SearchHost.exe" /f /t


taskkill /im "nosstarter.npe" /f /t
taskkill /im "nossvc.exe" /f /t
taskkill /im "MaWebDRMAgent.exe" /f /t
taskkill /im "MaWebDRMAgent_x64.exe" /f /t
taskkill /im "MaWebDRMSVC.exe" /f /t
taskkill /im "ObCrossEXService.exe" /f /t
taskkill /im "veraport-x64.exe" /f /t
taskkill /im "VestCert.exe" /f /t
taskkill /im "wermgr.exe" /f /t
taskkill /im "wpmsvc.exe" /f /t
taskkill /im "delfino.exe" /f /t

taskkill /im "winvnc4.exe" /f /t

taskkill /im "Copilot.exe" /f /t

taskkill /im "HD-Player.exe" /f /t

taskkill /im "BstkSVC.exe" /f /t
taskkill /im "BstService.exe" /f /t
taskkill /im "BlueStacks.exe" /f /t
taskkill /im "BstAndroidVm.exe" /f /t


taskkill /im "Widgets.exe" /f /t
taskkill /im "WidgetService.exe" /f /t

taskkill /im "Widgets.exe" /f /t
taskkill /im "WidgetService.exe" /f /t
taskkill /im "WinStore.App.exe" /f /t
taskkill /im "PhoneExperienceHost.exe" /f /t




REM --------------------------------------


taskkill /im "runtimebroker.exe" /f /t
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



REM --------------------------------------
REM ENTER를 누르면. 서비스 종료 시작
REM -------------------------------------- 
PAUSE

@REM fontdrvhost.exe Usermode Font 
@REM DiagTrack    Connected User Experiences and Telemetry


sc stop "AppXSvc"
sc stop "TrustedInstaller"
sc stop "wuauserv"

sc stop "AppXSvc"
sc stop "TrustedInstaller"
sc stop "wuauserv"

sc stop "BrokerInfrastructure"
sc stop "ProfSvc"


sc stop "SnowDaemonMaker"

sc stop "BstkDrv_nxt"


sc stop "PcaSvc"				@REM Program Compatibility Assistant Service
sc stop "DPS"				@REM Diagnostic Policy Service
sc stop "EventLog"			@REM Windows Event Log


sc stop "WhiteDefenderServices"
sc stop "TurboCleaner Services"
sc stop "V3 Service"
sc stop "wuauserv"
sc stop "MixedRealityOpenXRSvc"
sc stop "Everything"





REM --------------------------------------
REM ENTER를 누르면. MS EDGE 종료 시작
REM -------------------------------------- 
PAUSE
taskkill /im "msedge.exe" /f /t
taskkill /im "msedgewebview2.exe" /f /t




REM --------------------------------------
REM ENTER를 누르면.  WSearch 서비스 종료 시작
REM -------------------------------------- 
PAUSE
sc stop "WSearch"


REM --------------------------------------
REM ENTER를 누르면.  가상 관련 서비스 시작
REM -------------------------------------- 
PAUSE
sc start "VSS"
sc start "vds"
sc start "swprv"
sc start "lltdsvc"
sc start "COMSysApp"
sc start "sppsvc"



REM --------------------------------------
REM NGEN.EXE EQI
REM --------------------------------------


cd %WinDir%\Microsoft.NET\Framework\v4.0.30319 
Ngen.exe eqi 

cd %WinDir%\Microsoft.NET\Framework64\v4.0.30319 
Ngen.exe eqi 

setx PATH=%PATH%;%WinDir%\Microsoft.NET\Framework\v4.0.30319 
setx PATH=%PATH%;%WinDir%\Microsoft.NET\Framework64\v4.0.30319

C:\Windows\Microsoft.NET\Framework64\v4.0.30319



REM ---------------------------------------
REM mmagent 시작
REM ---------------------------------------
powershell -Command "Enable-mmagent -MemoryCompression"



REM ---------------------------------------
REM WINMGMT.EXE 재시작
REM --------------------------------------


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




REM --------------------------------------
REM Enter를 누르면. explorer.exe 종료 시작
REM --------------------------------------
PAUSE


@REM taskkill /im "explorer.exe" /f /t
@REM explorer.exe

cd "C:\Users\%UserName%\AppData\Local\Microsoft\Terminal Server Client\Cache"
del bcache24.bmc






REM --------------------------------------
REM Enter를 누르면. 절전모드 OFF - GC 실행
REM --------------------------------------
PAUSE


REM 절전모드 종료
powercfg /hibernate off







REM --------------------------------------
REM Enter를 누르면. 윈도우 dwm.exe explorer.exe 종료 재시작
REM --------------------------------------
PAUSE

taskkill /im "dwm.exe" /f /t


@echo off
@REM # 프로세스 종료


taskkill /im "conhost.exe" /f /t
taskkill /im "cmd.exe" /f /t
taskkill /im "mshta.exe" /f /t
taskkill /im "WindowsTerminal.exe" /f /t


powershell -Command "Stop-Process -Name 'conhost','cmd','mshta','explorer' -Force -ErrorAction SilentlyContinue;"

@REM Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
@REM Stop-Process -Name "conhost" -Force -ErrorAction SilentlyContinue
@REM Stop-Process -Name "cmd" -Force -ErrorAction SilentlyContinue
@REM Stop-Process -Name "mshta" -Force -ErrorAction SilentlyContinue
@REM Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
# explorer 다시 시작
@REM Start-Process "explorer.exe"




start explorer.exe


REM --------------------------------------
REM Enter를 누르면. cmd 화면 종료 마무리
REM --------------------------------------
PAUSE
EXIT













powershell -Command "Stop-Process -Name 'conhost','cmd','mshta','explorer' -Force -ErrorAction SilentlyContinue; Start-Process 'explorer.exe'"



taskkill /im "conhost.exe" /f /t
PAUSE
taskkill /im "cmd.exe" /f /t
PAUSE
taskkill /im "mshta.exe" /f /t
PAUSE

taskkill /f /im explorer.exe & start explorer.exe
PAUSE


start explorer.exe



for /f "tokens=*" %s in ('sc query state^= all ^| findstr /R "^SERVICE_NAME:"') do @echo %s

for /f "tokens=*" %s in ('sc query state^= all ^| findstr /R "^SERVICE_NAME:"') do (
    set svc=%s
    call set svc=%%svc:SERVICE_NAME:=%%
    echo Stopping !svc!
    sc stop !svc!
)

taskkill /F /FI "USERNAME ne NT AUTHORITY\SYSTEM" /FI "STATUS eq running"








sc stop SharedAccess
sc config SharedAccess start= disabled

sc start SharedAccess
sc config SharedAccess start= enable



@REM ---------------------------------------

cd %WinDir%\Microsoft.NET\Framework\v4.0.30319 
Ngen.exe eqi 
?
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

diskperf ?n

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




