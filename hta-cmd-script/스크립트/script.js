



var pos_x = null;
var pos_y = null;


// script.js 예시
window.onload = function() {
  // 새로고침이 여기 있으면 무한 루프 발생 가능
  //location.reload();   //← 제거 또는 조건 추가
 pos_x = window.screenLeft ;
 pos_y = window.screenTop ;

};



//
window.onunload = function() {
    // 창이 닫힐 때 실행할 코드
//s    alert("HTA 창이 닫힙니다. 리소스를 정리합니다.");

    // 예: 객체 해제, 로그 저장 등

};




/*
window.onbeforeunload = function() {
    return "정말로 종료하시겠습니까?";
};
*/


/*
    function killAll() {
      var shell = new ActiveXObject("WScript.Shell");
      var command = 'powershell -Command "Stop-Process -Name \'wscript\',\'cmd\',\'conhost\',\'mshta\' -Force"';
      shell.Run(command, 0, true);
    }
var shell = new ActiveXObject("WScript.Shell");
shell.Run("powershell -Command \"Stop-Process -Name 'wscript','cmd','conhost','mshta' -Force\"", 1, true);
*/



function runClipBoard ( ) {

var shell = new ActiveXObject("WScript.Shell");

var command = "";

command = 'cmd /c "echo off | clip"';
shell.Run(command, 0, true);


command = "powershell -Command \"Clear-Clipboard\"";
shell.Run(command, 0, true);

command = "powershell -Command \"Clear-Host; [System.GC]::Collect()\"";
shell.Run(command, 0, true);


/*
@echo off
cmd /c "echo off | clip"
cmd /c "powershell -command 'Clear-Clipboard'"
Clear-Clipboard
powershell -command "Clear-Clipboard"
exit
*/

shell = null;
CollectGarbage();

}




function runDefragxx ( ) {

var shell = new ActiveXObject("WScript.Shell");


/*
var command = 'powershell -Command "defrag.exe /C /B /U /V"';
shell.Run(command, 0, true);



var command = "";

command = 'cmd /c "echo off | defrag.exe /C /B /U /V"';
shell.Run(command, 0, true);

command = 'cmd /c "echo off | defrag.exe /C /D /U /V"';
shell.Run(command, 0, true);

command = 'cmd /c "echo off | defrag.exe /C /O /U /V"';
shell.Run(command, 0, true);

command = 'cmd /c "echo off | defrag.exe /C /L /U /V"';
shell.Run(command, 0, true);

command = 'cmd /c "echo off | defrag.exe /C /X /U /V"';
shell.Run(command, 0, true);
*/



shell = null;
CollectGarbage();

}




function runProcess ( ) {

try
{

// 파일 쓰기 읽기
var shell = new ActiveXObject("WScript.Shell");

// var command = 'powershell -Command "Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU, ID | Out-File  -Encoding Default  \'C:\\main\\save\\Process_result.txt\'"';

// Out-File -Encoding Default 'C:\Program Files\MyApp\Process_result.txt'

var resultPath = save + "Process_result.txt";
var command = 'powershell -Command "Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU, ID | Out-File -Encoding Default \'' + resultPath + '\'"';


shell.Run(command, 0, true);



/*
Stop-Process -Id 10116 -Force
Stop-Process -Name "notepad" -Force


shell.Run("powershell -Command 'Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU, ID -Verb RunAs' > C:\\main\\save\\Process_result.txt", 0, true);

shell.Run("powershell -Command \"Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU, ID | Out-File 'C:\\main\\save\\Process_result.txt'\"", 0, true)

shell.Run("powershell -Command \"Start-Process powershell -ArgumentList 'Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU, ID | Out-File C:\\main\\save\\Process_result.txt' -Verb RunAs\"", 0, true)


//
const { exec } = require('child_process');
const fs = require('fs');
const path = save+'Process_result.txt';

// PowerShell 명령어
const psCommand = `powershell -Command "Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU, ID | Out-File -Encoding UTF8 '${path}'"`;

// 실행
exec(psCommand, (error, stdout, stderr) => {
  if (error) {
    console.error(`실행 오류: ${error.message}`);
    return;
  }
  if (stderr) {
    console.error(`PowerShell 오류: ${stderr}`);
    return;
  }
  console.log(`프로세스 정보가 ${path}에 저장되었습니다.`);
});
*/


var fso = new ActiveXObject("Scripting.FileSystemObject");
var file = fso.OpenTextFile(save+ "Process_result.txt", 1);
var output = "";
while (!file.AtEndOfStream) {
    var line = file.ReadLine();
//    WScript.Echo(line);
      output += line + "<br>";
}
file.Close();
document.getElementById("result").innerHTML = output;

fso = null;
file = null;
shell = null;
CollectGarbage();


      } catch (e) {
        alert("실행 오류: " + e.message);
      }

}






