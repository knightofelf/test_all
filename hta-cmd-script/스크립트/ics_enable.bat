
@echo off
@REM 윈도우 10 용


@REM 윈도우7
sc stop SharedAccess
sc config SharedAccess start= disabled

sc start SharedAccess
sc config SharedAccess start= demand
sc config SharedAccess start= auto



@REM 파워쉘 실행
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ics_enable.ps1"




PAUSE
EXIT




@REM -----------------------------------------------------------------------------------------------------------------

ncpa.cpl

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters"

# 연결과 DLL 해제
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters" -Name "ServiceDllUnloadOnStop" -Value 0
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters" -Name "SharedAutoDial" -Value 1

# DHCP, DNS 프록시, 방화벽 활성화
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters" -Name "EnableDHCPAllocator" -Value 1
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters" -Name "EnableDNSProxy" -Value 1
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters" -Name "EnableFirewall" -Value 1

Restart-Service SharedAccess



ScopeAddress           : 192.168.137.1
ScopeAddressBackup     : 192.168.137.1
ServiceDll             : C:\Windows\System32\ipnathlp.dll
ServiceDllUnloadOnStop : 1
SharedAutoDial         : 0
PSPath                 : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Share
                         dAccess\Parameters
PSParentPath           : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Share
                         dAccess
PSChildName            : Parameters
PSDrive                : HKLM
PSProvider             : Microsoft.PowerShell.Core\Registry



NETSH WLAN stop 
NETSH WLAN start
net stop SharedAccess
net start SharedAccess
net stop WLAN
net start WLAN
net stop pla
net start pla
net stop winmgmt
net start winmgmt



netsh wlan show profiles

net stop SharedAccess
sc stop SharedAccess

sc start SharedAccess
net start SharedAccess


sc stop SharedAccess
sc config SharedAccess start= disabled

sc start SharedAccess
sc config SharedAccess start= demand
sc config SharedAccess start= auto



NET HELPMSG 2182




@REM -----------------------------------------------------------------------------------------------------------------

$SharedConnection = "이더넷 3"   # 인터넷이 연결된 어댑터
$TargetConnection = "이더넷"     # 인터넷을 공유할 대상 어댑터

$netSharingManager = New-Object -ComObject HNetCfg.HNetShare
$connections = $netSharingManager.EnumEveryConnection()

foreach ($conn in $connections) {
    $config = $netSharingManager.INetSharingConfigurationForINetConnection($conn)
    $props = $netSharingManager.NetConnectionProps($conn)

    if ($props.Name -eq $SharedConnection) {
        if (-not $config.SharingEnabled) {
            $config.EnableSharing(0)  # ICS 제공자
        }
    }

    if ($props.Name -eq $TargetConnection) {
        if (-not $config.SharingEnabled) {
            $config.EnableSharing(1)  # ICS 수신자
        }
    }
}


Restart-Service SharedAccess


@REM -----------------------------------------------------------------------------------------------------------------
netsh interface show interface

ipconfig
netsh interface ipv4 show interfaces



@REM -----------------------------------------------------------------------------------------------------------------

netsh interface show interface
netsh interface ipv4 show interfaces
powershell -command "Set-NetConnectionSharing -ConnectionName '이더넷' -SharingMode Enable -ShareConnection '이더넷 3'"
-ConnectionName → 인터넷이 있는 어댑터 이름 (예: Wi-Fi)
-ShareConnection → 공유받을 내부 어댑터 이름 (예: Ethernet)
-SharingMode Enable → 공유 켜기
powershell -command "Set-NetConnectionSharing -ConnectionName 'Wi-Fi' -SharingMode Disable"
netsh advfirewall set allprofiles state on

ics 인터넷 공유 cmd  재시작
net stop SharedAccess
net start SharedAccess

powershell -command "Set-NetConnectionSharing -ConnectionName 'Wi-Fi' -SharingMode Enable -ShareConnection 'Ethernet'"

@echo off
echo ICS (Internet Connection Sharing) 재시작 중...
net stop SharedAccess
net start SharedAccess

powershell -command "Set-NetConnectionSharing -ConnectionName '이더넷' -SharingMode Enable -ShareConnection '이더넷 3'"



