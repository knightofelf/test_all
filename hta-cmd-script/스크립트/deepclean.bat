

@REM


handle c3ae405b-b3da-4858-8cad-a9901dc92b19.tmp
del "%userprofile%\AppData\Local\Temp\c3ae405b-b3da-4858-8cad-a9901dc92b19.tmp"

del /q /f /s %TEMP%\*.*
del /q /f /s C:\Windows\Temp\*.*

net stop wuauserv
net stop bits
rd /s /q %windir%\SoftwareDistribution
net start wuauserv
net start bits


sc stop WaaSMedicSvc
del "C:\Windows\Logs\waasmedic\waasmedic.20250921_020045_922.etl"

del /s /q %windir%\Logs\*.* 

del /q /f /s C:\Windows\Prefetch\*.*






@REM
taskkill /F /IM msedge.exe /T


del /F /Q "%localappdata%\Microsoft\Edge\User Data\Default\FontAccess\*.*"


del /F /Q  "C:\Windows\ServiceProfiles\LocalService\AppData\Local\FontCache\*.*"

del /F /Q  "%localappdata%\FontCache\*.*"




net stop FontCache
del /f /s /q "%WinDir%\ServiceProfiles\LocalService\AppData\Local\FontCache\*.*"
del /q /f /s C:\Windows\System32\FNTCACHE.dat
net start FontCache



@REM C:\Windows\ServiceProfiles\LocalService\AppData\Local
@REM mklink /J "C:\Windows\ServiceProfiles\LocalService\AppData\Local\FontCache" "Z:\FontCache"
 
@REM mklink /j "C:\Program Files\Naver" "D:\Program Files\Naver"



del "%localappdata%\Microsoft\Edge\User Data\Default\Cache\*.*" /Q
del "%localappdata%\Microsoft\Edge\User Data\Default\Code Cache\*.*" /Q
del "%localappdata%\Microsoft\Edge\User Data\Default\GPUCache\*.*" /Q

del "%userprofile%\AppData\Local\Microsoft\Edge\User Data\Default\Cache\*.*" /Q
del "%userprofile%\AppData\Local\Microsoft\Edge\User Data\Default\Code Cache\*.*" /Q

del "%localappdata%\Microsoft\Edge\User Data\Default\Sessions\*.*" /Q
del "%localappdata%\Microsoft\Edge\User Data\Default\Last Session" /Q
del "%localappdata%\Microsoft\Edge\User Data\Default\Last Tabs" /Q

del "%localappdata%\Microsoft\Edge\User Data\Default\GPUCache\*.*" /Q
del "%localappdata%\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage\*.*" /Q





@REM cleanmgr /sageset:1
cleanmgr /sagerun:1


cleanmgr.exe /AUTOCLEAN



pause
exit










taskkill /F /IM msedge.exe /T

del "%userprofile%\AppData\Local\Microsoft\Edge\User Data\Default\Sessions\*.*" /Q

del "%userprofile%\AppData\Local\Microsoft\Edge\User Data\Default\Cache\*.*" /Q
del "%userprofile%\AppData\Local\Microsoft\Edge\User Data\Default\Code Cache\*.*" /Q

rmdir /S /Q "%userprofile%\AppData\Local\Microsoft\Edge"

start msedge -inprivate