function runPowerList() {

try
{
        var shell = new ActiveXObject("WScript.Shell");

// 파일 쓰기 읽기
var resultPath = save + "powerlist_result.txt";

    var command = 'cmd /c powercfg.exe /list > "' + resultPath + '"';

shell.Run(command, 0, true);

var fso = new ActiveXObject("Scripting.FileSystemObject");
var file = fso.OpenTextFile(save+ "powerlist_result.txt", 1);
var output = "";
while (!file.AtEndOfStream) {
    var line = file.ReadLine();
//    WScript.Echo(line);
      output += line + "<br>";
}
file.Close();
document.getElementById("result").innerHTML = output;

fso = null;
file = null;
shell = null;
CollectGarbage();


      } catch (e) {
        alert("실행 오류: " + e.message);
      }

}



/*
전원 구성표 GUID: 381b4222-f694-41f0-9685-ff5bb260df2e (균형 조정)
전원 구성표 GUID: 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c (고성능) *
전원 구성표 GUID: a1841308-3541-4fab-bc81-f71556f20b4a (절전)
*/

function runPowerMAX() {

try
{
        var shell = new ActiveXObject("WScript.Shell");

// 파일 쓰기 읽기
var resultPath = save + "power_result.txt";

    // cmd 리다이렉션은 반드시 전체 경로를 따옴표로 감싸야 안전합니다.
    var command = 'cmd /c powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > "' + resultPath + '"';

shell.Run(command, 0, true);

var fso = new ActiveXObject("Scripting.FileSystemObject");
var file = fso.OpenTextFile(save+ "power_result.txt", 1);
var output = "";
while (!file.AtEndOfStream) {
    var line = file.ReadLine();
//    WScript.Echo(line);
      output += line + "<br>";
}
file.Close();
document.getElementById("result").innerHTML = " 전원 MAX ";

fso = null;
file = null;
shell = null;
CollectGarbage();


      } catch (e) {
        alert("실행 오류: " + e.message);
      }

}



function runPowerMIN() {

try
{
        var shell = new ActiveXObject("WScript.Shell");

// 파일 쓰기 읽기
var resultPath = save + "power_result.txt";

    // cmd 리다이렉션은 반드시 전체 경로를 따옴표로 감싸야 안전합니다.
    var command = 'cmd /c powercfg.exe /setactive a1841308-3541-4fab-bc81-f71556f20b4a > "' + resultPath + '"';

shell.Run(command, 0, true);


var fso = new ActiveXObject("Scripting.FileSystemObject");
var file = fso.OpenTextFile(save+ "power_result.txt", 1);
var output = "";
while (!file.AtEndOfStream) {
    var line = file.ReadLine();
//    WScript.Echo(line);
      output += line + "<br>";
}
file.Close();
document.getElementById("result").innerHTML = " 전원 MIN ";

fso = null;
file = null;
shell = null;
CollectGarbage();


      } catch (e) {
        alert("실행 오류: " + e.message);
      }

}



