@REM Written by UnLuckyLust - https://github.com/UnLuckyLust/KarlsenControl
@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"
@REM -----------------------------------
@REM ↧↧↧ Start of configuration area ↧↧↧
@REM -----------------------------------
@REM ! IMPORTANT ! Change the Karlsen_Folder value to the Karlsen directory path, or place this file in the Karlsen folder.
    set Karlsen_Folder=%cd%

@REM ----------------------
@REM ↧↧↧ Debug Settings ↧↧↧
@REM ----------------------
    set Debug=false
    set shortcut=true
    set shortcut_location=%cd%
    set shortcut_icon=C:\Windows\System32\cmd.exe
@REM ---------------------------------
@REM ↥↥↥ End of configuration area ↥↥↥
@REM ---------------------------------

if exist %Karlsen_Folder% ( cd %Karlsen_Folder% ) else exit
if exist install_karlsen.cmd del install_karlsen.cmd
set p_name=KarlsenControl
set TimeOut=10
fsutil dirty query %systemdrive% >nul || (
    if %Debug%==true echo [7;94m::: SETUP :::[0m[94m Requesting administrative privileges... [0m
    set "ELEVATE_CMDLINE=cd /d "%cd%" & call "%~f0" %*"
    findstr "^:::" "%~sf0">"%temp%\getadmin.vbs"
    cscript //nologo "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs" & exit /b
)
rem ------- getadmin.vbs ----------------------------------
::: Set objShell = CreateObject("Shell.Application")
::: Set objWshShell = WScript.CreateObject("WScript.Shell")
::: Set objWshProcessEnv = objWshShell.Environment("PROCESS")
::: strCommandLine = Trim(objWshProcessEnv("ELEVATE_CMDLINE"))
::: objShell.ShellExecute "cmd", "/c " & strCommandLine, "", "runas"
rem -------------------------------------------------------
if %Debug%==true echo [7;92m::: SUCCESS :::[0m[92m Running %p_name% as admin [0m

@REM Karlsen Check
set REkarlsen=start
if exist %Karlsen_Folder%/karlsend.exe (
    if exist %Karlsen_Folder%/karlsenwallet.exe (
        if exist %Karlsen_Folder%/karlsenminer.exe (
            if exist %Karlsen_Folder%/karlsenctl.exe (
                set REkarlsen=pass
            ) else (
                echo [7;91m::: ERROR :::[0m[91m Cannot find karlsenctl.exe, make sure this file is located in the Karlsen installation directory. [0m
                set /p REkarlsen="[7;96m::: INPUT :::[0m Would you like to download [93mKarlsen v1.0.0[0m? ([96mY[0m/[96mN[0m) > "
            )
        ) else (
            echo [7;91m::: ERROR :::[0m[91m Cannot find karlsenminer.exe, make sure this file is located in the Karlsen installation directory. [0m
            set /p REkarlsen="[7;96m::: INPUT :::[0m Would you like to download [93mKarlsen v1.0.0[0m? ([96mY[0m/[96mN[0m) > "
        )
    ) else (
        echo [7;91m::: ERROR :::[0m[91m Cannot find karlsenwallet.exe, make sure this file is located in the Karlsen installation directory. [0m
        set /p REkarlsen="[7;96m::: INPUT :::[0m Would you like to download [93mKarlsen v1.0.0[0m? ([96mY[0m/[96mN[0m) > "
    )
) else (
    echo [7;91m::: ERROR :::[0m[91m Cannot find karlsend.exe, make sure this file is located in the Karlsen installation directory. [0m
    set /p REkarlsen="[7;96m::: INPUT :::[0m Would you like to download [93mKarlsen v1.0.0[0m? ([96mY[0m/[96mN[0m) > "
)

if "%REkarlsen%"=="x" exit
if "%REkarlsen%"=="s" (
    call %p_name%.cmd
)
if "%REkarlsen%"=="Y" ( set REkarlsen=true ) else (
    if "%REkarlsen%"=="y" ( set REkarlsen=true ) else (
        if %REkarlsen%==pass ( set REkarlsen=pass ) else set REkarlsen=false
    )
)

if %REkarlsen%==true (
    echo [7;94m::: SETUP :::[0m[94m Downloading Karlsen files... [0m
    curl --output install_karlsen.cmd -LO https://raw.githubusercontent.com/UnLuckyLust/KarlsenControl/cmd/commands/install_karlsen.cmd
    call install_karlsen.cmd
) else (
    if %REkarlsen%==pass (
        if %Debug%==true echo [7;92m::: SUCCESS :::[0m[92m Karlsen Program Found. [0m
    ) else (
        echo [7;91m::: ERROR :::[0m[91m Can not start, Failed to find Karlsen Program files. [0m
        timeout /t %TimeOut%
        exit  
    )
)

@REM Create Shortcut
set LOG=".\%~N0_runtime.log"
set shortcut_loc=%shortcut_location%\%p_name%.lnk
if %shortcut%==true (
    if exist %shortcut_loc% (
        if %Debug%==true echo [7;94m::: SETUP :::[0m[94m Found existing shortcut. [0m
    ) else (
        set cSctVBS=CreateShortcut.vbs
        ((
        echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
        echo sLinkFile = oWS.ExpandEnvironmentStrings^("!shortcut_loc!"^)
        echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
        echo oLink.TargetPath = oWS.ExpandEnvironmentStrings^("%cd%\%p_name%.cmd"^)
        echo oLink.IconLocation = "%shortcut_icon%"
        echo oLink.WindowStyle = "1"
        echo oLink.WorkingDirectory = "%cd%"
        echo oLink.Save
        )1>!cSctVBS!
        cscript //nologo .\!cSctVBS!
        DEL !cSctVBS! /f /q
        )1>>!LOG! 2>>&1
        if exist !LOG! del !LOG!
        if %Debug%==true echo [7;94m::: SETUP :::[0m[94m Shortcut successfully Created. [0m
    )
)

cls
set Version=1.1.0
echo [7;94m::: INFO :::[0m[94m UnLuckyLust - %p_name% - Version %Version% [0m
echo [7;94m::: INFO :::[0m[94m If you don't have Karlsen Node Running, you must run the command - I - before you can use other commands [0m
echo [7;94m::: INFO :::[0m[94m If you don't have Karlsen Daemon Running, you must run the command - D - befor you can use other commands [0m
echo.
echo [7;93m::::::::::::::::::: SETUP COMMANDS [0m
echo [7;95m:::    SETUP    :::[0m[95m -[0m[93m X [0m[95m- Quit Program [0m
echo [7;95m:::    SETUP    :::[0m[95m -[0m[93m S [0m[95m- Force Quit all Karlsen Processes [0m
echo [7;95m:::    SETUP    :::[0m[95m -[0m[93m I [0m[95m- Index Karlsen UTXOs [0m
echo [7;95m:::    SETUP    :::[0m[95m -[0m[93m D [0m[95m- Start Karlsen Daemon [0m
echo [7;95m:::    INFO     :::[0m[95m -[0m[93m N [0m[95m- Show Node Info [0m
echo [7;95m:::    INFO     :::[0m[95m -[0m[93m B [0m[95m- Show Dag Block Info [0m
echo [7;95m:::   MINING    :::[0m[95m -[0m[93m M [0m[95m- Start Mining Karlsen [0m
echo [7;93m::::::::::::::::::: WALLET COMMANDS [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m C [0m[95m- Create New Wallet [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m R [0m[95m- Restore Wallet from mnemonic [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m A [0m[95m- Add New Receiving Address [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m 1 [0m[95m- Show Balance [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m 2 [0m[95m- Show Addresses [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m 3 [0m[95m- Dump UnEncrypted Data [0m
echo [7;95m:::   WALLET    :::[0m[95m -[0m[93m 4 [0m[95m- Sweep from Privat Key [0m
echo [7;95m::: TRANSACTION :::[0m[95m -[0m[93m 5 [0m[95m- Send Karlsen [0m
echo [7;95m::: TRANSACTION :::[0m[95m -[0m[93m 6 [0m[95m- Sign Transtaction [0m
echo [7;95m::: TRANSACTION :::[0m[95m -[0m[93m 7 [0m[95m- Parse Transtaction [0m
echo [7;95m::: TRANSACTION :::[0m[95m -[0m[93m 8 [0m[95m- Broadcast Transtaction [0m
echo [7;95m::: TRANSACTION :::[0m[95m -[0m[93m 9 [0m[95m- Create UnSigned Transection [0m
echo.

@REM Commands
set U_COMMAND==false
set /p U_COMMAND="[7;96m::: INPUT :::[0m Type a command from the list above > "
if "%U_COMMAND%"=="X" exit
if "%U_COMMAND%"=="x" exit
if "%U_COMMAND%"=="s" set U_COMMAND=S
set KILL_CONFIRM=false
if "%U_COMMAND%"=="S" set /p KILL_CONFIRM="[7;96m::: INPUT :::[0m Are you sure you want to disable all Karlsen processes? ([96mY[0m/[96mN[0m) > "
if "%KILL_CONFIRM%"=="Y" set KILL_CONFIRM=true
if "%KILL_CONFIRM%"=="y" set KILL_CONFIRM=true
if "%U_COMMAND%"=="S" (
    if %KILL_CONFIRM%==true (
        taskkill /F /IM karlsenwallet.exe
        taskkill /F /IM karlsenminer.exe
        taskkill /F /IM karlsend.exe
        taskkill /F /IM cmd.exe
    )
)
if "%U_COMMAND%"=="i" set U_COMMAND=I
if "%U_COMMAND%"=="I" (
    start cmd /k %Karlsen_Folder%/karlsend.exe --utxoindex
)
if "%U_COMMAND%"=="d" set U_COMMAND=D
if "%U_COMMAND%"=="D" (
    start cmd /k %Karlsen_Folder%/karlsenwallet.exe start-daemon
)
if "%U_COMMAND%"=="c" set U_COMMAND=C
if "%U_COMMAND%"=="C" (
    %Karlsen_Folder%/karlsenwallet.exe create
    pause
)
if "%U_COMMAND%"=="r" set U_COMMAND=R
if "%U_COMMAND%"=="R" (
    %Karlsen_Folder%/karlsenwallet.exe create -i
    pause
)
if "%U_COMMAND%"=="a" set U_COMMAND=A
if "%U_COMMAND%"=="A" (
    %Karlsen_Folder%/karlsenwallet.exe new-address
    pause
)
if "%U_COMMAND%"=="1" (
    %Karlsen_Folder%/karlsenwallet.exe balance
    %Karlsen_Folder%/karlsenwallet.exe balance -v
    pause
)
if "%U_COMMAND%"=="2" (
    %Karlsen_Folder%/karlsenwallet.exe show-addresses
    pause
)
if "%U_COMMAND%"=="3" (
    %Karlsen_Folder%/karlsenwallet.exe dump-unencrypted-data
    pause
)
set SWEEP_KEY=PRIVET_KEY
set SWEEP_CONFIRM=false
if "%U_COMMAND%"=="4" (
    set /p SWEEP_KEY="[7;96m::: INPUT :::[0m Enter Privat Key to Sweep from > "
)
if "%U_COMMAND%"=="4" (
    echo [7;93m::: INFO :::[0m[93m Sweep Karlsen from Privet key: [0m[96m%SWEEP_KEY%[0m
    set /p SWEEP_CONFIRM="[7;96m::: INPUT :::[0m Send Y to Confirm Sweep > "
)
if "%SWEEP_CONFIRM%"=="Y" set SWEEP_CONFIRM=true
if "%SWEEP_CONFIRM%"=="y" set SWEEP_CONFIRM=true
if "%U_COMMAND%"=="4" (
    if %SWEEP_CONFIRM%==true (
    %Karlsen_Folder%/karlsenwallet.exe sweep -k %SWEEP_KEY%
    pause
    )
)
set SEND_AMOUNT=0
set SEND_TO=WALLET_ADDRESS
set SEND_CONFIRM=false
if "%U_COMMAND%"=="5" (
    set /p SEND_AMOUNT="[7;96m::: INPUT :::[0m Type Amount of Karlsen to Send > "
    set /p SEND_TO="[7;96m::: INPUT :::[0m Karlsen Address to Send the coins > "
)
if "%U_COMMAND%"=="5" (
    echo [7;93m::: INFO :::[0m[93m Sending Amount of [0m[96m%SEND_AMOUNT%[0m[93m Karlsen to Address: [0m[96m%SEND_TO%[0m
    set /p SEND_CONFIRM="[7;96m::: INPUT :::[0m Send Y to Confirm Sending Karlsen > "
)
if "%SEND_CONFIRM%"=="Y" set SEND_CONFIRM=true
if "%SEND_CONFIRM%"=="y" set SEND_CONFIRM=true
if "%U_COMMAND%"=="5" (
    if %SEND_CONFIRM%==true (
        %Karlsen_Folder%/karlsenwallet.exe send --send-amount %SEND_AMOUNT% /t %SEND_TO%
        pause
    )
)
set SIGN_TRANSACTION=TRANSACTION_ID
if "%U_COMMAND%"=="6" (
    set /p SIGN_TRANSACTION="[7;96m::: INPUT :::[0m Enter Transaction ID to Sign > "
)
if "%U_COMMAND%"=="6" (
    %Karlsen_Folder%/karlsenwallet.exe sign --transaction %SIGN_TRANSACTION%
    pause
)
set PARSE_TRANSACTION=TRANSACTION_ID
if "%U_COMMAND%"=="7" (
    set /p PARSE_TRANSACTION="[7;96m::: INPUT :::[0m Enter Transaction ID to Parse > "
)
if "%U_COMMAND%"=="7" (
    %Karlsen_Folder%/karlsenwallet.exe parse --transaction %PARSE_TRANSACTION%
    pause
)
set BROADCAST_TRANSACTION=TRANSACTION_ID
if "%U_COMMAND%"=="8" (
    set /p BROADCAST_TRANSACTION="[7;96m::: INPUT :::[0m Enter Transaction ID to Broadcast > "
)
if "%U_COMMAND%"=="8" (
    %Karlsen_Folder%/karlsenwallet.exe broadcast --transaction %BROADCAST_TRANSACTION%
    pause
)
set UNSIGNED_SEND_AMOUNT=0
set UNSIGNED_SEND_TO=WALLET_ADDRESS
set UNSIGNED_SEND_CONFIRM=false
if "%U_COMMAND%"=="9" (
    set /p UNSIGNED_SEND_AMOUNT="[7;96m::: INPUT :::[0m Type Amount of Karlsen to Send > "
    set /p UNSIGNED_SEND_TO="[7;96m::: INPUT :::[0m Karlsen Address to Send the coins > "
)
if "%U_COMMAND%"=="9" (
    echo [7;93m::: INFO :::[0m[93m This UnSigned Transaction will send Amount of [0m[96m%UNSIGNED_SEND_AMOUNT%[0m[93m Karlsen to Address: [0m[96m%UNSIGNED_SEND_TO%[0m
    set /p UNSIGNED_SEND_CONFIRM="[7;96m::: INPUT :::[0m Send Y to Confirm UnSigned Karlsen Transaction > "
)
if "%UNSIGNED_SEND_CONFIRM%"=="Y" set UNSIGNED_SEND_CONFIRM=true
if "%UNSIGNED_SEND_CONFIRM%"=="y" set UNSIGNED_SEND_CONFIRM=true
if "%U_COMMAND%"=="9" (
    if %UNSIGNED_SEND_CONFIRM%==true (
        %Karlsen_Folder%/karlsenwallet.exe create-unsigned-transaction --send-amount %UNSIGNED_SEND_AMOUNT% /t %UNSIGNED_SEND_TO%
        pause
    )
)
if "%U_COMMAND%"=="m" set U_COMMAND=M
set MINER_ADDR=WALLET_ADDRESS
set MINER_CONFIRM=false
if "%U_COMMAND%"=="M" (
    set /p MINER_ADDR="[7;96m::: INPUT :::[0m Enter a wallet address you want to mine to > "
)
if "%U_COMMAND%"=="M" (
    echo [7;93m::: INFO :::[0m[93m Starting to Mine Karlsen to Wallet Address: [0m[96m%MINER_ADDR%[0m
    set /p MINER_CONFIRM="[7;96m::: INPUT :::[0m Send Y to Start Mining Karlsen > "
)
if "%MINER_CONFIRM%"=="Y" set MINER_CONFIRM=true
if "%MINER_CONFIRM%"=="y" set MINER_CONFIRM=true
if "%U_COMMAND%"=="M" (
    if %MINER_CONFIRM%==true (
        start cmd /k %Karlsen_Folder%/karlsenminer.exe --miningaddr %MINER_ADDR%
    )
)
if "%U_COMMAND%"=="n" set U_COMMAND=N
if "%U_COMMAND%"=="N" (
    %Karlsen_Folder%/karlsenctl.exe GetInfo
    pause
)
if "%U_COMMAND%"=="b" set U_COMMAND=B
if "%U_COMMAND%"=="B" (
    %Karlsen_Folder%/karlsenctl.exe GetBlockDagInfo
    pause
)
set U_COMMAND=false
call KarlsenControl.cmd
