


@echo off

@REM 윈도우 시간 동기화


sc config w32time start= auto
sc start w32time


powershell -Command "Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\W32Time\\Parameters' -Name 'Type' -Value 'NoSync'; Restart-Service w32time"


powershell -Command "Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\W32Time\\Parameters' -Name 'Type' -Value 'NTP'; Restart-Service w32time"


where w32tm
w32tm /query /status
w32tm /query /source
w32tm /resync
w32tm /config /manualpeerlist:"time.windows.com" /syncfromflags:manual /reliable:YES /update
w32tm /resync


w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /update



pause
exit







@REM ---------------------------------

powershell -Command "@'

<!--


Sub runTIMEsync

' @REM 윈도우 시간 동기화
' w32tm /resync

  Dim shell
  Set shell = CreateObject("WScript.Shell")
'  shell.Run "w32tm /resync > d:\\ics\\test.txt", 1, False
'  shell.Run "cmd.exe /c w32tm /resync > d:\ics\test.txt", 0, True
'  shell.Run "cmd.exe /c w32tm /resync > d:\ics\test.txt", 1, False
  shell.Run "cmd.exe /c w32tm /resync", 0, True
  shell.Run "cmd.exe /c w32tm /resync", 1, False
'  shell.Run "cmd.exe /c w32tm /resync | pause", 0, True
'  shell.Run "cmd.exe /c w32tm /resync | pause", 1, False
'  shell.Run "powershell -Command ""Start-Process 'cmd.exe /c w32tm /resync' -Verb RunAs""", 1, True
  Set shell = Nothing

' C:\Windows\System32\w32tm.exe

' 다음 오류가 발생했습니다. 서비스가 시작되지 않았습니다. (0x80070426)
net start w32time
시스템 오류 1058이(가) 생겼습니다.
서비스를 사용할 수 없거나 서비스와 연관되어 사용 가능한 장치가 없기 때문에 서비스를 시작할 수 없습니다.

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time

sc config w32time start= auto
sc start w32time

where w32tm
w32tm /query /status
w32tm /query /source
w32tm /resync
w32tm /config /manualpeerlist:"time.windows.com" /syncfromflags:manual /reliable:YES /update
w32tm /resync

Set shell = CreateObject("Shell.Application")
'  shell.ShellExecute "w32tm", "/resync", "", "runas", 1
Set shell = Nothing


자동으로 시간 설정 끄고 켜기


' Set objShell = Nothing
' Set objFSO = Nothing

End Sub



//-->

'@ | Out-Null"

