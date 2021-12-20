@echo off
curl -sL -o %0 https://github.com/SanCraftDev/AdGuardHome-Win-Installer/releases/latest/download/AdGuardHome.bat

:--------------------------------------
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

FOR /F "usebackq" %%f IN (`PowerShell -NoProfile -Command "Write-Host([Environment]::GetFolderPath('Desktop'))"`) DO (
  SET "DESKTOP_FOLDER=%%f"
  )

echo.
echo  MIT License
echo.
echo  Copyright (c) 2021 SanCraft
echo.
echo  Permission is hereby granted, free of charge, to any person obtaining a copy
echo  of this software and associated documentation files (the "Software"), to deal
echo  in the Software without restriction, including without limitation the rights
echo  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
echo  copies of the Software, and to permit persons to whom the Software is
echo  furnished to do so, subject to the following conditions:
echo.
echo  The above copyright notice and this permission notice shall be included in all
echo  copies or substantial portions of the Software.
echo.
echo  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
echo  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
echo  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
echo  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
echo  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
echo  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
echo  SOFTWARE.
echo.
echo  Do you accept this?
echo.
echo  1. No
echo  2. Yes
echo.
CHOICE /C 12 /M " Selection: "
IF ERRORLEVEL 2 CLS & GOTO 1
IF ERRORLEVEL 1 echo  Aborting... & pause & EXIT /B

:1
echo.
echo  Do you want to install AdGuardHome in the Current Directory?
echo.
echo  1. No
echo  2. Yes
echo.
CHOICE /C 12 /M " Selection: "
IF ERRORLEVEL 2 CLS & GOTO 2
IF ERRORLEVEL 1 echo  Aborting... & pause & EXIT /B

:2
echo.
echo  Which Version of AdGuaedHome do you want to use?
echo.
echo  1. Stable
echo  2. Beta
echo  3. Edge
echo.
CHOICE /C 123 /M " Selection: "
IF ERRORLEVEL 3 CLS & curl -o AdGuardHome.zip -L https://static.adguard.com/adguardhome/edge/AdGuardHome_windows_amd64.zip & set port=3001 & GOTO 3
IF ERRORLEVEL 2 CLS & curl -o AdGuardHome.zip -L https://static.adguard.com/adguardhome/beta/AdGuardHome_windows_amd64.zip & set port=3000 & GOTO 3
IF ERRORLEVEL 1 CLS & curl -o AdGuardHome.zip -L https://static.adguard.com/adguardhome/release/AdGuardHome_windows_amd64.zip & set port=3000 & GOTO 3

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
start http://127.0.0.1:%port%
exit /B