echo 완료!
pause




@REM -----------------------------------------------------------------------------------------------------------------

netsh advfirewall reset
netsh interface ip reset
ipconfig /release
ipconfig /renew

   netsh wlan stop hostednetwork
   netsh wlan set hostednetwork mode=disallow

   sc config SharedAccess start= auto


@REM 공유 접속 재시작
netsh wlan stop hostednetwork
net stop SharedAccess
net stop WLAN
net start WLAN
net start SharedAccess
netsh wlan start hostednetwork




@REM -----------------------------------------------------------------------------------------------------------------

powershell -File "C:\Users\magun\Desktop\ics_enable.ps1"
powershell -ExecutionPolicy Bypass -File "C:\Users\magun\Desktop\ics_enable.ps1"

이 시스템에서 스크립트를 실행할 수 없으므로 C:\Users\magun\Desktop\ics_enable.ps1 파일을 로드할 수 없습니다. 자세한 내
용은 about_Execution_Policies(https://go.microsoft.com/fwlink/?LinkID=135170)를 참조하십시오.


powershell -File "C:\경로\ics_enable.ps1"
powershell -ExecutionPolicy Bypass -File "C:\경로\ics_enable.ps1"
pwsh -ExecutionPolicy Bypass -File "C:\경로\ics_enable.ps1"

@echo off
echo ICS 자동화 실행 중...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ics_enable.ps1"
pause





dir          :: 파일 목록 보기
netsh wlan show profiles
net stop SharedAccess

Get-Process
Get-Service SharedAccess
Stop-Service SharedAccess
Start-Service SharedAccess


@echo off
echo ICS 자동화 실행 중...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "Start-Service SharedAccess; ^
   $m = New-Object -ComObject HNetCfg.HNetShare; ^
   $pub = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq 'Ethernet 3' }; ^
   $pri = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq 'Wi-Fi' }; ^
   $pubConfig = $m.INetSharingConfigurationForINetConnection.Invoke($pub); ^
   $priConfig = $m.INetSharingConfigurationForINetConnection.Invoke($pri); ^
   $pubConfig.DisableSharing(); $priConfig.DisableSharing(); ^
   $pubConfig.EnableSharing(0); $priConfig.EnableSharing(1)"
echo 완료!
pause





@REM -----------------------------------------------------------------------------------------------------------------
@REM ICS에는 두 역할이 있습니다:
@REM Public(0) → 인터넷이 나오는 쪽 (예: "Ethernet 3")
@REM Private(1) → 인터넷을 나눠주는 내부 네트워크 어댑터 (예: "Wi-Fi", "VirtualBox Host-Only Network")
@REM 즉, 인터넷이 있는 어댑터는 EnableSharing(0)으로,
@REM 공유받을 어댑터는 EnableSharing(1)로 설정해야 합니다.

@REM Ethernet 3 → Public (인터넷 제공)
@REM Wi-Fi → Private (공유받는 쪽)

@REM 실행 시 마지막 줄에 Public: True (0) / Private: True (1) 이 뜨면 정상 적용된 겁니다.



@echo off
$m = New-Object -ComObject HNetCfg.HNetShare

# 인터넷이 들어오는 어댑터 (Ethernet 3)
$public = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq "이더넷 4" }
$pubConfig = $m.INetSharingConfigurationForINetConnection.Invoke($public)
$pubConfig.DisableSharing()
$pubConfig.EnableSharing(0)   # Public

# 공유받을 어댑터 (Wi-Fi)
$private = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq "이더넷 2" }
$priConfig = $m.INetSharingConfigurationForINetConnection.Invoke($private)
$priConfig.DisableSharing()
$priConfig.EnableSharing(1)   # Private

# 상태 확인
"Public:  Enabled=$($pubConfig.SharingEnabled), Type=$($pubConfig.SharingType)"
"Private: Enabled=$($priConfig.SharingEnabled), Type=$($priConfig.SharingType)"




@echo off
echo === ICS (Internet Connection Sharing) 자동 설정 시작 ===
net stop SharedAccess
net start SharedAccess

