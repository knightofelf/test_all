
@REM start /b → 새 창을 띄우지 않고 실행
@REM cmd /c → 명령 실행 후 CMD 종료
@REM your_program.exe → 실행할 프로그램 이름

@REM start /b cmd /c notepad.exe

@REM Set WshShell = CreateObject("WScript.Shell")
@REM WshShell.Run "yourbatch.bat", 0, False

@REM start /b cmd /c notepad.exe
@REM start /min cmd /c notepad.exe

start /min cmd /c notepad.exe 
exit