function runPowerBALANCED() {

try
{
        var shell = new ActiveXObject("WScript.Shell");


// 파일 쓰기 읽기
var resultPath = save + "power_result.txt";

    // cmd 리다이렉션은 반드시 전체 경로를 따옴표로 감싸야 안전합니다.
    var command = 'cmd /c powercfg.exe /setactive 381b4222-f694-41f0-9685-ff5bb260df2e > "' + resultPath + '"';

shell.Run(command, 0, true);



var fso = new ActiveXObject("Scripting.FileSystemObject");
var file = fso.OpenTextFile(save+ "power_result.txt", 1);
var output = "";
while (!file.AtEndOfStream) {
    var line = file.ReadLine();
//    WScript.Echo(line);
      output += line + "<br>";
}
file.Close();
document.getElementById("result").innerHTML = " 전원 BALANCED ";

fso = null;
file = null;
shell = null;
CollectGarbage();


      } catch (e) {
        alert("실행 오류: " + e.message);
      }

}




function runPowerCfg() {

try
{
        var shell = new ActiveXObject("WScript.Shell");

//	var exec = shell.Exec("powercfg.exe /a");
//	var exec = shell.Exec("cmd /c powercfg /a");
//	var exec = shell.Run("powercfg.exe /a", 0, true);
//	var exec = shell.Run('powershell -WindowStyle Hidden -Command "powercfg /a > C:\\temp\\result.txt"', 0, true);

//	var exec = shell.Exec("cmd /c dir | find \" \"");
//	var exec = shell.Exec("cmd /c powercfg /a | find \" \"");


// for /f "delims=" %A in ('powercfg /a') do set MYVAR=%A
// echo %MYVAR%


// shell.Run("powercfg.bat", 0, true); // 0 = 창 숨김, true = 기다림
// shell.Run("powershell -Command \"Start-Process 'powercfg.bat' -Verb runAs\"", 0, true);
// shell.Run("powershell -Command \"Start-Process 'powercfg.bat' -Verb runAs -WindowStyle Hidden\"", 0, true);


// var value = shell.Environment("User")("MYVAR");
// document.getElementById("result").innerHTML = value;






// 파일 쓰기 읽기
var resultPath = save + "powercfg_result.txt";

    // cmd 리다이렉션은 반드시 전체 경로를 따옴표로 감싸야 안전합니다.
    var command = 'cmd /c powercfg.exe /a > "' + resultPath + '"';

shell.Run(command, 0, true);


var fso = new ActiveXObject("Scripting.FileSystemObject");
var file = fso.OpenTextFile(save+ "powercfg_result.txt", 1);
var output = "";
while (!file.AtEndOfStream) {
    var line = file.ReadLine();
//    WScript.Echo(line);
      output += line + "<br>";
}
file.Close();
document.getElementById("result").innerHTML = output;

fso = null;
file = null;
shell = null;
CollectGarbage();




/*
// 파일 쓰기 읽기 : 
var tempPath = shell.ExpandEnvironmentStrings("%USERPROFILE%\\AppData\\Local\\Temp");
shell.Run("cmd /c powercfg /a > \"" + tempPath + "\\powercfg_result.txt\"", 0, true);


var fso = new ActiveXObject("Scripting.FileSystemObject");
var file = fso.OpenTextFile(tempPath+"\\powercfg_result.txt", 1);
var output = "[절전 정보 표시]<BR>";
while (!file.AtEndOfStream) {
    var line = file.ReadLine();
//    WScript.Echo(line);
      output += line + "<br>";
}
file.Close();
document.getElementById("result").innerHTML = output;
*/





/*
// 파일 쓰기 읽기 : %TEMP% 관리자 권한만 되나보다.
- 일반 사용자: %USERPROFILE%\AppData\Local\Temp
- 관리자 권한: C:\Windows\System32\config\systemprofile\AppData\Local\Temp

shell.Run("cmd /c powercfg /a > \"%TEMP%\\powercfg_result.txt\"", 0, true); // 창 숨김

var fso = new ActiveXObject("Scripting.FileSystemObject");
var file = fso.OpenTextFile(shell.ExpandEnvironmentStrings("%TEMP%\\powercfg_result.txt"), 1);
var output = "[절전 정보 표시]<BR>";
while (!file.AtEndOfStream) {
    var line = file.ReadLine();
//    WScript.Echo(line);
      output += line + "<br>";
}
file.Close();
document.getElementById("result").innerHTML = output;
*/





/*
        var output = "";
        while (!exec.StdOut.AtEndOfStream) {
          var line = exec.StdOut.ReadLine();
          output += line + "<br>";
        }

        document.getElementById("result").innerHTML = output;
*/


/*
var output = "";
for (var i = 1; i <= 20; i++) {
    try {
        var line = shell.Environment("User")("MYVAR" + i);
        if (line) output += line + "<br>";
    } catch (e) {
        break; // 더 이상 없음
    }
}
document.getElementById("result").innerHTML = output;
*/



/*
@echo off
powercfg /a > "%TEMP%\powercfg_result.txt"


@echo off
setlocal enabledelayedexpansion
set i=0
for /f "delims=" %%A in ('powercfg /a') do (
    set /a i+=1
    set "LINE[!i!]=%%A"
)



@echo off
setlocal enabledelayedexpansion
set i=0
set "REGKEY=HKCU\Software\MyPowerCFG"
reg delete "%REGKEY%" /f >nul 2>&1
reg add "%REGKEY%" /f >nul

for /f "delims=" %%A in ('powercfg /a') do (
    set /a i+=1
    reg add "%REGKEY%" /v Line!i! /t REG_SZ /d "%%A" /f >nul
)








## ✅ 여러 줄 저장: 파일 방식

```bat
@echo off
setlocal enabledelayedexpansion

:: 결과를 파일로 저장
powercfg /a > "%TEMP%\powercfg_result.txt"

:: 파일에서 한 줄씩 읽어서 출력하거나 처리
set i=0
for /f "delims=" %%A in (%TEMP%\powercfg_result.txt) do (
    set /a i+=1
    set "LINE[!i!]=%%A"
    echo !LINE[!i!]!
)

:: 총 줄 수 출력
echo 총 줄 수: !i!
```

- `LINE[1]`, `LINE[2]`, … 형태로 메모리에 저장
- 필요하면 JScript나 HTA에서 이 파일을 읽어 HTML에 표시 가능

---

## ✅ 여러 줄 저장: 레지스트리 방식 (고급)

```bat
@echo off
setlocal enabledelayedexpansion

set "REGKEY=HKCU\Software\MyPowerCFG"
reg delete "%REGKEY%" /f >nul 2>&1
reg add "%REGKEY%" /f >nul

set i=0
for /f "delims=" %%A in ('powercfg /a') do (
    set /a i+=1
    reg add "%REGKEY%" /v Line!i! /t REG_SZ /d "%%A" /f >nul
)

echo 저장 완료: !i!줄
```

- `HKCU\Software\MyPowerCFG`에 `Line1`, `Line2`, … 형태로 저장
- JScript에서 `RegRead("HKCU\\Software\\MyPowerCFG\\Line1")` 등으로 읽기 가능

---

## ✅ JScript에서 여러 줄 읽기 (파일 기반)

```javascript
var fso = new ActiveXObject("Scripting.FileSystemObject");
var file = fso.OpenTextFile(fso.GetSpecialFolder(2) + "\\powercfg_result.txt", 1); // TEMP 폴더
var output = "";
while (!file.AtEndOfStream) {
    output += file.ReadLine() + "<br>";
}
file.Close();
document.getElementById("result").innerHTML = output;
```


*/



/*
for /f "delims=" %A in ('powercfg /a ^| find "Sleep"') do setx SLEEP_STATUS "%A"

for /f "delims=" %A in ('powercfg /a ^| find "Sleep"') do reg add "HKCU\Software\MyApp" /v SleepStatus /t REG_SZ /d "%A" /f

var shell = new ActiveXObject("WScript.Shell");
var value = shell.RegRead("HKCU\\Software\\MyApp\\SleepStatus");
WScript.Echo("Sleep 상태: " + value);

var shell = new ActiveXObject("WScript.Shell");
var value = shell.Environment("Process")("MYVAR"); // 현재 프로세스 기준
WScript.Echo("MYVAR = " + value);

var shell = new ActiveXObject("WScript.Shell");
var value = shell.Environment("User")("MYVAR");
WScript.Echo("User MYVAR = " + value);

echo %MYVAR%

var shell = new ActiveXObject("WScript.Shell");
var value = shell.RegRead("HKCU\\Environment\\MYVAR");
WScript.Echo("Registry MYVAR = " + value);

- 사용자 환경 변수:
HKCU\Environment
- 시스템 환경 변수:
HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment


*/




/*
var MYVAR = ""; // 변수처럼 사용
while (!exec.StdOut.AtEndOfStream) {
    var line = exec.StdOut.ReadLine();
    MYVAR += line + "\n"; // 여러 줄 누적
}

// WScript.Echo(MYVAR); // 결과 출력
*/


/*
var output = "";
while (!exec.StdOut.AtEndOfStream) {
      var line = exec.StdOut.ReadLine()
      output += line + "<br>";
}
document.getElementById("result").innerHTML = output;
*/



// findstr /R ".*" file.txt
// findstr "Sleep Hibernate" powercfg_result.txt

/*
for /f "delims=" %%A in ('powercfg /a') do (
    set MYVAR=%%A
    echo %MYVAR%
)

powercfg /a > temp.txt
set /p MYVAR=<temp.txt
echo %MYVAR%


var output = "";
while (!exec.StdOut.AtEndOfStream) {
//    WScript.Echo(exec.StdOut.ReadLine());
      var line = exec.StdOut.ReadLine()
      output += line + "<br>";
}
document.getElementById("result").innerHTML = output;
*/



/*
// 파일 쓰기 읽기
shell.Run("cmd /c powercfg.exe /a > C:\\main\\save\\powercfg_result.txt", 0, true);

var fso = new ActiveXObject("Scripting.FileSystemObject");
var file = fso.OpenTextFile(save+ "powercfg_result.txt", 1);
var output = "";
while (!file.AtEndOfStream) {
    var line = file.ReadLine();
//    WScript.Echo(line);
      output += line + "<br>";
}
file.Close();
document.getElementById("result").innerHTML = output;
*/


/*
## 🧠 1. 레지스트리 접근

var shell = new ActiveXObject("WScript.Shell");
var desktopPath = shell.RegRead("HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders\\Desktop");

shell.Run("cmd /c powercfg.exe /a > \"" + desktopPath + "\\powercfg_result.txt\"", 0, true);


### ✅ 삭제 (`RegDelete`)

```javascript
var shell = new ActiveXObject("WScript.Shell");
shell.RegDelete("HKCU\\Software\\MyApp\\Setting");
```

### ✅ 쓰기 (`RegWrite`)

```javascript
var shell = new ActiveXObject("WScript.Shell");
shell.RegWrite("HKCU\\Software\\MyApp\\Setting", "TEST", "REG_SZ");
```

- `"REG_SZ"`는 문자열 형식
- 키가 없으면 자동 생성됨


### ✅ 읽기 (`RegRead`)

```javascript
var shell = new ActiveXObject("WScript.Shell");
var value = shell.RegRead("HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders\\Desktop");
WScript.Echo("내 데스크탑 경로: " + value);
```

- `HKCU` = 현재 사용자
- `Shell Folders\\Desktop` = 데스크탑 경로



## 🌐 2. 환경 변수 접근

set %환경변수% = ""
powercfg.exe /a > %환경변수%
echo %환경변수%

Remove-Item Env:TEST

var shell = new ActiveXObject("WScript.Shell");
var env = shell.Environment("USER");
env.Remove("TEST");

set TEST=
echo %TEST%

set TEST=
powercfg.exe /a > %TEST%
echo %TEST%


//
powercfg.exe /a > %TEST%
echo %TEST%

var shell = new ActiveXObject("WScript.Shell");
var env = shell.Environment("PROCESS");
var path = env("TEMP"); // 예: %USERPROFILE%\AppData\Local\Temp

shell.Run("cmd /c powercfg.exe /a > " + path + "\\powercfg_result.txt", 0, true);


### ✅ 읽기

```javascript
var shell = new ActiveXObject("WScript.Shell");
var env = shell.Environment("PROCESS"); // 또는 "SYSTEM", "USER", "VOLATILE"
WScript.Echo("PATH: " + env("PATH"));
```

### ✅ 쓰기

```javascript
var shell = new ActiveXObject("WScript.Shell");
var env = shell.Environment("USER");
env("MY_VAR") = "TEST값";
```

- `"USER"`는 현재 사용자 환경 변수
- `"SYSTEM"`은 관리자 권한 필요

### ✅ 삭제

```javascript
var shell = new ActiveXObject("WScript.Shell");
var env = shell.Environment("USER");
env.Remove("MY_VAR");
```

---

## 🧾 요약

| 작업 | 레지스트리 | 환경 변수 |
|------|------------|------------|
| 읽기 | `RegRead()` | `env("KEY")` |
| 쓰기 | `RegWrite()` | `env("KEY") = 값` |
| 삭제 | `RegDelete()` | `env.Remove("KEY")` |

---
*/



/*
        var output = "";
        while (!exec.StdOut.AtEndOfStream) {
          var line = exec.StdOut.ReadLine();
          output += line + "<br>";
        }

        document.getElementById("result").innerHTML = output;
*/

      } catch (e) {
        alert("실행 오류: " + e.message);
      }

}