:: PowerShell 스크립트 실행
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$m = New-Object -ComObject HNetCfg.HNetShare; ^
   $pub = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq '이더넷 4' }; ^
   $pri = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq '이더넷 2' }; ^
   $pubConfig = $m.INetSharingConfigurationForINetConnection.Invoke($pub); ^
   $priConfig = $m.INetSharingConfigurationForINetConnection.Invoke($pri); ^
   $pubConfig.DisableSharing(); ^
   $priConfig.DisableSharing(); ^
   $pubConfig.EnableSharing(0); ^
   $priConfig.EnableSharing(1); ^
   'Public: ' + $pubConfig.SharingEnabled + ' (' + $pubConfig.SharingType + ')'; ^
   'Private: ' + $priConfig.SharingEnabled + ' (' + $priConfig.SharingType + ')';"

echo === 완료! ===
pause








ics 인터넷 공유 cmd
netsh interface show interface
netsh interface ipv4 show interfaces
powershell -command "Set-NetConnectionSharing -ConnectionName 'Wi-Fi' -SharingMode Enable -ShareConnection 'Ethernet'"
-ConnectionName → 인터넷이 있는 어댑터 이름 (예: Wi-Fi)
-ShareConnection → 공유받을 내부 어댑터 이름 (예: Ethernet)
-SharingMode Enable → 공유 켜기
powershell -command "Set-NetConnectionSharing -ConnectionName 'Wi-Fi' -SharingMode Disable"
netsh advfirewall set allprofiles state on

ics 인터넷 공유 cmd  재시작
net stop SharedAccess
net start SharedAccess

powershell -command "Set-NetConnectionSharing -ConnectionName 'Wi-Fi' -SharingMode Enable -ShareConnection 'Ethernet'"

@echo off
echo ICS (Internet Connection Sharing) 재시작 중...
net stop SharedAccess
net start SharedAccess

powershell -command "Set-NetConnectionSharing -ConnectionName '이더넷 4' -SharingMode Enable -ShareConnection '이더넷 2'"

powershell -command "Set-NetConnectionSharing -ConnectionName 'Wi-Fi' -SharingMode Enable -ShareConnection 'Ethernet'"
echo 완료!
pause






Set-NetConnectionSharing : 'Set-NetConnectionSharing' 용어가 cmdlet, 함수, 스크립트 파일 또는 실행할 수 있는 프로그램
이름으로 인식되지 않습니다. 

net stop SharedAccess
net start SharedAccess

netsh wlan set hostednetwork mode=allow ssid=MyHotspot key=12345678
netsh wlan start hostednetwork

Install-Module -Name NetConnectionSharing
Import-Module NetConnectionSharing

Set-NetConnectionSharing -ConnectionName "Wi-Fi" -ShareConnection "Ethernet" -SharingMode Enable



nuget 설치
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Get-PackageProvider -Name NuGet

'PSGallery' is not trusted repository
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

Install-Module -Name NetConnectionSharing -Force -Scope CurrentUser
Import-Module NetConnectionSharing


Windows 10 Home
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Get-PackageProvider -Name NuGet

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name NetConnectionSharing -Force -Scope CurrentUser
Import-Module NetConnectionSharing

Set-NetConnectionSharing -ConnectionName "Wi-Fi" -ShareConnection "Ethernet" -SharingMode Enable

netsh wlan set hostednetwork mode=allow ssid=MyHotspot key=12345678
netsh wlan start hostednetwork


//
Install-Module -Name NetConnectionSharing -Force -Scope CurrentUser
Import-Module NetConnectionSharing

Set-NetConnectionSharing -ConnectionName "Wi-Fi" -ShareConnection "Ethernet" -SharingMode Enable

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters"


//
netsh routing ip nat install
netsh routing ip nat add interface "Ethernet" full
netsh routing ip nat add interface "Wi-Fi" private


//
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name NetConnectionSharing -Force -Scope CurrentUser
Import-Module NetConnectionSharing

//
$m = New-Object -ComObject HNetCfg.HNetShare
$m.EnumEveryConnection |% { $m.NetConnectionProps.Invoke($_) }
$c1 = $m.EnumEveryConnection |? { $m.NetConnectionProps.Invoke($_).Name -eq "Ethernet 3" }
$config1 = $m.INetSharingConfigurationForINetConnection.Invoke($c1)
$config1.DisableSharing()

