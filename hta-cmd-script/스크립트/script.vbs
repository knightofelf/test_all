

Sub runTEST

Dim fso, file, code
Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.OpenTextFile("myScript.vbs", 1)
code = file.ReadAll
file.Close
ExecuteGlobal code

End Sub


    Sub ShowWindowPosition()
      Dim x, y
      x = window.screenLeft
      y = window.screenTop
pos_x = window.screenLeft
pos_y = window.screenTop
'      MsgBox "현재 HTA 창 좌표: X=" & x & ", Y=" & y
    End Sub


' Sub runNOTEPAD(filePath As String)
'    Dim notepadPath As String
'    notepadPath = "notepad.exe"
    
    ' Shell 함수를 사용하여 메모장 실행 + 파일 열기
'    Shell notepadPath & " " & Chr(34) & filePath & Chr(34), vbNormalFocus
' End Sub




Sub runNOTEPAD(filePath)
      Dim path
      Dim shell
      Set shell = CreateObject("WScript.Shell")


      shell.Run "c:\windows\notepad.exe " & Chr(34) & filePath & Chr(34), 1, False


      Set shell = Nothing
    End Sub




Sub TestRun()
'    Call runNOTEPAD("C:\Users\YourName\Documents\example.txt")
End Sub

Sub runNOTEPADxx()
'    Shell "notepad.exe", vbNormalFocus
End Sub

Sub runNOTEPADx
  Dim shell
  Set shell = CreateObject("WScript.Shell")
  shell.Run "notepad.exe"
  Set shell = Nothing

' Set objShell = Nothing
' Set objFSO = Nothing

End Sub


Sub runVBS (cmd)
  Dim shell
  Set shell = CreateObject("WScript.Shell")
  shell.Run cmd
  Set shell = Nothing

' Set objShell = Nothing
' Set objFSO = Nothing

End Sub





Sub runTIMEsync

' @REM 윈도우 시간 동기화
' w32tm /resync

  Dim shell
  Set shell = CreateObject("WScript.Shell")
'  shell.Run "w32tm.bat", 1, False
  shell.Run "w32tm.bat", 0, True
  Set shell = Nothing

' Set objShell = Nothing
' Set objFSO = Nothing

End Sub






Sub runProgram(filePath)
  Dim shell
  Set shell = CreateObject("WScript.Shell")      
