




# Uninstall-Module PSInternetConnectionSharing


# 설치
# Install-Module PSInternetConnectionSharing

# 새로운 기능 및 개선 사항에 대한 최신 poweshell을 설치하세요
# winget install --id Microsoft.PowerShell --source winget

# $PSVersionTable.PSVersion



Stop-Service SharedAccess
Set-Service SharedAccess -StartupType Disabled

Set-Service SharedAccess -StartupType Automatic
Start-Service SharedAccess


# Disable-Ics -ConnectionName "이더넷 3"

$manager = New-Object -ComObject HNetCfg.HNetShare
$connections = $manager.EnumEveryConnection()

foreach ($conn in $connections) {
    $config = $manager.INetSharingConfigurationForINetConnection($conn)
    $props = $manager.NetConnectionProps($conn)

    if ($props.Name -eq "이더넷 3" -and $config.SharingEnabled) {
        $config.DisableSharing()
        Write-Host "ICS 해제 완료: $($props.Name)"
    }
}



try {
    $manager = New-Object -ComObject HNetCfg.HNetShare
    $connections = $manager.EnumEveryConnection()

    foreach ($conn in $connections) {
        $config = $manager.INetSharingConfigurationForINetConnection($conn)
        $props = $manager.NetConnectionProps($conn)

        if ($props.Name -eq "이더넷 3" -and $config.SharingEnabled) {
            $config.DisableSharing()
            "ICS 해제 완료: $($props.Name)" | Out-File "D:\ICS\log.txt" -Append
        }
    }

    Set-Ics -PublicConnectionName "이더넷 3" -PrivateConnectionName "이더넷"
    Get-Ics -ConnectionName "이더넷" | Out-File "D:\ICS\log.txt" -Append
}
catch {
    "오류 발생: $_" | Out-File "D:\ICS\log.txt" -Append
}




Set-NetIPInterface -InterfaceAlias "이더넷 3" -Dhcp Enabled
Set-NetIPInterface -InterfaceAlias "이더넷" -Dhcp Enabled
Set-DnsClientServerAddress -InterfaceAlias "이더넷" -ServerAddresses ("168.126.63.1", "1.1.1.1")



# USB 테더링 - LAN
Set-Ics -PublicConnectionName "이더넷 3" -PrivateConnectionName "이더넷"




$adapters = @("이더넷", "이더넷 3")  # 어댑터 이름을 실제 환경에 맞게 수정
foreach ($adapter in $adapters) {
    Write-Host "갱신 중: $adapter"
    Restart-NetAdapter -Name $adapter -Confirm:$false
}



Restart-Service SharedAccess



Get-Ics -ConnectionName "이더넷 3"
Get-Ics -ConnectionName "이더넷"
Get-Command -Module PSInternetConnectionSharing
Get-NetAdapter | Select Name, Status
Get-NetAdapter 


Read-Host "계속하려면 Enter 키를 누르세요..."
EXIT









@"
# -----------------------------------------------------------------------------------------------------------

식별 되지 않은 네트워크만 잡아봐

Set-NetIPInterface -InterfaceAlias "이더넷 3" -Dhcp Enabled

Set-NetIPInterface -InterfaceAlias "이더넷" -Dhcp Disabled
Set-DnsClientServerAddress -InterfaceAlias "이더넷" -ServerAddresses ("8.8.8.8", "1.1.1.1")



Set-NetIPInterface -InterfaceAlias "이더넷 3" -Dhcp Enabled
Set-NetIPInterface -InterfaceAlias "이더넷" -Dhcp Disabled
Set-DnsClientServerAddress -InterfaceAlias "이더넷" -ServerAddresses ("168.126.63.1", "1.1.1.1")


Get-NetIPInterface | Select InterfaceAlias, Dhcp



//
Get-NetAdapter | Select Name, InterfaceDescription, Status
Get-NetIPConfiguration | Select InterfaceAlias, IPv4Address, IPv4DefaultGateway, DNSServer


Get-NetIPInterface | Sort-Object InterfaceMetric | Format-Table InterfaceAlias, InterfaceMetric

Set-NetIPInterface -InterfaceAlias "이더넷 3" -InterfaceMetric 10
Set-NetIPInterface -InterfaceAlias "이더넷" -InterfaceMetric 50

Test-Connection -ComputerName 8.8.8.8 -InterfaceAlias "이더넷 3"
Test-Connection -ComputerName 8.8.8.8 -InterfaceAlias "이더넷"




### ?? 전체 `EnabledState` 코드 목록 (WMI 기준)

| 코드 | 상태 설명 |
|------|-----------|
| 0 | Unknown |
| 1 | Enabled |
| 2 | Disabled |
| 3 | Shutting Down |
| 4 | Not Applicable |
| 5 | Enabled but Offline |
| 6 | In Test |
| 7 | Deferred |
| 8 | Quiesce |
| 9 | Starting |