$config1.SharingEnabled
$config1.SharingType
$config1.EnableSharing(0)

$config1.SharingEnabled
$config1.SharingType


//
# ICS 관리용 COM 객체 생성
$m = New-Object -ComObject HNetCfg.HNetShare

# 현재 존재하는 모든 네트워크 어댑터 출력
$m.EnumEveryConnection | % { $m.NetConnectionProps.Invoke($_) }

# "Ethernet 3" 어댑터 객체 선택
$c1 = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq "Ethernet 3" }

# 해당 어댑터에 대한 ICS 설정 객체 가져오기
$config1 = $m.INetSharingConfigurationForINetConnection.Invoke($c1)

# ICS 비활성화
$config1.DisableSharing()

# 상태 확인
$config1.SharingEnabled   # True/False
$config1.SharingType      # 0=None, 1=Public(공유할 인터넷), 2=Private(내부 네트워크)

# ICS 활성화 (0 = Public, 1 = Private)
$config1.EnableSharing(0)   # 0=Public, 1=Private


//
$m = New-Object -ComObject HNetCfg.HNetShare

# 인터넷 있는 쪽 (Ethernet 3)
$public = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq "Ethernet 3" }
$pubConfig = $m.INetSharingConfigurationForINetConnection.Invoke($public)
$pubConfig.DisableSharing()
$pubConfig.EnableSharing(0)   # Public

# 내부 네트워크 쪽 (Wi-Fi)
$private = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq "Wi-Fi" }
$priConfig = $m.INetSharingConfigurationForINetConnection.Invoke($private)
$priConfig.DisableSharing()
$priConfig.EnableSharing(1)   # Private

# 확인
"Public Enabled:  $($pubConfig.SharingEnabled), Type: $($pubConfig.SharingType)"
"Private Enabled: $($priConfig.SharingEnabled), Type: $($priConfig.SharingType)"



// ics_enable.bat (BAT 파일)
@echo off
echo === ICS (Internet Connection Sharing) 자동 설정 시작 ===

:: PowerShell 스크립트 실행
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$m = New-Object -ComObject HNetCfg.HNetShare; ^
   $pub = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq '이더넷 4' }; ^
   $pri = $m.EnumEveryConnection | ? { $m.NetConnectionProps.Invoke($_).Name -eq '이더넷 2' }; ^
   $pubConfig = $m.INetSharingConfigurationForINetConnection.Invoke($pub); ^
   $priConfig = $m.INetSharingConfigurationForINetConnection.Invoke($pri); ^
   $pubConfig.DisableSharing(); ^
   $priConfig.DisableSharing(); ^
   $pubConfig.EnableSharing(0); ^
   $priConfig.EnableSharing(1); ^
   'Public: ' + $pubConfig.SharingEnabled + ' (' + $pubConfig.SharingType + ')'; ^
   'Private: ' + $priConfig.SharingEnabled + ' (' + $priConfig.SharingType + ')';"

echo === 완료! ===
pause



// @REM 윈도우 7 용
sc stop SharedAccess
sc config SharedAccess start= disabled

sc start SharedAccess
sc config SharedAccess start= demand
sc config SharedAccess start= auto


NETSH WLAN stop 
NETSH WLAN start
net stop SharedAccess
net start SharedAccess
net stop WLAN
net start WLAN
net stop pla
net start pla
net stop winmgmt
net start winmgmt




//
인터넷이 있는 어댑터 이름 cmd
netsh interface show interface
Interface Name → 어댑터 이름 (Wi-Fi, Ethernet 등)
State = Connected → 실제 인터넷이 연결된 어댑터

Admin State    State          Type             Interface Name
-------------------------------------------------------------------------
Enabled        Connected      Dedicated        Wi-Fi
Enabled        Disconnected   Dedicated        Ethernet

Interface Name → 어댑터 이름 (Wi-Fi, Ethernet 등)
State = Connected → 실제 인터넷이 연결된 어댑터

ipconfig
netsh interface ipv4 show interfaces


