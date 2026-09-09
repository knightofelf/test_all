


Get-Content "J:\heroes\Util\OpenHardwareMonitor\log.csv" | Select-String "GPU Core"






# GPU VRAM 사용량 모니터링 스크립트
# GT 730처럼 사용률이 N/A일 경우에도 VRAM 기준으로 상태 확인

$nvidiaInfo = & nvidia-smi --query-gpu=name,memory.used,memory.total,temperature.gpu --format=csv,noheader,nounits

$lines = $nvidiaInfo -split "`n"
foreach ($line in $lines) {
    $parts = $line -split ","
    $name = $parts[0].Trim()
    $memUsed = [int]$parts[1].Trim()
    $memTotal = [int]$parts[2].Trim()
    $temp = $parts[3].Trim()
    $memPercent = [math]::Round(($memUsed / $memTotal) * 100, 1)

    Write-Host "GPU 이름: $name"
    Write-Host "VRAM 사용량: $memUsed MB / $memTotal MB ($memPercent%)"
    Write-Host "GPU 온도: $temp°C"

    # 경고 조건: VRAM 사용률 80% 이상
    if ($memPercent -ge 80) {
        Write-Host "?? VRAM 사용률이 높습니다!" -ForegroundColor Red
    }

    Write-Host "-----------------------------"
}

Pause
Exit
Pause
Exit



<#
이건 여러 줄 주석입니다
스크립트 설명이나 사용법을 적을 때 유용합니다

lodctr /R
cd c:\windows\sysWOW64
lodctr /R
winmgmt.exe /RESYNCPERF

typeperf "\GPU Engine(*)\Utilization"
perfmon
성능 모니터 창에서 + 버튼을 클릭하여 새 카운터를 추가합니다.
카운터 추가 창에서 GPU Engine

바탕화면 우클릭 → NVIDIA 제어판 실행.
상단 메뉴의 바탕화면 → 개발자 설정 사용 체크.
상단 메뉴의 개발자 → GPU 성능 카운터 관리 → 모든 사용자에게 GPU 성능 카운터에 대한 액세스 허용 선택 후 적용. 


Get-Counter -Counter "\GPU Engine(*)\Utilization" -SampleInterval 2 -Continuous
Get-Counter -Counter "\GPU Engine(*)\Utilization" -SampleInterval 1 -MaxSamples 10

powershell "Get-Counter -Counter \"\GPU Engine(*)\Utilization\" | Format-List -Property CounterSamples"


nvidia-smi --query-gpu=name,memory.used,memory.total,temperature.gpu --format=csv,noheader,nounits
nvidia-smi --query-gpu=name,memory.used,memory.total,temperature.gpu --format=csv,noheader,nounits >> gpu_log.txt
for /l %g in () do @ (cls & nvidia-smi & timeout /t 1)
watch -n 1 nvidia-smi

pip install gpustat

import gpustat
gpu_stats = gpustat.GPUStatCollection.new_query()
for gpu in gpu_stats.gpus:
    print(f"GPU {gpu.index}: {gpu.name}, 활용률: {gpu.utilization}%")



watch -n 1 "nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits"

작업 관리좌와 Game Bar 스크립트 가능?


<script language="VBScript">
Sub Window_OnLoad
    Dim shell, result
    Set shell = CreateObject("WScript.Shell")
    result = shell.Exec("powershell.exe -Command ""nvidia-smi --query-gpu=name,memory.used,memory.total,temperature.gpu --format=csv,noheader,nounits""").StdOut.ReadAll
    document.getElementById("output").innerText = result
End Sub
</script>


# nvidia-smi의 출력을 텍스트로 저장
nvidia-smi > C:\temp\gpu_stats.txt

# 텍스트 파일에서 GPU 사용률 라인만 추출 (N/A인 경우 처리)
$gpu_util_line = Get-Content -Path C:\temp\gpu_stats.txt | Select-String -Pattern "GPU-Util"
$gpu_util = $gpu_util_line -split '\s+' | Where-Object {$_ -notlike 'N/A'} | Select-Object -Last 2 | Select-Object -First 1

# 결과 출력
if ($gpu_util) {
    Write-Output "GPU 사용률: $($gpu_util)%"
} else {
    Write-Output "GPU 사용률 정보를 찾을 수 없습니다."
}



#>

Write-Host "작업 완료!"
Pause
Exit





$p = Get-Process dwm
(Get-Counter "\\GPU Process Memory(pid_$($p.id)*)\\Local Usage").CounterSamples |
    ForEach { "GPU 메모리 사용량: {0} MB" -f [math]::Round($_.CookedValue / 1MB, 2) }

(Get-Counter "\\GPU Engine(pid_$($p.id)*engtype_3D)\\Utilization Percentage").CounterSamples |
    ForEach { "GPU 엔진 점유율: {0}%" -f [math]::Round($_.CookedValue, 2) }



# GPU 상태 확인 스크립트 (NVIDIA 전용)
$gpuInfo = & nvidia-smi --query-gpu=name,utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits

$lines = $gpuInfo -split "`n"
foreach ($line in $lines) {
    $parts = $line -split ","
    $name = $parts[0].Trim()
    $usage = $parts[1].Trim()
    $memUsed = $parts[2].Trim()
    $memTotal = $parts[3].Trim()
    $memPercent = [math]::Round(($memUsed / $memTotal) * 100, 1)

    Write-Host "GPU 이름: $name"
    Write-Host "GPU 사용률: $usage%"
    Write-Host "VRAM 사용량: $memUsed MB / $memTotal MB ($memPercent%)"
    Write-Host "-----------------------------"
}



