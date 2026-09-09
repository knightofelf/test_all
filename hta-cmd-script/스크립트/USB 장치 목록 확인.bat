
@echo off



@REM 
echo ---------------------------------------------------------------------
echo powershell -ExecutionPolicy Bypass -Command  "wmic path CIM_LogicalDevice where \"Description like 'USB%'\" get /value"
echo ---------------------------------------------------------------------
echo 사용할 수 있는 인스턴스가 없습니다. - 메시지 발생시. bat 파일에서는 실행 안될 수 있음
powershell -ExecutionPolicy Bypass -Command  "wmic path CIM_LogicalDevice where \"Description like 'USB%'\" get /value"


@REM 
echo ---------------------------------------------------------------------
echo wmic path CIM_LogicalDevice where "Description like 'USB%'" get /value
echo ---------------------------------------------------------------------
echo 사용할 수 있는 인스턴스가 없습니다. - 메시지 발생시. bat 파일에서는 실행 안될 수 있음
wmic path CIM_LogicalDevice where "Description like 'USB%'" get /value


@REM 
echo ---------------------------------------------------------------------
echo wmic path CIM_LogicalDevice where "Description like 'USB%'" get /value
echo ---------------------------------------------------------------------
echo 설명 = 잘못된 쿼리입니다. - 메시지 발생시. bat 파일에서는 실행 안될 수 있음
cmd /c "wmic path CIM_LogicalDevice where \"Description like 'USB%'\" get /value"


@REM 
echo ---------------------------------------------------------------------
echo SET VAL=wmic path CIM_LogicalDevice where "Description like 'USB%'" get /value
echo CALL %VAL%
echo ---------------------------------------------------------------------
echo 사용할 수 있는 인스턴스가 없습니다. - 메시지 발생시. bat 파일에서는 실행 안될 수 있음
SET VAL=wmic path CIM_LogicalDevice where "Description like 'USB%'" get /value
CALL %VAL%





@REM 
echo ---------------------------------------------------------------------
echo wmic path CIM_LogicalDevice get Description, DeviceID
echo ---------------------------------------------------------------------
wmic path CIM_LogicalDevice get Description, DeviceID


@REM 
echo ---------------------------------------------------------------------
echo powershell -Command "Get-CimInstance Win32_PnPEntity | Where-Object {$_.Description -like '*USB*'} | Select Description, DeviceID"
echo ---------------------------------------------------------------------
powershell -Command "Get-CimInstance Win32_PnPEntity | Where-Object {$_.Description -like '*USB*'} | Select Description, DeviceID"



@REM 
echo ---------------------------------------------------------------------
echo powershell -Command "Get-WmiObject Win32_PnPEntity | Where-Object {$_.Description -like '*USB*'} | Select Description, DeviceID"
echo ---------------------------------------------------------------------
powershell -Command "Get-WmiObject Win32_PnPEntity | Where-Object {$_.Description -like '*USB*'} | Select Description, DeviceID"


@REM 
echo ---------------------------------------------------------------------
echo powershell -Command "Get-CimInstance -ClassName Win32_PnPEntity | Where-Object {$_.Description -like '*USB*'} | Select Description, DeviceID"
echo ---------------------------------------------------------------------
powershell -Command "Get-CimInstance -ClassName Win32_PnPEntity | Where-Object {$_.Description -like '*USB*'} | Select Description, DeviceID"


@REM 
echo ---------------------------------------------------------------------
echo powercfg -h off
echo ---------------------------------------------------------------------
powercfg -h off


@REM 
echo ---------------------------------------------------------------------
echo powercfg -devicequery wake_armed
echo ---------------------------------------------------------------------
powercfg -devicequery wake_armed


echo ---------------------------------------------------------------------
echo ---------------------------------------------------------------------
echo .
echo USB 장치 드라이버 재설치를 진행하려면. ENTER 아니면.  X 종료
echo .
echo ---------------------------------------------------------------------
echo ---------------------------------------------------------------------
PAUSE


@REM 5. USB 장치 드라이버 재설치 (PowerShell 권장)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0USB 장치 목록 확인.ps1"



