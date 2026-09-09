Set objWMI = GetObject("winmgmts:\\.\root\cimv2")
Set colItems = objWMI.ExecQuery("SELECT * FROM Win32_Processor")

For Each objItem In colItems
    WScript.Echo "CPU 사용률: " & objItem.LoadPercentage & "%"
Next

Set shell = CreateObject("WScript.Shell")
' shell.Run "powershell.exe -Command Get-Counter '\PhysicalDisk(_Total)\% Disk Time'", 1, True
' shell.Run "powershell.exe -Command Get-Counter '\PhysicalDisk(0 C:)\% Disk Time'", 1, True

shell.Run "powershell.exe -Command Get-Counter '\PhysicalDisk(_Total)\% Disk Time'; Pause", 1, True
' shell.Run "powershell.exe -Command Get-Counter '\PhysicalDisk(_Total)\% Disk Time' | Out-File C:\disk_usage.txt", 1, True
'  shell.Run "powershell.exe -NoExit -Command Get-Counter '\PhysicalDisk(_Total)\% Disk Time'", 1, True


shell.Run "cmd.exe /k powershell.exe -Command ""Get-WmiObject Win32_VideoController | Select-Object Name, AdapterRAM"" & pause", 1, True

shell.Run "cmd.exe /k powershell.exe -Command ""nvidia-smi --query-gpu=utilization.gpu --format=csv"" & pause", 1, True

shell.Run "powershell.exe -Command ""Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"'; Pause"", 1, True

shell.Run "cmd.exe /k powershell.exe -File .\gpu_util.ps1 & pause", 1, True

shell.Run "cmd.exe /k powershell.exe -Command ""Get-Counter -ListSet * | Where-Object { $_.CounterSetName -like '*GPU*' }"" & pause", 1, True


WScript.Quit







' Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
' Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

' | 정책 이름       | 설명 |
' | Restricted     | 기본값. 스크립트 실행 불가 |
' | RemoteSigned   | 로컬 스크립트는 실행 가능. 인터넷에서 받은 건 서명 필요 |
' | Unrestricted   | 모든 스크립트 실행 가능. 보안 위험 있음 |



shell.Run "powershell.exe -Command ""Get-WmiObject Win32_VideoController | Select-Object Name, AdapterRAM"'; Pause"", 1, True

shell.Run "cmd.exe /k powershell.exe -Command ""nvidia-smi --query-gpu=utilization.gpu --format=csv"" & pause", 1, True

shell.Run "'.\gpu_util.ps1 -FormatTable'; Pause", 1, True

shell.Run "powershell.exe -Command Get-Counter '-ListSet * | Where-Object { $_.CounterSetName -like "*GPU*" }; Pause'", 1, True



WScript.Sleep 3000 ' 3초 동안 일시 정지
WScript.Echo "잠시 후 입력을 받습니다..."
WScript.Sleep 2000
userInput = InputBox("이름을 입력하세요:")




Set objWMI = GetObject("winmgmts:\\.\root\cimv2")
Set colDisks = objWMI.ExecQuery("SELECT * FROM Win32_LogicalDisk WHERE DriveType = 3")

For Each disk In colDisks
    total = disk.Size / 1024 / 1024 / 1024
    free = disk.FreeSpace / 1024 / 1024 / 1024
    used = total - free
    percentUsed = (used / total) * 100

    WScript.Echo "드라이브 " & disk.DeviceID
    WScript.Echo "전체 용량: " & Round(total, 2) & " GB"
    WScript.Echo "사용 중: " & Round(used, 2) & " GB (" & Round(percentUsed, 1) & "%)"
    WScript.Echo "남은 공간: " & Round(free, 2) & " GB"
    WScript.Echo "-----------------------------"
Next