function runCMD2() {
    window.location.href = "file:///C:/Windows/System32/notepad.exe";
}

function runCMD() {
//    window.location.href = "file:///%USERPROFILE%\\Desktop\\Desktop\\ics_enable - 바로 가기.lnk";

    window.location.href = "file:///C:\\main\\스크립트\\ics_enable.bat";

}


/*
%USERPROFILE%\Desktop → C:\Users\magun\Desktop

Set-Location "$env:USERPROFILE\Desktop"

Set shell = CreateObject("WScript.Shell")
userPath = shell.ExpandEnvironmentStrings("%USERPROFILE%")
MsgBox userPath
*/



//onunload는 창이 닫히거나 새 페이지로 이동할 때 모두 실행됩니다.
function cleanUp() {
    // 리소스 정리 코드
    // 예: COM 객체 해제

runClipBoard ( );

KillWScript ( );




//clearInterval(myInterval)
//window.removeEventListener("load", myFunction)

//myData = null

window.close()

}






function readFileAsync1() {
  var fso = new ActiveXObject("Scripting.FileSystemObject");

  if (fso.FileExists("C:\\CLSID_List.txt")) {
    var file = fso.OpenTextFile("./CLSID_List.txt", 1);
    var content = "";
    while (!file.AtEndOfStream) {
      content += file.ReadLine() + "<br>";
    }
    file.Close();
    document.getElementById("div_output").innerHTML = content;
  }
}
// setTimeout(readFileAsync, 10);  // 1초 후 실행



