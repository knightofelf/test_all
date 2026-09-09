


REM --------------------------------------------
REM ENTER 를 누르면. 부트 최적화
REM --------------------------------------------
PAUSE

defrag.exe /C /B /U /V



REM --------------------------------------------
REM ENTER 를 누르면. 체크 디스크
REM --------------------------------------------
PAUSE

dfrgui.exe &

chkdsk /f /r
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth

defrag.exe C: /B





REM --------------------------------------------
REM ENTER 를 누르면. 상세 디스크 조각모음
REM --------------------------------------------
PAUSE


Defrag /U /V
Defrag /TierOptimize /MultiThread
Defrag C:\mountpoint /Analyze /U
Defrag /C /H /V

REM --------------------------------------------
REM ENTER 를 누르면. 상세 디스크 조각모음
REM --------------------------------------------
PAUSE

defrag.exe /C /D /U /V
defrag.exe /C /O /U /V
defrag.exe /C /L /U /V
defrag.exe /C /X /U /V
defrag.exe /C /G /I 8 /M 8 /U /V

defrag.exe /B

PAUSE
EXIT



@REM Start-Process "dfrgui.exe" -Verb RunAs
@REM Start-Process 'dfrgui.exe' -Verb RunAs
@REM powershell -Command "Start-Process -Name 'dfrgui' -Force -ErrorAction SilentlyContinue;"



@echo off
@REM # 프로세스 종료

taskkill /im "conhost.exe" /f /t
taskkill /im "cmd.exe" /f /t
taskkill /im "mshta.exe" /f /t
taskkill /im "WindowsTerminal.exe" /f /t

powershell -Command "Stop-Process -Name 'conhost','cmd','mshta','explorer' -Force -ErrorAction SilentlyContinue;"


@REM 
powershell -Command "Start-Process dfrgui.exe -Verb RunAs"


@REM # 
dfrgui.exe

cmd /c echo off | dfrgui.exe



PAUSE
EXIT




C:\Windows\SysWOW64\defrag.exe /C /B /U /V
C:\Windows\System32\defrag.exe /C /B /U /V
cmd /c defrag.exe /C /D /U /V
defrag.exe /C /O /U /V
defrag.exe /C /L /U /V
defrag.exe /C /X /U /V
defrag.exe /C /G /I 8 /M 8 /U /V


Start-Process 'defrag.exe /C /D /U /V' -Verb RunAs
Start-Process "defrag.exe" -ArgumentList "/C","/D","/U","/V" -Verb RunAs
Start-Process "defrag.exe" -ArgumentList "/C /D /U /V" -Verb RunAs
Start-Process "C:\Windows\System32\defrag.exe" -ArgumentList "/C /D /U /V" -Verb RunAs

cmd /c 
echo %PROCESSOR_ARCHITECTURE%

powershell -Command "Start-Process 'defrag.exe /C /D /U /V' -Verb RunAs"















REM
작업을 수행할 볼륨을 지정하십시오. (0x89000007)

Defrag <Volumes> <Operations> [<Options>]

볼륨:
  /C | /AllVolumes      각 볼륨의 지정된 작업 목록에서 기본 설정 작업만
                        실행합니다.
  /E | /VolumesExcept <볼륨 경로>
                        지정된 볼륨을 제외한 각 볼륨에 대해 지정된 작업을 모두
                        수행합니다. 예외 목록이 비어있는 경우 /AllVolumes로
                        작동 합니다.
  volume paths          드라이브 문자와 콜론, 탑재 지점 또는 볼륨 이름을
                        지정합니다. 둘 이상의 볼륨을 지정할 수 있습니다. 지정된 각 볼륨에 대해
                        지정된 작업을 모두 실행합니다.

작업:
  /A | /Analyze         분석을 수행합니다.
  /B | /BootOptimize    부팅 최적화를 수행하여 부팅 성능을 높입니다.
  /D | /Defrag          기존 조각 모음을 수행합니다(기본값). 계층화된
                        볼륨에서는 기존 조각 모음이 용량 계층에서만
                      수행됩니다.
  /G | /TierOptimize    계층화된 볼륨에서 적절한 저장소 계층에 상주하도록 파일을
                        최적화합니다.
  /K | /SlabConsolidate 씬 프로비전된 볼륨에서 조각 모음을 수행하여
                        조각 사용량 효율성을 높입니다.
  /L | /Retrim          씬 프로비전된 볼륨에서 다시 잘라내기를 수행하여 사용 가능한
                        조각을 해제합니다. SSD에서 다시 잘라내기를 수행하여 쓰기 성능을 개선합니다.
  /O | /Optimize        각 미디어 유형에 대해 적절한 최적화를 수행합니다.
  /T | /TrackProgress   지정한 볼륨에 대해 실행 중인 작업의 진행률을 추적합니다.
                        인스턴스는 단일 볼륨에 대해서만 진행률을 표시할 수 있습니다.
                        다른 볼륨의 진행률을 보려면 다른 인스턴스를 시작하세요.
  /U | /PrintProgress   화면에 작업 진행률을 출력합니다.
  /V | /Verbose         조각화 통계를 포함한 자세한 정보 표시를 출력합니다.
  /X | /FreespaceConsolidate
                        사용 가능한 공간 통합을 수행하고 사용 가능한 공간을
                        볼륨의 끝으로 이동합니다(씬 프로비전된 볼륨에서도).
                        계층화된 볼륨에서 통합은 용량 계층에서만.
                        수행됩니다.

옵션:
  /H | /NormalPriority  보통 우선 순위 작업을 실행합니다. 기본값은 낮은 우선 순위입니다.
  /I | /MaxRuntime n    TierOptimize에서만 사용할 수 있습니다. 계층 최적화가
                        각 볼륨에서 최대 n초 동안 실행됩니다.
       /LayoutFile <파일 경로>
                        BootOptimize에서만 사용할 수 있습니다. 이 파일에는 최적화될
                        파일의 목록이 포함되어 있습니다. 기본 위치는
                        %windir%\Prefetch\layout.ini입니다.
  /M | /MultiThread [n] 백그라운드에서 병렬로 각 볼륨에서 작업을 실행합니다.
                        TierOptimize의 경우 최대 n개의 스레드가 저장소 계층을 병렬로
                        최적화합니다. n의 기본값은 8입니다. 다른 모든 최적화는
                        n을 무시합니다.
       /OnlyPreferred   볼륨을 명시적으로 지정하면 조각 모음은 지정된 각
                        볼륨에 대해 지정된 작업을 모두 수행합니다.  이 스위치를
                        사용하면 기본 설정 작업만 지정된 각 작업 볼륨에 대해 지정된
                        작업 목록의 기본 설정 작업만 조각 모음을 실행할 수 있습니다.

예:
  Defrag C: /U /V
  Defrag C: D: /TierOptimize /MultiThread
  Defrag C:\mountpoint /Analyze /U
  Defrag /C /H /V



