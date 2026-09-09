
@echo off
@REM taskschd.msc


schtasks /Change /TN "\Microsoft\Windows\Sysmain\HybridDriveCachePrepopulate" /ENABLE
schtasks /Change /TN "\Microsoft\Windows\Sysmain\HybridDriveCacheRebalance" /ENABLE
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319" /ENABLE
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64" /ENABLE

schtasks /Run /TN "\Microsoft\Windows\Sysmain\HybridDriveCachePrepopulate"
schtasks /Run /TN "\Microsoft\Windows\Sysmain\HybridDriveCacheRebalance"
schtasks /Run /TN "\Microsoft\Windows\WindowsColorSystem\Calibration Loader"
schtasks /Run /TN "\Microsoft\Windows\Storage Tiers Management\Storage Tiers Optimization"


schtasks /Run /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319"
schtasks /Run /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64"


schtasks /Change /TN "\Microsoft\Windows\Sysmain\HybridDriveCachePrepopulate" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Sysmain\HybridDriveCacheRebalance" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64" /DISABLE


pause
exit



@REM -------------------------------------------
@REM ENABLE    활성화 상태    - 예약실행 가능
@REM DISABLE   비활성화 상태  - 예약실행 안됨
@REM Run        항상 바로 실행 - DISABLE 해도 Run 유지
@REM -------------------------------------------

schtasks /Change /TN "\Microsoft\Windows\Sysmain\HybridDriveCachePrepopulate" /ENABLE
schtasks /Change /TN "\Microsoft\Windows\Sysmain\HybridDriveCacheRebalance" /ENABLE
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319" /ENABLE
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64" /ENABLE

schtasks /Change /TN "\Microsoft\Windows\WindowsColorSystem\Calibration Loader" /ENABLE
schtasks /Change /TN "\Microsoft\Windows\Storage Tiers Management\Storage Tiers Optimization" /ENABLE

schtasks /Change /TN "\Microsoft\Windows\Sysmain\HybridDriveCachePrepopulate" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\Sysmain\HybridDriveCacheRebalance" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64" /DISABLE


schtasks /Run /TN "\Microsoft\Windows\Defrag\ScheduledDefrag"
schtasks /Run /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup"
schtasks /Run /TN "\Microsoft\Windows\Maintenance\WinSAT"
schtasks /Run /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
schtasks /Run /TN "\Microsoft\Windows\SystemRestore\SR"