var timerId;

function readFileAsync() {
  var fso = new ActiveXObject("Scripting.FileSystemObject");
  var filePath = "./CLSID_List.txt";

  if (!fso.FileExists(filePath)) {
    document.getElementById("div_output").innerHTML = "파일이 존재하지 않습니다.";
    return;
  }

  var totalSize = fso.GetFile(filePath).Size;
  var readSize = 0;
  var file = fso.OpenTextFile(filePath, 1);
  var content = "";

  while (!file.AtEndOfStream) {
    var line = file.ReadLine();
    content += line + "<br>";
    readSize += line.length + 3; // 줄바꿈 포함 (대략적 계산)
    var percent = Math.min(100, Math.round((readSize / totalSize) * 100));
    document.getElementById("progressBar").style.width = percent + "%";
    document.getElementById("label").innerText = percent + "%";
  }

  file.Close();
  document.getElementById("div_output").innerHTML = content;
  document.getElementById("label").innerText = "완료!";

if (timerId) {
  clearTimeout(timerId);
//  console.log("타이머 취소됨");
}

}


function fn_Timeout_readFileAsync() 
{
	if (timerId !== undefined && timerId !== null) {
//	  console.log("타이머가 설정되어 있음");
	}
	else
	{
		timerId = setTimeout(readFileAsync, 10);  // 10ms 후 실행
	}
}