PAUSE
EXIT


















@REM --------------------------------------------------------------------------------------------------

devcon disable *USB*
timeout /t 2
devcon enable *USB*



powershell -Command "@'
Get-PnpDevice -FriendlyName "*USB*" | Disable-PnpDevice -Confirm:$false
Start-Sleep -Seconds 2
Get-PnpDevice -FriendlyName "*USB*" | Enable-PnpDevice -Confirm:$false
'@ | Out-Null"


powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Get-PnpDevice -FriendlyName '*USB*' | Disable-PnpDevice -Confirm:$false; ^
Start-Sleep -Seconds 2; ^
Get-PnpDevice -FriendlyName '*USB*' | Enable-PnpDevice -Confirm:$false"
echo 완료!


$PSVersionTable.PSVersion


Get-Command Disable-PnpDevice



Import-Module PnpDevice

Get-PnpDevice -FriendlyName "*USB*" | Disable-PnpDevice -Confirm:$false
$PSVersionTable.PSVersion




Get-PnpDevice -FriendlyName "*USB*" | Disable-PnpDevice -Confirm:$false
Start-Sleep -Seconds 2
Get-PnpDevice -FriendlyName "*USB*" | Enable-PnpDevice -Confirm:$false



powershell -command 'Get-PnpDevice -FriendlyName "*USB*" | Disable-PnpDevice -Confirm:$false'
powershell -command 'Start-Sleep -Seconds 2'
powershell -command 'Get-PnpDevice -FriendlyName "*USB*" | Enable-PnpDevice -Confirm:$false'


powershell -command "Get-PnpDevice -FriendlyName '*USB*' | Disable-PnpDevice -Confirm:\$false"
powershell -command "Start-Sleep -Seconds 2"
powershell -command "Get-PnpDevice -FriendlyName '*USB*' | Enable-PnpDevice -Confirm:\$false"








