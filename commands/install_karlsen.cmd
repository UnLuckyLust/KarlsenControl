@REM Written by UnLuckyLust - https://github.com/UnLuckyLust/KarlsenControl
@echo off
cls
echo [7;94m::: SETUP :::[0m[94m Installing Karlsen v1.0.0 >>> [0m
curl --output karlsen.zip -LO https://github.com/karlsen-network/karlsend/releases/download/v1.0.0/karlsend-v1.0.0-win64.zip
setlocal
cd /d %~dp0
Call :UnZipFile "%cd%" "%cd%\karlsen.zip"
exit /b
:UnZipFile <ExtractTo> <newzipfile>
set karlsen="%temp%\_.vbs"
if exist %karlsen% del /f /q %karlsen%
>%karlsen%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%karlsen% echo If NOT fso.FolderExists(%1) Then
>>%karlsen% echo fso.CreateFolder(%1)
>>%karlsen% echo End If
>>%karlsen% echo set objShell = CreateObject("Shell.Application")
>>%karlsen% echo set FilesInZip=objShell.NameSpace(%2).items
>>%karlsen% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%karlsen% echo Set fso = Nothing
>>%karlsen% echo Set objShell = Nothing
cscript //nologo %karlsen%
if exist %karlsen% del /f /q %karlsen%
if exist karlsen.zip del karlsen.zip
call KarlsenControl.cmd