/*
function fn_fetch()
{
fetch("http://localhost:3000/test.txt")
  .then(response => response.text())
  .then(data => {
    document.getElementById("div_output").innerHTML = data;
  })
  .catch(error => {
    console.error("에러 발생:", error);
  });
}
*/





function runCOMClass() {
var locator = new ActiveXObject("WbemScripting.SWbemLocator");
var service = locator.ConnectServer(".", "root\\cimv2");
var items = service.ExecQuery("SELECT * FROM Win32_ClassicCOMClassSetting");

var e = new Enumerator(items);
for (; !e.atEnd(); e.moveNext()) {
  var item = e.item();
// '  WScript.Echo(item.ComponentId + " → " + item.Description);
  document.getElementById("content").innerText = "출력 메시지입니다"
}
}





var clips = [];

function addClip() {
  var text = document.getElementById("inputText").value;
  clips.push(text);
  var li = document.createElement("li");
  li.innerText = text;
  document.getElementById("clipList").appendChild(li);
}





function copyToClipboard(text) {
  var clipboard = new ActiveXObject("htmlfile");
  clipboard.parentWindow.clipboardData.setData("Text", text);
}

function pasteToInput() {
  var clipboard = new ActiveXObject("htmlfile");
  var text = clipboard.parentWindow.clipboardData.getData("Text");
  document.getElementById("myInput").value = text;
}



