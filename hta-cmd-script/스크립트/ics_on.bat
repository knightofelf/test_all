




sc start intelCASService



@REM - ICS 중지
netsh wlan stop hostednetwork

@REM - ICS 시작
netsh wlan start hostednetwork




@REM
sc qtriggerinfo hns
sc triggerinfo hns delete

sc stop hns
sc start hns





@REM 파워쉘 실행
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ics_on.ps1"


@REM 윈도우7
sc start SharedAccess
sc config SharedAccess start= demand
sc config SharedAccess start= auto


NETSH WLAN start
net start SharedAccess
net start WLAN
net start pla
net start winmgmt



@echo off
echo ICS 자동화 실행 중...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Start-Service SharedAccess; ^
   $m = New-Object -ComObject HNetCfg.HNetShare; ^
   $pub = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq '이더넷 3' }; ^
   $pri = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq '이더넷' }; ^
   $pubConfig = $m.INetSharingConfigurationForINetConnection.Invoke($pub); ^
   $priConfig = $m.INetSharingConfigurationForINetConnection.Invoke($pri); ^
   $pubConfig.DisableSharing(); $priConfig.DisableSharing(); ^
   $pubConfig.EnableSharing(0); $priConfig.EnableSharing(1)"
echo 완료!



pause

