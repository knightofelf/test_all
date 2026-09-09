@echo on


rem ½ÃÀÛ

echo CREATE VDISK FILE="C:\main\Win11HomeCx.vhd" PARENT="K:\Win11Home.vhd" > "C:\main\DP-Script.txt"

diskpart /s "C:\main\DP-Script.txt" > nul
del "C:\main\DP-Script.txt" /q


echo CREATE VDISK FILE="C:\main\Win10ProCx.vhd" PARENT="N:\VM\Win10Pro.vhd" > "C:\main\DP-Script.txt"

diskpart /s "C:\main\DP-Script.txt" > nul
del "C:\main\DP-Script.txt" /q

rem ³¡

pause



exit



@REM --------------------------------------------

diskpart / s ¡°C: \ Scripts \ attach_vhd.txt¡±

select VDisk file = ¡°F: \ imagedisk.vhdx¡±
attach VDisk
assign letter = M

//
Mount-DiskImage -ImagePath C:\vhd\lab_data.vhdx ?PassThru | Get-Disk | Get-Partition | Add-PartitionAccessPath -AccessPath "C:\LAB"

Taskschd.msc
C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe
Add argument: -command 
"Mount-DiskImage -ImagePath C:\vhd\lab_data.vhdx ?PassThru | Get-Disk | Get-Partition | Set-Partition -NewDriveLetter G"
