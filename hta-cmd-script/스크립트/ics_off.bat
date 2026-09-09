




@REM 윈도우7
sc stop SharedAccess
sc config SharedAccess start= disabled


NETSH WLAN stop 
net stop SharedAccess
net stop WLAN
net stop pla
net stop winmgmt



@REM 파워쉘 실행
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ics_off.ps1"


@REM 윈도우7
sc stop SharedAccess
sc config SharedAccess start= disabled


NETSH WLAN stop 
net stop SharedAccess
net stop WLAN
net stop pla
net stop winmgmt


pause

