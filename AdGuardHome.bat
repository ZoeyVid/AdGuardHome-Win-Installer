@echo off
curl --ssl-no-revoke -sL -o %0 https://github.com/ZoeyVid/AdGuardHome-Win-Installer/releases/latest/download/AdGuardHome.bat

FOR /F "usebackq" %%f IN (`PowerShell -NoProfile -Command "Write-Host([Environment]::GetFolderPath('Desktop'))"`) DO (
  SET "DESKTOP_FOLDER=%%f"
  )

CLS
echo.
echo  GNU Affero General Public License v3.0 - AdGuardHome-Win-Installer
echo.
echo  You can find the License here: https://github.com/ZoeyVid/AdGuardHome-Win-Installer/blob/main/COPYING
echo.
echo  GNU General Public License v3.0  - AdGuardHome
echo.
echo  The latest Version of License AdGuardHome is licensed under can be found here: https://github.com/AdguardTeam/AdGuardHome/blob/master/LICENSE.txt
echo.
echo  Do you accept this Licenses?
echo.
echo  1. No
echo  2. Yes
echo.
CHOICE /C 12 /M " Selection: "
IF ERRORLEVEL 2 GOTO 1
IF ERRORLEVEL 1 echo  Aborting... & pause & GOTO end

:1
if not exist AdGuardHome.exe (
echo.
echo  Do you want to install AdGuardHome in the Current Directory?
echo.
echo  1. No
echo  2. Yes
echo.
CHOICE /C 12 /M " Selection: "
IF ERRORLEVEL 2 CLS & GOTO 2
IF ERRORLEVEL 1 echo  Aborting... & pause & EXIT /B
) else (
echo.
echo  Do you want to update or remove AdGuardHome in the Current Directory?
echo.
echo  1. Update
echo  2. Remove
echo  3. Abort
echo.
CHOICE /C 123 /M " Selection: "
IF ERRORLEVEL 3 echo  Aborting... & pause & EXIT /B
IF ERRORLEVEL 2 CLS & GOTO rm
IF ERRORLEVEL 1 CLS & GOTO 2
)

:rm
rmdir /S /Q data
del /S /Q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\AdGuaedHome.lnk"
del /S /Q "%DESKTOP_FOLDER%\AdGuaedHome.lnk"
del /S /Q "AdGuardHome.exe"
del /S /Q "AdGuaedHome.bat"
del /S /Q %0
exit /B

:2
echo.
echo  Which Version of AdGuaedHome do you want to use?
echo.
echo  1. Stable
echo  2. Beta
echo  3. Edge
echo.
CHOICE /C 123 /M " Selection: "
IF ERRORLEVEL 3 CLS & curl --ssl-no-revoke -o AdGuardHome.zip -L https://static.adguard.com/adguardhome/edge/AdGuardHome_windows_amd64.zip & GOTO 3
IF ERRORLEVEL 2 CLS & curl --ssl-no-revoke -o AdGuardHome.zip -L https://static.adguard.com/adguardhome/beta/AdGuardHome_windows_amd64.zip & GOTO 3
IF ERRORLEVEL 1 CLS & curl --ssl-no-revoke -o AdGuardHome.zip -L https://static.adguard.com/adguardhome/release/AdGuardHome_windows_amd64.zip & GOTO 3

:3
tar xf AdGuardHome.zip
del /S /Q AdGuardHome.zip
move AdGuardHome\AdGuardHome.exe .
rmdir /S /Q AdGuardHome
CLS

echo.
echo  Do you want to start AdGuardHome on Boot?
echo.
echo  1. No
echo  2. Yes
echo.
CHOICE /C 12 /M " Selection: "
IF ERRORLEVEL 2 GOTO 4
IF ERRORLEVEL 1 GOTO 5

:4
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo  Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo  sLinkFile = "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\AdGuaedHome.lnk" >> %SCRIPT%
echo  Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo  oLink.TargetPath = "%cd%\AdGuardHome.exe" >> %SCRIPT%
echo  oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del /S /Q %SCRIPT%

:5
echo.
echo  Do you want to create an Desktop Shortcut for AdGuardHome?
echo.
echo  1. No
echo  2. Yes
echo.
CHOICE /C 12 /M " Selection: "
IF ERRORLEVEL 2 GOTO 6
IF ERRORLEVEL 1 GOTO 7

:6
set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"
echo  Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo  sLinkFile = "%DESKTOP_FOLDER%\AdGuaedHome.lnk" >> %SCRIPT%
echo  Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo  oLink.TargetPath = "%cd%\AdGuardHome.exe" >> %SCRIPT%
echo  oLink.Save >> %SCRIPT%
cscript /nologo %SCRIPT%
del /S /Q %SCRIPT%

:7
start AdGuardHome.exe
start http://127.0.0.1:3000
exit /B