var multiClip = [];

function copyToVirtualClip(text) {
  multiClip.push(text);
  alert("복사됨: " + text);
}

function pasteFromVirtualClip(index) {
  var clipboard = new ActiveXObject("htmlfile");

var text = multiClip[index];
if (typeof text === "string" && text.length > 0) {
  window.clipboardData.setData("Text", text);
} else {
  alert("복사할 텍스트가 없습니다.");
}

//  clipboard.parentWindow.clipboardData.setData("Text", multiClip[index]);
//window.clipboardData.setData("Text", multiClip[index]);
  alert("붙여넣기 완료: " + multiClip[index]);
}






function pasteSelectedClip() {
  var index = document.getElementById("clipSelector").value;
  pasteFromVirtualClip(index);
}



/*
    var dropZone = document.getElementById("drop-zone");
    var output = document.getElementById("output");


      dropZone.ondragover = function(e) {
        if (e && e.preventDefault) e.preventDefault();
      };

      dropZone.ondrop = function(e) {
        if (!e || !e.dataTransfer) {
          output.innerHTML = "❌ 이벤트 객체가 올바르지 않습니다.";
          return;
        }

        e.preventDefault();

        var path = e.dataTransfer.getData("Text");
        if (!path || path.length === 0) {
          output.innerHTML = "❌ 경로를 인식하지 못했습니다.";
          return;
        }


      output.innerHTML = "📄 드래그된 파일들:<br>";

      for (var i = 0; i < files.length; i++) {
        output.innerHTML += "• " + files[i].name + "<br>";
      }
  };
*/





