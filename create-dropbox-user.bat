@ECHO OFF
SET /p username="Username: " %=%
SET /p password="Passwort: " %=%

SET autostartfile="c:\dropboxen.bat"

rem create user
NET USER %username% %password% /ADD
if errorlevel 1 ECHO Could not create user "%username%" && GOTO :EOF

rem Hide newly created user
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v %username% /t REG_DWORD /d 0
if errorlevel 1 ECHO Could not create registry key && GOTO :EOF

rem Download Dropbox installer
wget "https://www.dropbox.com/download?plat=win" -O DropboxInstaller.exe
if errorlevel 1 ECHO Could not Download Dropbox Installer && GOTO :EOF

rem Execute Dropbox installer as target user
psexec -u "%username%" -p "%password%" "DropboxInstaller.exe"
if errorlevel 1 ECHO Dropbox Installation not successfull && GOTO :EOF
DEL DropboxInstaller.exe

rem add line to autostart file
ECHO psexec -d -u "%username%" -p %password% "C:\Users\%username%\AppData\Roaming\Dropbox\bin\Dropbox.exe" >> %autostartfile%
if errorlevel 1 ECHO Could not add autostart line && GOTO :EOF

ECHO done.