filePath = "" &  filePath
urlPath = "file:///" & Replace(filePath, "\", "/")
' MsgBox urlPath
  shell.Run "msedge.exe --new-window " & Chr(34) & urlPath & Chr(34), 1, False
  Set shell = Nothing

End Sub






Sub runDefrag 


' Set shell = CreateObject("Shell.Application")
' shell.ShellExecute "dfrgui.exe", "", "", "open", 1
' Set shell = Nothing



' Set shell = CreateObject("Shell.Application")
' shell.ShellExecute  "defrag.exe", "/C /O /U /V", "", "runas", 1
' Set shell = Nothing



' Set objShell = CreateObject("WScript.Shell")
' objShell.Run "C:\Windows\System32\defrag.exe /C /O /U /V", 1, True


'  Dim shell
'  Set shell = CreateObject("WScript.Shell")
'  shell.Run "defrag.bat", 0, True
'  Set shell = Nothing




Set shell = CreateObject("Shell.Application")
shell.ShellExecute "defrag.bat", "", "", "runas", 1
Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing




' C:\Windows\System32\defrag.exe /C /O /U /V
' Optimize-Volume -DriveLetter C -Defrag -Verbose
' Get-Volume | ForEach-Object { Optimize-Volume -DriveLetter $_.DriveLetter -Defrag -Verbose }



'  Dim shell
'  Set shell = CreateObject("WScript.Shell")      
'  shell.Run "Defrag.exe /C /B /U /V", 1, False
'  Set shell = Nothing



' Set shell = CreateObject("Shell.Application")
' shell.ShellExecute "defrag.bat", "", "", "runas", 1
' Set shell = Nothing

' Set objShell = Nothing
' Set objFSO = Nothing


End Sub





Sub runSTART
'  Dim shell
'  Set shell = CreateObject("WScript.Shell")
'  shell.Run "powershell -Command ""Start-Process 'start.bat' -Verb RunAs""", 1, True

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "start.bat", "", "", "runas", 1
Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing

End Sub



Sub runDEEPCLEAN
'  Dim shell
'  Set shell = CreateObject("WScript.Shell")
'  shell.Run "powershell -Command ""Start-Process 'deepclean.bat' -Verb RunAs""", 1, True

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "deepclean.bat", "", "", "runas", 1
Set shell = Nothing

//  shell.Run "runas /user:test 'cmd /c deepclean.bat'"
//  shell.Run "runas /savecred /user:test 'cmd /c deepclean.bat'"
// shell.Run "runas /savecred /user:Administrator \"cmd /c C:\Scripts\deepclean.bat\""
//    Set shell = CreateObject("Shell.Application")
//    shell.ShellExecute "cmd.exe", "/c your_script.bat", "", "runas", 1

Set objShell = Nothing
Set objFSO = Nothing

End Sub




Sub runPS_ICS


Set shell = CreateObject("Shell.Application")
Set fso = CreateObject("Scripting.FileSystemObject")

' 현재 VBScript 경로 기준으로 PowerShell 스크립트 경로 설정
psScript = fso.GetAbsolutePathName(".") & "\ps_ics.ps1"

' 관리자 권한으로 PowerShell 실행
shell.ShellExecute "powershell", " -ExecutionPolicy Bypass -File """ & psScript & """", "", "runas", 1

Set shell = Nothing


Set objShell = Nothing
Set objFSO = Nothing

End Sub




Sub runICS

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "ics_enable.bat", "", "", "runas", 1
Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing

End Sub



Sub runICS_ON

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "ics_on.bat", "", "", "runas", 1
Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing

End Sub



Sub runICS_OFF

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "ics_off.bat", "", "", "runas", 1
Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing

End Sub



Sub runTASKKILL

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "taskkill.bat", "", "", "runas", 1
Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing

End Sub



Sub runSCRCPY
  Dim shell
  Set shell = CreateObject("WScript.Shell")
  shell.Run "scrcpy-noconsole"
  Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing

End Sub




Sub runDEV

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "USB 장치 목록 확인.bat", "", "", "runas", 1
Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing

End Sub



Sub runHIBER

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "hiber.bat", "", "", "runas", 1
Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing

End Sub




Sub runSCHTASKS

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "schtasks.bat", "", "", "runas", 1
Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing

End Sub




Sub runHIBER_A

Set objShell = CreateObject("WScript.Shell")
Set objExec = objShell.Exec("powercfg.exe /a")

Do While Not objExec.StdOut.AtEndOfStream
    strLine = objExec.StdOut.ReadLine()
'    WScript.Echo strLine
Loop


Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing

End Sub







'  Set shell = CreateObject("Shell.Application")
'  shell.ShellExecute "powercfg.exe", "/a", "", "", 1

'      Do Until shell.AtEndOfStream
'        line = shell.ReadLine
'        content = content & line & "<br>"
'      Loop
'      shell.Close



Sub btnClick
  MsgBox "버튼 클릭됨!"
End Sub





Sub Disk_Fix

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "disk fix.bat", "", "", "runas", 1
Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing

End Sub





Sub KillWScript
  Dim shell
'  Set shell = CreateObject("WScript.Shell")
'  shell.Run "cmd.exe /c taskkill /im wscript.exe /f /t", 0, True

' Set shell = CreateObject("Shell.Application")
' shell.ShellExecute "taskkill.bat", "", "", "runas", 1
' Set shell = Nothing



Set shell = CreateObject("WScript.Shell")
' shell.Run "taskkill /im cmd.exe /f /t", 0, True
' shell.Run "taskkill /im conhost.exe /f /t", 0, True


Dim cmd




' dllhost 종료
cmd = "powershell -ExecutionPolicy Bypass -Command ""Get-Process dllhost | Stop-Process -Force -ErrorAction SilentlyContinue"""
shell.Run cmd, 0, True

' RuntimeBroker 종료
cmd = "powershell -ExecutionPolicy Bypass -Command ""Get-Process RuntimeBroker | Stop-Process -Force -ErrorAction SilentlyContinue"""
shell.Run cmd, 0, True



cmd = "powershell -ExecutionPolicy Bypass -Command ""'wscript','cmd','conhost','dllhost','mshta' | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }"""
shell.Run cmd, 0, True

cmd = "powershell -Command ""Stop-Process -Name 'wscript','cmd','conhost','dllhost','mshta' -Force -ErrorAction SilentlyContinue"""
shell.Run cmd, 0, True

cmd = "powershell -Command ""-ExecutionPolicy Bypass Stop-Process -Name 'wscript','cmd','conhost','dllhost','mshta' -Force -Verb RunAs  -ErrorAction SilentlyContinue"""
shell.Run cmd, 0, True

cmd = "powershell -Command ""Stop-Process -Name 'wscript','cmd','conhost','dllhost','mshta' -Force -ErrorAction SilentlyContinue"""
shell.Run cmd, 0, True


Set shell = Nothing







' powershell -ExecutionPolicy Bypass -Command "Stop-Process -Name 'dllhost' -Force -ErrorAction SilentlyContinue"
' powershell -ExecutionPolicy Bypass -Command "Stop-Process -Name 'RuntimeBroker' -Force -ErrorAction SilentlyContinue"

' Get-Process dllhost | Stop-Process -Force -ErrorAction SilentlyContinue
' Get-Process RuntimeBroker | Stop-Process -Force -ErrorAction SilentlyContinue



' powershell -Command "Stop-Process -Name 'conhost','cmd','mshta','explorer' -Force -ErrorAction SilentlyContinue; Start-Process 'explorer.exe'"

'  shell.Run "powershell -Command ""Start-Process 'deepclean.bat' -Verb RunAs""", 1, True
'  shell.ShellExecute "powershell", " -ExecutionPolicy Bypass -File """ & psScript & """", "", "runas", 1

' shell.ShellExecute "파일 또는 명령어", "인수", "작업 디렉터리", "실행 방식", 창 모드

' shell.Run "powershell -Command ""Stop-Process -Name 'wscript','cmd','conhost','mshta'  -Verb RunAs -Force""", 1, True
' shell.ShellExecute "powershell.exe", "-Command \"Stop-Process -Name 'wscript','cmd','conhost','mshta' -Force\"", "", "runas", 1
' powershell -Command "Stop-Process -Name 'wscript','cmd','conhost','mshta' -Force"

'  shell.Run "cmd.exe /c taskkill /im cmd.exe /f /t", 0, True
'  shell.Run "cmd.exe /c taskkill /im conhost.exe /f /t", 0, True


' shell.ShellExecute "taskkill.exe", "/im wscript.exe /f /t", "", "runas", 1

' shell.ShellExecute "taskkill.exe", "/im cmd.exe /f /t", "", "runas", 1
' shell.ShellExecute "taskkill.exe", "/im conhost.exe /f /t", "", "runas", 1
' shell.ShellExecute "taskkill.exe", "/im mshta.exe /f /t", "", "runas", 1

' shell.Run "powershell -Command ""Start-Process 'start.bat' -Verb RunAs""", 1, True

' powershell -Command "Stop-Process -Name 'wscript','cmd','conhost','mshta' -Force"
' shell.ShellExecute "powershell.exe", "-Command \"Stop-Process -Name 'wscript','cmd','conhost','mshta' -Force\"", "", "runas", 1

' shell.ShellExecute "powershell", " -ExecutionPolicy Bypass -File """ & psScript & """", "", "runas", 1



End Sub






Sub popupClose

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "popupClose.exe", "", "", "runas", 1
Set shell = Nothing

End Sub



Sub runWMI

Set shell = CreateObject("WScript.Shell")
' shell.Run "cscript ActiveX CLSID.vbs", 0, False  ' False = 비동기 실행
shell.Run "cscript.exe //nologo ""./ActiveX CLSID.vbs""", 0, False
Set shell = Nothing

End Sub



Sub runWMIx

' ActiveX CLSID 목록 출력 스크립트
Dim reg, strKeyPath, arrSubKeys, subkey, name
Dim fso, file

Set reg = GetObject("winmgmts:\\.\root\default:StdRegProv")
Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.CreateTextFile("./CLSID_List.txt", True)

strKeyPath = "CLSID"
reg.EnumKey &H80000000, strKeyPath, arrSubKeys

If IsArray(arrSubKeys) Then
    For Each subkey In arrSubKeys
        reg.GetStringValue &H80000000, strKeyPath & "\" & subkey, "", name
        If Not IsNull(name) Then
            file.WriteLine subkey & " → " & name
        End If
    Next
    file.Close
    MsgBox "ActiveX CLSID 목록 출력 스크립트 - 완료."
Else
    WScript.Echo "CLSID 키를 찾을 수 없습니다."
End If

' WScript.Quit

End Sub





Sub fn_ReadFile()
  Dim fso, file, line, content
  Set fso = CreateObject("Scripting.FileSystemObject")
  
  If fso.FileExists("./CLSID_List.txt") Then
    Set file = fso.OpenTextFile("./CLSID_List.txt", 1)  ' 1 = 읽기
    content = ""
    Do Until file.AtEndOfStream
      line = file.ReadLine
      content = content & line & "<br>"
    Loop
    file.Close
    document.getElementById("div_output").innerHTML = content
  Else
    document.getElementById("div_output").innerHTML = "파일이 존재하지 않습니다."
  End If
End Sub





Sub readFileAsync_vb()
  Dim fso, file, totalSize, readSize, line, percent
  Set fso = CreateObject("Scripting.FileSystemObject")

  If fso.FileExists("C:\CLSID_List.txt") Then
    totalSize = fso.GetFile("C:\CLSID_List.txt").Size
    Set file = fso.OpenTextFile("C:\CLSID_List.txt", 1)

    readSize = 0
    Do Until file.AtEndOfStream
      line = file.ReadLine
      readSize = readSize + LenB(line & vbCrLf)  ' 줄 길이 + 줄바꿈
      percent = Round((readSize / totalSize) * 100, 1)
      document.getElementById("progressBar").style.width = percent & "%"
      document.getElementById("label").innerText = percent & "%"
      DoEvents  ' UI 갱신
    Loop
    file.Close
    document.getElementById("label").innerText = "완료!"
  Else
    document.getElementById("label").innerText = "파일이 존재하지 않습니다."
  End If
End Sub



Sub runWMIx
Set shell = CreateObject("WScript.Shell")
Set exec = shell.Exec("runas /user:test cmd /c dir & pause")
End Sub




Sub runNCPA

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "ncpa.cpl", "", "", "", 1
Set shell = Nothing

End Sub




Sub runPOWER

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "control", "powercfg.cpl", "", "", 1
Set shell = Nothing

End Sub


Sub runPOWER_LIST

Set shell = CreateObject("Shell.Application")
shell.ShellExecute "powercfg", "/list", "", "", 1
Set shell = Nothing

End Sub




Sub runPOWER_MAX

' Set shell = CreateObject("Shell.Application")
' shell.ShellExecute "control", "powercfg.cpl  /setactive SCHEME_MAX", "", "", 1
' Set shell = Nothing

      Dim shell
      Set shell = CreateObject("WScript.Shell")

Dim cmd
cmd = "powercfg.exe /setactive SCHEME_MAX"
shell.Run cmd, 0, True

'      var command = 'powercfg /setactive SCHEME_MAX';
'      shell.Run "powercfg /setactive SCHEME_MAX", 1, False


Set shell = Nothing

Set objShell = Nothing
Set objFSO = Nothing

End Sub


Sub runPOWER_BALANCED

' Set shell = CreateObject("Shell.Application")
' shell.ShellExecute "cmd /c ", "powercfg /setactive SCHEME_BALANCED", "", "", 1
' Set shell = Nothing

      Dim shell
      Set shell = CreateObject("WScript.Shell")
      shell.Run "powercfg /setactive SCHEME_BALANCED", 1, False
      Set shell = Nothing

End Sub





Dim percent

Sub fn_START()
  percent = 0
  Call fn_Loading
End Sub


Sub fn_Loading()
  If percent <= 100 Then
    document.getElementById("progressBar").style.width = percent & "%"
    document.getElementById("label").innerText = percent & "%"
    percent = percent + 10
    window.setTimeout "fn_Loading", 300
  Else
    document.getElementById("label").innerText = "완료!"
  End If
End Sub