function allowDrop(event) {
  event.preventDefault();
}

function drag(event) {
  event.dataTransfer.setData("text", event.target.id);
}

function drop(event) {
  event.preventDefault();
//  const data = event.dataTransfer.getData("text");
//  const draggedElement = document.getElementById(data);
  var data = event.dataTransfer.getData("text");
  var draggedElement = document.getElementById(data);
  event.target.appendChild(draggedElement);
}




/*
var box = document.getElementById("drag-box");
var isDragging = false;

box.onmousedown = function(e) {
  isDragging = true;
  offsetX = e.clientX - box.offsetLeft;
  offsetY = e.clientY - box.offsetTop;
};

document.onmousemove = function(e) {
  if (isDragging) {
    box.style.left = (e.clientX - offsetX) + "px";
    box.style.top = (e.clientY - offsetY) + "px";
  }
};

document.onmouseup = function() {
  isDragging = false;
};


  function moveBox(x, y) {
    var box = document.getElementById("drag-box");
    box.style.left = x + "px";
    box.style.top = y + "px";
  }

  moveBox(300, 200); // x=200, y=150 위치로 이동



  document.getElementById("content").innerHTML = "<p>외부에서 가져온 텍스트입니다.</p>";
*/





function openPopup() {
  window.open("https://race.heroes.nexon.com", "_blank", "width=800,height=600");
}








/*
var shell = new ActiveXObject("WScript.Shell");
shell.Run("msedge.exe");

var shell = new ActiveXObject("WScript.Shell");
shell.Run("msedge.exe https://race.heroes.nexon.com/");

shell = null;  // 참조 해제

*/




    function loadContent1() {
/*
      const xhr = new XMLHttpRequest();
      xhr.open("GET", "https://race.heroes.nexon.com/", true); // 같은 서버에 있는 파일
      xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
          document.getElementById("content").innerHTML = xhr.responseText;
        }
      };
      xhr.send();
*/
    }

    function loadContent() {
var xhr = new ActiveXObject("Microsoft.XMLHTTP");
xhr.open("GET", "https://race.heroes.nexon.com/", true);
xhr.onreadystatechange = function() {
  if (xhr.readyState == 4 && xhr.status == 200) {
    document.getElementById("content").innerHTML = xhr.responseText;
  }
};
xhr.send();
    }









/*

<!-- Google tag (gtag.js) -->

<!-- 

<script async src="https://www.googletagmanager.com/gtag/js?id=G-KQP1KWK6JC"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-KQP1KWK6JC');
</script>

 -->



<script language="javascript">
var pos_x = window.screenLeft;
var pos_y = window.screenTop;
</script>

  <script language="VBScript">

  </script>



<script language="javascript">
</script>


*/




function fn_DragDrop ( )
{

ShowWindowPosition();


// window.moveTo(100, 100);


// alert( window.screenLeft + '&y=' + window.screenTop );
// alert( pos_x + '&y=' + pos_y );

// var path = 'J:\\heroes\\바탕 화면\\기능\\HTML drag drop.html?x=' + window.screenLeft + '&y=' + window.screenTop  ;

var path = root+'HTML drag drop.html?x=' + window.screenLeft + '&y=' + window.screenTop  ;

runProgram ( path );

/*
console.log(window.screenX); // 예: 100
console.log(window.screenY); // 예: 200
console.log(window.screenLeft); // 대부분의 브라우저에서 지원
console.log(window.screenTop);
console.log("전체 화면 너비:", screen.width);
console.log("전체 화면 높이:", screen.height);
*/
}



