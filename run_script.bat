@echo off
Title Browse4Folder
Color 0A
Call :Browse4Folder "Choose source folder to scan" "c:\scripts"
echo You have chosen this location "%Location%"
setlocal enableextensions
set count=0
SET var=%cd%
cd "%Location%"
for %%x in (*.jpg) do set /a count+=1
echo %count%
echo %var%
cd "%var%"
python run_alicevision.py build_files %Location% "Meshroom-2018.1.0\\aliceVision\\bin\\" %count% runall
cd build_files/11_Texturing
set /p Input=Give your 3D-mesh a name: 
obj2gltf -i texturedMesh.obj -o %var%/%Input%.gltf
endlocal
pause
::***************************************************************************
:Browse4Folder
set Location=
set vbs="%temp%\_.vbs"
set cmd="%temp%\_.cmd"
for %%f in (%vbs% %cmd%) do if exist %%f del %%f
for %%g in ("vbs cmd") do if defined %%g set %%g=
(
    echo set shell=WScript.CreateObject("Shell.Application"^) 
    echo set f=shell.BrowseForFolder(0,"%~1",0,"%~2"^) 
    echo if typename(f^)="Nothing" Then  
    echo wscript.echo "set Location=Dialog Cancelled" 
    echo WScript.Quit(1^)
    echo end if 
    echo set fs=f.Items(^):set fi=fs.Item(^) 
    echo p=fi.Path:wscript.echo "set Location=" ^& p
)>%vbs%
cscript //nologo %vbs% > %cmd%
for /f "delims=" %%a in (%cmd%) do %%a
for %%f in (%vbs% %cmd%) do if exist %%f del /f /q %%f
for %%g in ("vbs cmd") do if defined %%g set %%g=
goto :eof
::***************************************************************************