Enable-NetAdapter -Name "이더넷 3"
Set-NetIPInterface -InterfaceAlias "이더넷 3" -Dhcp Enabled
New-NetIPAddress -InterfaceAlias "이더넷 3" -IPAddress 192.168.1.100 -PrefixLength 24 -DefaultGateway 192.168.1.1

Enable-NetAdapter -Name "이더넷"
Set-NetIPInterface -InterfaceAlias "이더넷" -Dhcp Enabled
New-NetIPAddress -InterfaceAlias "이더넷" -IPAddress 192.168.137.1 -PrefixLength 24 -DefaultGateway 192.168.137.1

New-NetIPAddress -InterfaceAlias "이더넷" -IPAddress 192.168.137.1 -PrefixLength 24 -DefaultGateway 192.168.137.254

New-NetIPAddress -InterfaceAlias "이더넷" `
                 -IPAddress 192.168.137.1 `
                 -PrefixLength 24 `
                 -DefaultGateway 192.168.137.254


Get-NetIPConfiguration | Format-List
Get-NetIPInterface | Format-Table InterfaceAlias, InterfaceMetric, Dhcp, AddressFamily




### ?? 추가적으로 자주 등장하는 WMI/CIM 속성들

#### ? `Availability`

- 장치의 사용 가능 상태를 나타냅니다.
- 예시 값:
  - `3` → Running/Full Power
  - `8` → Offline
  - `10` → Degraded

#### ? `NetConnectionStatus`

- 네트워크 연결 상태를 나타냅니다.
- 예시 값:
  | 코드 | 의미 |
  |------|------|
  | `0` | Disconnected |
  | `1` | Connecting |
  | `2` | Connected |
  | `3` | Disconnecting |
  | `4` | Hardware not present |
  | `5` | Hardware disabled |
  | `6` | Hardware malfunction |
  | `7` | Media disconnected |
  | `8` | Authenticating |
  | `9` | Authentication succeeded |
  | `10` | Authentication failed |

#### ? `ConfigManagerErrorCode`

- 장치 관리자에서 발생한 오류 코드
- `0` → 정상
- 그 외 숫자 → 오류 발생 (예: `22`는 장치가 사용 중지됨)

---




Get-CimInstance Win32_NetworkAdapter | Where-Object { $_.Name -eq "이더넷 3" } | Format-List Name, EnabledState, NetConnectionStatus, Availability, ConfigManagerErrorCode



$adapterName = "이더넷 3"

# 어댑터 정보 가져오기
$adapter = Get-NetAdapter -Name $adapterName

# 어댑터 속성 출력
$adapter | Format-List *



$adapterName = "이더넷"

# 어댑터 정보 가져오기
$adapter = Get-NetAdapter -Name $adapterName

# 어댑터 속성 출력
$adapter | Format-List *


Get-CimInstance -ClassName Win32_NetworkAdapter | Select-Object Name, EnabledDefault, EnabledState


$adapter = Get-NetAdapter -Name "이더넷 3"
$adapter.Status


Get-CimInstance Win32_NetworkAdapter | Select-Object Name, NetConnectionStatus

Get-NetIPConfiguration -InterfaceAlias $adapterName


New-NetIPAddress -InterfaceAlias "이더넷 3" -IPAddress 192.168.1.100 -PrefixLength 24 -DefaultGateway 192.168.1.1
Set-DnsClientServerAddress -InterfaceAlias "이더넷 3" -ServerAddresses ("8.8.8.8", "1.1.1.1")
Disable-NetAdapter -Name "이더넷 3" -Confirm:$false
Enable-NetAdapter -Name "이더넷 3"
Set-NetIPInterface -InterfaceAlias "이더넷 3" -NlMtu 1400
Get-NetIPConfiguration -InterfaceAlias "이더넷 3"

Set-NetIPInterface -InterfaceAlias "이더넷 3" -Dhcp Enabled






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

netsh int ip reset
netsh winsock reset




Stop-Service SharedAccess
Set-Service SharedAccess -StartupType Disabled

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess




ipconfig /release
ipconfig /renew


wmic path win32_networkadapter where "NetConnectionID='이더넷 3'" call disable
wmic path win32_networkadapter where "NetConnectionID='이더넷'" call disable

wmic path win32_networkadapter where "NetConnectionID='이더넷 3'" call enable
wmic path win32_networkadapter where "NetConnectionID='이더넷'" call enable

Disable-NetAdapter -Name "이더넷 3" -Confirm:$false
Disable-NetAdapter -Name "이더넷" -Confirm:$false

Enable-NetAdapter -Name "이더넷 3" -Confirm:$false
Enable-NetAdapter -Name "이더넷" -Confirm:$false



Set shell = CreateObject("Shell.Application")
shell.ShellExecute "powershell", " -ExecutionPolicy Bypass -File '%~dp0ps_ics.ps1", "", "runas", 1
Set shell = Nothing


Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' 현재 VBScript 경로 기준으로 PowerShell 스크립트 경로 설정
psScript = fso.GetAbsolutePathName(".") & "\ics_enable.ps1"

' 관리자 권한으로 PowerShell 실행
shell.Run "powershell -ExecutionPolicy Bypass -File '%~dp0ps_ics.ps1""", 1, True
shell.Run "cmd /k schtasks /run /tn ""RunAsAdmin"" & pause", 1, True




| 목적 | 방법 | 관리자 권한 | 결과 받기 |
|------|------|--------------|------------|
| 관리자 권한 실행 | `shell.Run` + `Start-Process -Verb RunAs` | ? | ? |
| 결과 받기 | `shell.Exec` | ? | ? |


Set shell = CreateObject("Shell.Application")
shell.ShellExecute "powershell", "-ExecutionPolicy Bypass -File '%~dp0ps_ics.ps1'", "", "runas", 1
Set shell = Nothing



Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' 현재 VBScript 경로 기준으로 PowerShell 스크립트 경로 설정
psScript = fso.GetAbsolutePathName(".") & "\ics_enable.ps1"

' 관리자 권한으로 PowerShell 실행
shell.Run "powershell -Command ""Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File """ & psScript & """' -Verb RunAs""", 1, True


' shell.Run "powershell -Command ""Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File """ & psScript & """' -Verb RunAs""", 1, True

' PowerShell 실행
' shell.Run "powershell -NoProfile -ExecutionPolicy Bypass -File """ & psScript & """", 1, True





Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

psScript = fso.GetAbsolutePathName(".") & "\ps_ics.ps1"

' 관리자 권한으로 PowerShell 실행
shell.Run "powershell -Command ""Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File """ & psScript & """' -Verb RunAs""", 1, True






Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' 현재 VBS 경로 기준으로 ps_ics.ps1 경로 설정
scriptPath = fso.GetParentFolderName(fso.GetAbsolutePathName("."))
psScript = scriptPath & "\ps_ics.ps1"

' PowerShell 스크립트 실행 결과 받기
Set exec = shell.Exec("powershell -ExecutionPolicy Bypass -File """ & psScript & """")

' 결과 대기 및 읽기
' Do While exec.Status = 0
'   WScript.Sleep 100
' Loop

InputBox "PowerShell 작업이 완료될 때까지 기다립니다. 확인을 누르면 계속합니다.", "대기 중"

output  = exec.StdOut.ReadAll
MsgBox "PowerShell 결과:" & vbCrLf & output 






  Dim shell
  Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' 현재 VBS 경로 기준으로 ps_ics.ps1 경로 설정
scriptPath = fso.GetParentFolderName(fso.GetAbsolutePathName("."))
psScript = scriptPath & "\ps_ics.ps1"

shell.Run "powershell.exe -NoExit -Command ""Start-Process powershell -ArgumentList '-NoExit -ExecutionPolicy Bypass -File """ & psScript & """' -Verb RunAs""", 1, True



Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' 현재 VBS 경로 기준으로 ps_ics.ps1 경로 설정
scriptPath = fso.GetParentFolderName(fso.GetAbsolutePathName("."))
psScript = scriptPath & "\ps_ics.ps1"

' PowerShell 관리자 권한으로 실행 + 창 유지
shell.Run "powershell.exe -NoExit -Command ""Start-Process powershell -ArgumentList '-NoExit -ExecutionPolicy Bypass -File """ & psScript & """' -Verb RunAs""", 1, True

' 사용자 확인으로 창 유지
MsgBox "작업이 완료되었습니다. PowerShell 창이 보였나요?", vbInformation, "실행 확인"





Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' 현재 VBS 파일 경로 얻기
scriptPath = fso.GetParentFolderName(WScript.ScriptFullName)
psScript = scriptPath & "\ps_ics.ps1"

' PowerShell 관리자 권한으로 실행
shell.Run "powershell -Command ""Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File """ & psScript & """' -Verb RunAs""", 1, True


Set shell = CreateObject("WScript.Shell")
shell.Run "powershell -Command ""Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File ""%~dp0ps_ics.ps1""' -Verb RunAs""", 1, True


' shell.Run "powershell -Command ""Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File ""C:\ICS\ps_ics.ps1""' -Verb RunAs""", 1, True

' powershell -ExecutionPolicy Bypass -File "%~dp0ps_ics.ps1"
' pause

' Set shell = CreateObject("WScript.Shell")
' shell.Run "powershell -Command ""Start-Process 'ps_ics.ps1' -Verb RunAs""", 1, True

' Set shell = CreateObject("WScript.Shell")
' shell.Run "powershell -Command ""Start-Process '%~dp0start.bat' -Verb RunAs""", 1, True

' Set shell = CreateObject("Shell.Application")
' shell.ShellExecute "ps_ics.bat", "", "", "runas", 1
' shell.Run "powershell -Command ""Start-Process 'start.bat' -Verb RunAs""", 1, True

' powershell -ExecutionPolicy Bypass -File "%~dp0ps_ics.ps1"
' powershell -ExecutionPolicy Bypass -File "./ps_ics.ps1"




"@ | Out-Null


