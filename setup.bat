@echo off

echo Make sure your desktop and csgo resolutions exist in your nvidia control panel / whatever AMD uses otherwise it won't work

:: remove old


if exist bin\ (
	del /f /s /q bin 1>nul
	rmdir /s /q bin 1>nul
)

if exist CSGO.lnk (
	del CSGO.lnk 1>nul
)


if exist resources\ (
	goto :steamDir
) else (
	echo resources folder not found. Please download it at https://github.com/Jack-Bailey/CS-Res
	goto :end
)

:: Locations

:steamdir
set filedir=%~dp0

set /p steam="Steam.exe location: "
if exist %steam% (
	echo Successfully found Steam
	echo.
	goto :csgoDir
) else (
	echo Cannot find steam... Make sure you've linked the exe and not the steam folder
	goto :steamdir
)

:csgoDir

set /p csgo="csgo.exe location: "
if exist %csgo% (
	echo Successfully found CSGO
	echo.
	goto :resDir
) else (
	echo Cannot find csgo... Make sure you've linked the exe and not the csgo folder
	goto :csgoDir
)

:resDir

echo Desktop resolution setup: (Not in Game)



:origRes
echo.
set /p string="Res (e.g. 1920x1080 144): "
for /F "tokens=1,2,3 delims=x " %%a in ("%string%") do (
   set oWidth=%%a
   set oHeight=%%b
   set oRefresh=%%c
)

if [%oWidth%] == [] echo Width is not defined & GOTO :origRes
if [%oHeight%] == [] echo Height is not defined &  GOTO :origRes
if [%oRefresh%] == [] echo Refresh is not defined &  GOTO :origRes

echo. 
echo CSGO resolution setup:

:gameRes
echo.
set /p string="Res (e.g. 1152x864 144): "

for /F "tokens=1,2,3 delims=x " %%a in ("%string%") do (
   set gWidth=%%a
   set gHeight=%%b
   set gRefresh=%%c
)

if [%gWidth%] == [] echo Width is not defined & GOTO :origRes
if [%gHeight%] == [] echo Height is not defined &  GOTO :origRes
if [%gRefresh%] == [] echo Refresh is not defined &  GOTO :origRes


mkdir bin
echo @echo OFF > bin\csgo.bat
echo "..\resources\qres\qres.exe" x=%gWidth% y=%hHeight% f=%gRefresh% >> bin\csgo.bat
echo "..\resources\CursorLock.exe" /O:"%steam%" /P:"-applaunch 730" /A:"%csgo%" >> bin\csgo.bat
echo "..\resources\qres\qres.exe" x=%oWidth% y=%oHeight% f=%oRefresh% >> bin\csgo.bat

echo. 
echo [+] Created custom csgo.bat
echo CreateObject("Wscript.Shell").Run "%filedir%bin\csgo.bat", 0, True > bin\silent.vbs

echo [+] Created Silent file
echo [+] Downloaded Icon

(
	echo Dim objShortcut, objShell
	echo Set objShell = WScript.CreateObject ^(^"Wscript.Shell^"^)
	echo Set objShortcut = objShell.CreateShortcut ^(^"%filedir%CSGO.lnk^"^)
	echo objShortcut.TargetPath = ^"%filedir%bin\silent.vbs^"
	echo objShortcut.WorkingDirectory = "%filedir%bin"
	echo objShortcut.Description = ^"CSGO^"
	echo objShortcut.IconLocation = ^"%filedir%resources\csgo.ico^"
	echo objShortcut.Save
	echo WScript.Quit
) > shortcut.vbs

shortcut.vbs
del shortcut.vbs
set programDir="%APPDATA%\Microsoft\Windows\Start Menu\Programs\"

copy %filedir%CSGO.lnk "%APPDATA%\Microsoft\Windows\Start Menu\Programs\CSGO.lnk" 1>nul

echo [+] Added to program folder
echo. 
echo ## Completed ##
echo.
echo Search or find "CSGO" in your start menu to pin it to your taskbar or start menu or put the shortcut on your desktop

echo Press ENTER to finish
:end
pause 1>nul
