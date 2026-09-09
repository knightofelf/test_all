
bootrec /repairbcd
bootrec /osscan
bootrec /repairmbr

@REM sfc /scannow

@REM ?? 각 명령어 동작 방식
@REM bootrec /fixmbr → 현재 선택된 시스템 디스크의 MBR(마스터 부트 레코드)을 덮어씁니다. → 특정 드라이브를 지정하는 옵션은 없음.
@REM bootrec /fixboot → 시스템 파티션에 새 부트 섹터를 작성합니다. → 역시 드라이브 지정 불가.
@REM bootrec /scanos → 모든 디스크를 스캔하여 윈도우 설치를 찾습니다. → 자동으로 전체 드라이브를 검사.
@REM bootrec /rebuildbcd → 모든 디스크를 검색해 윈도우 설치를 BCD에 추가할지 묻습니다. → 특정 드라이브 지정 불가.

@REM bcdboot C:\Windows /s D: /f UEFI
@REM bcdboot G:\Windows

@REM bcdboot I:\Windows /s I: /f UEFI
@REM bcdboot I:\Windows /s I: /f BIOS
@REM bcdboot I:\Windows /f BIOS

@REM bcdboot I:\Windows /s I:
@REM bcdboot C:\Windows /s D: /f BIOS