@REM --------------------------------------------------------------------------------------------------
$val = "wmic path CIM_LogicalDevice where `"Description like 'USB%'`" get /value"
Invoke-Expression $val





@REM --------------------------------------------------------------------------------------------------
net stop winmgmt
net start winmgmt

Get-WmiObject Win32_PnPEntity | Where-Object {$_.Description -like "*USB*"} | Select Description, DeviceID

Get-CimInstance -ClassName Win32_PnPEntity | Where-Object {$_.Description -like "*USB*"}





사용할 수 있는 인스턴스가 없습니다.
Get-PnpDevice | Where-Object {$_.FriendlyName -like "*USB*"} | Select FriendlyName, Status
Get-WmiObject Win32_PnPEntity | Where-Object {$_.Name -like "*USB*"}

Get-PnpDevice -Class USB | Disable-PnpDevice -Confirm:$false
Start-Sleep -Seconds 2
Get-PnpDevice -Class USB | Enable-PnpDevice -Confirm:$false

@echo off
powershell -Command "Get-PnpDevice -FriendlyName '*USB*' | Disable-PnpDevice -Confirm:$false"
powershell -Command "Start-Sleep -Seconds 2"
powershell -Command "Get-PnpDevice -FriendlyName '*USB*' | Enable-PnpDevice -Confirm:$false"
pause


@echo off
"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Command "..."

Get-PnpDevice -FriendlyName "*USB*" | Disable-PnpDevice -Confirm:$false
Start-Sleep -Seconds 2
Get-PnpDevice -FriendlyName "*USB*" | Enable-PnpDevice -Confirm:$false

@echo off
powershell -ExecutionPolicy Bypass -File "reset_usb.ps1"
pause








powershell -Command "@'


@REM 5. USB 장치 드라이버 재설치 (PowerShell 권장)
powershell -command 'Get-PnpDevice -FriendlyName "*USB*" | Disable-PnpDevice -Confirm:$false'
powershell -command 'Start-Sleep -Seconds 2'
powershell -command 'Get-PnpDevice -FriendlyName "*USB*" | Enable-PnpDevice -Confirm:$false'


try {
  Get-PnpDevice -FriendlyName "*USB*" | Disable-PnpDevice -Confirm:$false
  Start-Sleep -Seconds 2
  Get-PnpDevice -FriendlyName "*USB*" | Enable-PnpDevice -Confirm:$false
} catch {
  Write-Host "USB 장치 재설치 중 오류 발생: $_"
}




@REM usb 장치 전력 허브 초기화 명령어
1. Windows Driver Kit (WDK) 설치
devcon find *USB*
devcon restart *USB*


@REM 2. USB 장치 비활성화 후 재활성화
pnputil /disable-device "USB\VID_XXXX&PID_YYYY"
pnputil /enable-device "USB\VID_XXXX&PID_YYYY"

@REM 3. 전원 관리 설정 해제 (Powercfg)
powercfg -devicequery wake_armed
powercfg -devicedisablewake "장치 이름"

@REM 4. USB 장치 목록 확인
wmic path CIM_LogicalDevice where "Description like 'USB%'" get /value
AcceleratorCapabilities=0x7
예: 0x1 → DirectDraw 지원
0x2 → Direct3D 지원
0x4 → AGP Texture Acceleration 지원
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers


@REM 5. USB 장치 드라이버 재설치 (PowerShell 권장)
Get-PnpDevice -FriendlyName "*USB*" | Disable-PnpDevice -Confirm:$false
Start-Sleep -Seconds 2
Get-PnpDevice -FriendlyName "*USB*" | Enable-PnpDevice -Confirm:$false

@REM 6. USB 포트 재스캔 - 장치 관리자에 숨겨진 장치를 표시하도록 설정하는 환경 변수
set devmgr_show_nonpresent_devices=1
start devmgmt.msc

@REM USB Selective Suspend 기능을 끄면 절전 중 전력 차단 문제를 줄일 수 있습니다:
powercfg -h off


Get-WmiObject Win32_VideoController | Where-Object {$_.Name -like "*USB*"} | Select Name, Availability, Status

Get-PnpDevice -FriendlyName "USB Mobile Monitor*" | Enable-PnpDevice -Confirm:$false








`Availability=`는 Windows 시스템이나 장치 로그, 특히 WMI (Windows Management Instrumentation) 또는 장치 속성에서 자주 등장하는 **속성 필드**입니다. 이 값은 **장치나 리소스의 현재 상태를 숫자로 표현**하며, 시스템이 해당 장치를 얼마나 "사용 가능"한 상태로 인식하는지를 나타냅니다.

---

### ?? `Availability` 코드 값 의미

다음은 Microsoft WMI 문서에서 정의한 `Availability` 값의 대표적인 코드와 의미입니다:

| 코드 | 의미                          |
|------|-------------------------------|
| 1    | Other                         |
| 2    | Unknown                       |
| 3    | Running or Full Power         |
| 4    | Warning                       |
| 5    | In Test                       |
| 6    | Not Applicable                |
| 7    | Power Off                     |
| 8    | Off Line                      |
| 9    | Off Duty                      |
| 10   | Degraded                      |
| 11   | Not Installed                 |
| 12   | Install Error                 |
| 13   | Power Save - Unknown          |
| 14   | Power Save - Low Power Mode   |
| 15   | Power Save - Standby          |
| 16   | Power Cycle                   |
| 17   | Power Save - Warning          |
| 18   | Paused                        |
| 19   | Not Ready                     |
| 20   | Not Configured                |
| 21   | Quiesced                      |

---

### ?? 사용 예시

- WMI 쿼리에서 장치 상태 확인:
  ```powershell
  Get-WmiObject Win32_LogicalDisk | Select-Object DeviceID, Availability
  ```

- 로그 파일이나 드라이버 설정에서:
  ```
  Availability=3
  ```
  → 해당 장치가 "Running or Full Power" 상태임을 의미

---

이 값은 시스템 관리, 디버깅, 또는 장치 상태 모니터링 시 유용하게 쓰입니다. 혹시 이 값을 어디에서 보셨는지 알려주시면 더 구체적으로 분석해드릴 수 있어요!






`AcceleratorCapabilities=`는 일반적으로 **Windows 장치 드라이버나 시스템 로그, 특히 그래픽 카드나 하드웨어 가속 관련 설정**에서 등장하는 속성입니다. 이 항목은 **DirectX, GPU, 또는 하드웨어 가속 기능이 어떤 방식으로 활성화되어 있는지**를 나타냅니다.

---

### ?? 의미 및 사용 예시

#### ?? `AcceleratorCapabilities`란?
- **하드웨어 가속 기능의 상태나 지원 여부를 나타내는 속성**
- 주로 **`dxdiag`** (DirectX 진단 도구) 또는 **장치 드라이버 로그**에서 확인됨
- 예를 들어, 그래픽 카드가 DirectDraw, Direct3D, AGP Texture Acceleration 등을 지원하는지 여부를 표시

#### ?? 예시 출력
```text
AcceleratorCapabilities=0x7
```

- 이 값은 **비트 플래그**로 구성되어 있으며, 각 비트는 특정 기능을 의미합니다.
  - 예: `0x1` → DirectDraw 지원
  - `0x2` → Direct3D 지원
  - `0x4` → AGP Texture Acceleration 지원

---

### ?? 확인 방법

#### 1. **dxdiag 실행**
```cmd
dxdiag
```
- DirectX 진단 도구가 실행되며, 그래픽 탭에서 Accelerator 관련 정보 확인 가능

#### 2. **레지스트리 또는 로그 파일에서 확인**
- 일부 드라이버는 `AcceleratorCapabilities` 값을 로그에 기록하거나 레지스트리에 저장함
- 경로 예시:
  ```
  HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers
  ```

---

### ??? 활용 예
- 그래픽 성능 문제 진단
- 게임이나 3D 프로그램 실행 오류 분석
- 하드웨어 가속이 꺼져 있을 경우 원인 파악

---

혹시 이 값을 어디에서 보셨는지 알려주시면 더 구체적으로 분석해드릴 수 있어요. 예를 들어 `setupapi.dev.log` 파일, 드라이버 설치 로그, 또는 특정 프로그램의 설정 파일 등에서 나올 수 있습니다.







이 정보는 Windows 시스템에서 WMI(Windows Management Instrumentation)를 통해 추출된 **가상 디스플레이 장치의 속성 목록**입니다. 특히 `USB Mobile Monitor Virtual Display`라는 이름의 **USB 기반 가상 모니터 드라이버**에 대한 상세 정보로 보입니다. 아래에 주요 항목들을 해석해드릴게요:

---

### ?? 주요 속성 해석

| 항목 | 설명 |
|------|------|
| **AdapterCompatibility=Amyuni** | 드라이버 제조사 또는 호환성 정보. Amyuni는 PDF/디스플레이 관련 드라이버를 개발하는 회사입니다. |
| **Availability=8** | 장치 상태 코드. `8`은 **Off Line** 상태를 의미하며, 현재 시스템에서 사용 불가능한 상태입니다. |
| **Caption / Name / Description** | 모두 `USB Mobile Monitor Virtual Display`로, 장치 이름 및 설명입니다. |
| **ConfigManagerErrorCode=0** | 장치 관리자 오류 코드. `0`은 **오류 없음**을 의미합니다. |
| **DriverVersion=2.0.0.1** | 설치된 드라이버 버전 |
| **DriverDate=20210831...** | 드라이버가 설치된 날짜 (2021년 8월 31일) |
| **PNPDeviceID=ROOT\DISPLAY\0000** | Plug and Play 장치 ID. 루트 디스플레이로 등록된 가상 장치입니다. |
| **VideoArchitecture=5** | VGA 호환 아키텍처 |
| **VideoMemoryType=2** | VRAM 유형. `2`는 **VRAM**을 의미합니다. |

---

### ?? 상태 분석

- `Availability=8` → **Off Line** 상태이므로 현재 디스플레이로 사용되지 않고 있습니다.
- `Status=OK` → 장치 자체는 오류 없이 설치되어 있음
- `CurrentResolution`, `CurrentRefreshRate` 등은 모두 비어 있음 → 실제로 화면 출력이 이루어지지 않는 상태

---

### ??? 해결 또는 활용 방법

1. **장치 관리자에서 활성화 여부 확인**
   - `장치 관리자 → 디스플레이 어댑터`에서 해당 장치가 비활성화되어 있을 수 있음

2. **USB 모니터 연결 상태 확인**
   - USB 기반 디스플레이 장치는 실제 하드웨어 연결이 없으면 Off Line 상태로 유지됩니다

3. **드라이버 재설치 또는 업데이트**
   - `Amyuni` 드라이버를 최신 버전으로 설치하거나 제거 후 재설치

4. **WMI 스크립트로 상태 확인**
   ```powershell
   Get-WmiObject Win32_VideoController | Where-Object {$_.Name -like "*USB*"} | Select Name, Availability, Status
   ```

---

이 장치는 **가상 디스플레이 드라이버**로 보이며, 실제 모니터가 연결되지 않으면 Off Line 상태로 유지됩니다. 혹시 이 장치를 활성화하거나 제거하고 싶으신가요? 원하시는 작업에 맞춰 도와드릴게요.





Availability=
Caption=USB 오디오 장치
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_SoundDevice
Description=USB 오디오 장치
DeviceID=USB\VID_1B3F&amp;PID_2008&amp;MI_00\7&amp;5B41B26&amp;0&amp;0000
DMABufferSize=
ErrorCleared=
ErrorDescription=
InstallDate=
LastErrorCode=
Manufacturer=(일반 USB 오디오)
MPU401Address=
Name=USB 오디오 장치
PNPDeviceID=USB\VID_1B3F&amp;PID_2008&amp;MI_00\7&amp;5B41B26&amp;0&amp;0000
PowerManagementCapabilities=
PowerManagementSupported=FALSE
ProductName=USB 오디오 장치
Status=OK
StatusInfo=3
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN


Availability=
Caption=USB Mobile Monitor Virtual Display
ClassGuid={4d36e968-e325-11ce-bfc1-08002be10318}
CompatibleID=
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_PnPEntity
Description=USB Mobile Monitor Virtual Display
DeviceID=ROOT\DISPLAY\0000
ErrorCleared=
ErrorDescription=
HardwareID={"usbmmidd"}
InstallDate=
LastErrorCode=
Manufacturer=Amyuni
Name=USB Mobile Monitor Virtual Display
PNPClass=Display
PNPDeviceID=ROOT\DISPLAY\0000
PowerManagementCapabilities=
PowerManagementSupported=
Present=TRUE
Service=WUDFRd
Status=OK
StatusInfo=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN


Availability=
Caption=USB Composite Device
ClassGuid={36fc9e60-c465-11cf-8056-444553540000}
CompatibleID={"USB\DevClass_00&amp;SubClass_00&amp;Prot_00","USB\DevClass_00&amp;SubClass_00","USB\DevClass_00","USB\COMPOSITE"}
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_PnPEntity
Description=USB Composite Device
DeviceID=USB\VID_C0F4&amp;PID_0FF5\6&amp;382189AC&amp;0&amp;3
ErrorCleared=
ErrorDescription=
HardwareID={"USB\VID_C0F4&amp;PID_0FF5&amp;REV_0110","USB\VID_C0F4&amp;PID_0FF5"}
InstallDate=
LastErrorCode=
Manufacturer=(표준 USB 호스트 컨트롤러)
Name=USB Composite Device
PNPClass=USB
PNPDeviceID=USB\VID_C0F4&amp;PID_0FF5\6&amp;382189AC&amp;0&amp;3
PowerManagementCapabilities=
PowerManagementSupported=
Present=TRUE
Service=usbccgp
Status=OK
StatusInfo=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN


Availability=
Caption=USB 입력 장치
ClassGuid={745a17a0-74d3-11d0-b6fe-00a0c90f57da}
CompatibleID={"USB\Class_03&amp;SubClass_00&amp;Prot_00","USB\Class_03&amp;SubClass_00","USB\Class_03"}
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_PnPEntity
Description=USB 입력 장치
DeviceID=USB\VID_1B3F&amp;PID_2008&amp;MI_03\7&amp;5B41B26&amp;0&amp;0003
ErrorCleared=
ErrorDescription=
HardwareID={"USB\VID_1B3F&amp;PID_2008&amp;REV_0100&amp;MI_03","USB\VID_1B3F&amp;PID_2008&amp;MI_03"}
InstallDate=
LastErrorCode=
Manufacturer=(표준 시스템 장치)
Name=USB 입력 장치
PNPClass=HIDClass
PNPDeviceID=USB\VID_1B3F&amp;PID_2008&amp;MI_03\7&amp;5B41B26&amp;0&amp;0003
PowerManagementCapabilities=
PowerManagementSupported=
Present=TRUE
Service=HidUsb
Status=OK
StatusInfo=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN


Availability=
Caption=USB Audio Device
ClassGuid={4d36e96c-e325-11ce-bfc1-08002be10318}
CompatibleID={"USB\Class_01&amp;SubClass_01&amp;Prot_00","USB\Class_01&amp;SubClass_01","USB\Class_01"}
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_PnPEntity
Description=USB 오디오 장치
DeviceID=USB\VID_1B3F&amp;PID_2008&amp;MI_00\7&amp;5B41B26&amp;0&amp;0000
ErrorCleared=
ErrorDescription=
HardwareID={"USB\VID_1B3F&amp;PID_2008&amp;REV_0100&amp;MI_00","USB\VID_1B3F&amp;PID_2008&amp;MI_00"}
InstallDate=
LastErrorCode=
Manufacturer=(일반 USB 오디오)
Name=USB Audio Device
PNPClass=MEDIA
PNPDeviceID=USB\VID_1B3F&amp;PID_2008&amp;MI_00\7&amp;5B41B26&amp;0&amp;0000
PowerManagementCapabilities=
PowerManagementSupported=
Present=TRUE
Service=usbaudio
Status=OK
StatusInfo=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN


Availability=
Caption=USB Composite Device
ClassGuid={36fc9e60-c465-11cf-8056-444553540000}
CompatibleID={"USB\DevClass_00&amp;SubClass_00&amp;Prot_00","USB\DevClass_00&amp;SubClass_00","USB\DevClass_00","USB\COMPOSITE"}
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_PnPEntity
Description=USB Composite Device
DeviceID=USB\VID_1B3F&amp;PID_2008\6&amp;382189AC&amp;0&amp;1
ErrorCleared=
ErrorDescription=
HardwareID={"USB\VID_1B3F&amp;PID_2008&amp;REV_0100","USB\VID_1B3F&amp;PID_2008"}
InstallDate=
LastErrorCode=
Manufacturer=(표준 USB 호스트 컨트롤러)
Name=USB Composite Device
PNPClass=USB
PNPDeviceID=USB\VID_1B3F&amp;PID_2008\6&amp;382189AC&amp;0&amp;1
PowerManagementCapabilities=
PowerManagementSupported=
Present=TRUE
Service=usbccgp
Status=OK
StatusInfo=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN


Availability=
Caption=USB Root Hub
ClassGuid={36fc9e60-c465-11cf-8056-444553540000}
CompatibleID=
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_PnPEntity
Description=USB Root Hub
DeviceID=USB\ROOT_HUB20\4&amp;1E010BAF&amp;0
ErrorCleared=
ErrorDescription=
HardwareID={"USB\ROOT_HUB20&amp;VID8086&amp;PID27CC&amp;REV0001","USB\ROOT_HUB20&amp;VID8086&amp;PID27CC","USB\ROOT_HUB20"}
InstallDate=
LastErrorCode=
Manufacturer=(표준 USB 호스트 컨트롤러)
Name=USB Root Hub
PNPClass=USB
PNPDeviceID=USB\ROOT_HUB20\4&amp;1E010BAF&amp;0
PowerManagementCapabilities=
PowerManagementSupported=
Present=TRUE
Service=usbhub
Status=OK
StatusInfo=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN


Availability=
Caption=USB 입력 장치
ClassGuid={745a17a0-74d3-11d0-b6fe-00a0c90f57da}
CompatibleID={"USB\Class_03&amp;SubClass_01&amp;Prot_01","USB\Class_03&amp;SubClass_01","USB\Class_03"}
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_PnPEntity
Description=USB 입력 장치
DeviceID=USB\VID_C0F4&amp;PID_0FF5&amp;MI_00\7&amp;372AAF76&amp;0&amp;0000
ErrorCleared=
ErrorDescription=
HardwareID={"USB\VID_C0F4&amp;PID_0FF5&amp;REV_0110&amp;MI_00","USB\VID_C0F4&amp;PID_0FF5&amp;MI_00"}
InstallDate=
LastErrorCode=
Manufacturer=(표준 시스템 장치)
Name=USB 입력 장치
PNPClass=HIDClass
PNPDeviceID=USB\VID_C0F4&amp;PID_0FF5&amp;MI_00\7&amp;372AAF76&amp;0&amp;0000
PowerManagementCapabilities=
PowerManagementSupported=
Present=TRUE
Service=HidUsb
Status=OK
StatusInfo=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN


Availability=
Caption=USB 입력 장치
ClassGuid={745a17a0-74d3-11d0-b6fe-00a0c90f57da}
CompatibleID={"USB\Class_03&amp;SubClass_01&amp;Prot_02","USB\Class_03&amp;SubClass_01","USB\Class_03"}
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_PnPEntity
Description=USB 입력 장치
DeviceID=USB\VID_1BCF&amp;PID_0007\6&amp;382189AC&amp;0&amp;2
ErrorCleared=
ErrorDescription=
HardwareID={"USB\VID_1BCF&amp;PID_0007&amp;REV_0014","USB\VID_1BCF&amp;PID_0007"}
InstallDate=
LastErrorCode=
Manufacturer=(표준 시스템 장치)
Name=USB 입력 장치
PNPClass=HIDClass
PNPDeviceID=USB\VID_1BCF&amp;PID_0007\6&amp;382189AC&amp;0&amp;2
PowerManagementCapabilities=
PowerManagementSupported=
Present=TRUE
Service=HidUsb
Status=OK
StatusInfo=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN


Availability=
Caption=USB 입력 장치
ClassGuid={745a17a0-74d3-11d0-b6fe-00a0c90f57da}
CompatibleID={"USB\Class_03&amp;SubClass_00&amp;Prot_00","USB\Class_03&amp;SubClass_00","USB\Class_03"}
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_PnPEntity
Description=USB 입력 장치
DeviceID=USB\VID_C0F4&amp;PID_0FF5&amp;MI_01\7&amp;372AAF76&amp;0&amp;0001
ErrorCleared=
ErrorDescription=
HardwareID={"USB\VID_C0F4&amp;PID_0FF5&amp;REV_0110&amp;MI_01","USB\VID_C0F4&amp;PID_0FF5&amp;MI_01"}
InstallDate=
LastErrorCode=
Manufacturer=(표준 시스템 장치)
Name=USB 입력 장치
PNPClass=HIDClass
PNPDeviceID=USB\VID_C0F4&amp;PID_0FF5&amp;MI_01\7&amp;372AAF76&amp;0&amp;0001
PowerManagementCapabilities=
PowerManagementSupported=
Present=TRUE
Service=HidUsb
Status=OK
StatusInfo=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN


Availability=
Caption=알 수 없는 키보드
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_Keyboard
Description=USB 입력 장치
DeviceID=USB\VID_C0F4&amp;PID_0FF5&amp;MI_00\7&amp;372AAF76&amp;0&amp;0000
ErrorCleared=
ErrorDescription=
InstallDate=
IsLocked=
LastErrorCode=
Layout=00000412
Name=알 수 없는 키보드
NumberOfFunctionKeys=12
Password=
PNPDeviceID=USB\VID_C0F4&amp;PID_0FF5&amp;MI_00\7&amp;372AAF76&amp;0&amp;0000
PowerManagementCapabilities=
PowerManagementSupported=FALSE
Status=OK
StatusInfo=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN


Availability=
Caption=USB Composite Device
ClassCode=
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_USBHub
CurrentAlternateSettings=
CurrentConfigValue=
Description=USB Composite Device
DeviceID=USB\VID_C0F4&amp;PID_0FF5\6&amp;382189AC&amp;0&amp;3
ErrorCleared=
ErrorDescription=
GangSwitched=
InstallDate=
LastErrorCode=
Name=USB Composite Device
NumberOfConfigs=
NumberOfPorts=
PNPDeviceID=USB\VID_C0F4&amp;PID_0FF5\6&amp;382189AC&amp;0&amp;3
PowerManagementCapabilities=
PowerManagementSupported=
ProtocolCode=
Status=OK
StatusInfo=
SubclassCode=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN
USBVersion=


Availability=
Caption=USB Composite Device
ClassCode=
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_USBHub
CurrentAlternateSettings=
CurrentConfigValue=
Description=USB Composite Device
DeviceID=USB\VID_1B3F&amp;PID_2008\6&amp;382189AC&amp;0&amp;1
ErrorCleared=
ErrorDescription=
GangSwitched=
InstallDate=
LastErrorCode=
Name=USB Composite Device
NumberOfConfigs=
NumberOfPorts=
PNPDeviceID=USB\VID_1B3F&amp;PID_2008\6&amp;382189AC&amp;0&amp;1
PowerManagementCapabilities=
PowerManagementSupported=
ProtocolCode=
Status=OK
StatusInfo=
SubclassCode=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN
USBVersion=


Availability=
Caption=USB Root Hub
ClassCode=
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_USBHub
CurrentAlternateSettings=
CurrentConfigValue=
Description=USB Root Hub
DeviceID=USB\ROOT_HUB20\4&amp;1E010BAF&amp;0
ErrorCleared=
ErrorDescription=
GangSwitched=
InstallDate=
LastErrorCode=
Name=USB Root Hub
NumberOfConfigs=
NumberOfPorts=
PNPDeviceID=USB\ROOT_HUB20\4&amp;1E010BAF&amp;0
PowerManagementCapabilities=
PowerManagementSupported=
ProtocolCode=
Status=OK
StatusInfo=
SubclassCode=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN
USBVersion=


AcceleratorCapabilities=
AdapterCompatibility=Amyuni
AdapterDACType=
AdapterRAM=
Availability=8
CapabilityDescriptions=
Caption=USB Mobile Monitor Virtual Display
ColorTableEntries=
ConfigManagerErrorCode=0
ConfigManagerUserConfig=FALSE
CreationClassName=Win32_VideoController
CurrentBitsPerPixel=
CurrentHorizontalResolution=
CurrentNumberOfColors=
CurrentNumberOfColumns=
CurrentNumberOfRows=
CurrentRefreshRate=
CurrentScanMode=
CurrentVerticalResolution=
Description=USB Mobile Monitor Virtual Display
DeviceID=VideoController1
DeviceSpecificPens=
DitherType=
DriverDate=20210831000000.000000-000
DriverVersion=2.0.0.1
ErrorCleared=
ErrorDescription=
ICMIntent=
ICMMethod=
InfFilename=oem26.inf
InfSection=MyDevice_Install.NT
InstallDate=
InstalledDisplayDrivers=
LastErrorCode=
MaxMemorySupported=
MaxNumberControlled=
MaxRefreshRate=
MinRefreshRate=
Monochrome=FALSE
Name=USB Mobile Monitor Virtual Display
NumberOfColorPlanes=
NumberOfVideoPages=
PNPDeviceID=ROOT\DISPLAY\0000
PowerManagementCapabilities=
PowerManagementSupported=
ProtocolSupported=
ReservedSystemPaletteEntries=
SpecificationVersion=
Status=OK
StatusInfo=
SystemCreationClassName=Win32_ComputerSystem
SystemName=DESKTOP-K0VG2GN
SystemPaletteEntries=
TimeOfLastReset=
VideoArchitecture=5
VideoMemoryType=2
VideoMode=
VideoModeDescription=
VideoProcessor=


'@ | Out-Null"



