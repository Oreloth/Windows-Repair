@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
title R‚paration de Windows
:menu
cls
color 03
echo                   ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo                   º      R‚paration de Windows         º
echo                   º             © Oreloth              º
echo                   ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
echo.
echo 1) Lancer la r‚paration de Windows
echo 2) Lancer la r‚paration du disque dur
echo 3) Quitter le programme
choice /c:123
if %ERRORLEVEL% ==1 goto sys
if %ERRORLEVEL% ==2 goto disk
if %ERRORLEVEL% == 3 goto exit
REM Réparation du système
:sys
color 04
echo Nettoyage des fichiers temporaires en cours...
del /q /f /s "%TEMP%\*.*"
echo Fichiers temporaires supprim‚s.
echo.
echo Suppression des fichiers temporaires dans le dossier Temporary Internet Files...
del /q /f /s "%USERPROFILE%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
echo Fichiers temporaires dans le dossier Temporary Internet Files supprimés.
echo.
echo Suppression des fichiers temporaires dans le dossier Windows...
takeown /f "%windir%\Temp" /r /d y >nul 2>&1
icacls "%windir%\Temp" /grant:r %username%:(OI)(CI)F /t >nul 2>&1
del /q /f /s "%windir%\Temp\*.*"
echo Fichiers temporaires dans le dossier Windows supprim‚s.
echo.
echo Nettoyage termin‚.
echo Pr‚paration de la r‚paration de votre systŠme...
ping localhost -n 2 >nul
Dism /Online /Cleanup-Image /RestoreHealth
sfc /scannow
echo.
echo R‚paration du Microsoft Store, veuillez patienter...
wsreset
color 02
echo R‚paration de Windows Termin‚e
pause
goto menu
REM Réparation du disque dur
:disk
echo.
echo La r‚paration du disque dur peut prendre plusieurs heures et votre
echo ordinateur ne sera pas utilisable pendant la r‚paration.
echo Il est conseill‚ de la passer si vous n'ˆtes pas s–r.
echo.
echo Que voulez-vous faire ?
echo.
echo 1) Lancer la r‚paration du disque dur
echo 2) Annuler la r‚paration du disque dur
choice /c:12
if %ERRORLEVEL% ==1 goto chk
if %ERRORLEVEL% ==2 goto passed
:chk
REM Afficher la liste des lecteurs disponibles
echo Liste des disques durs disponibles :
echo ----------------------------------
echo.
for %%A in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%A:\" echo %%A
)
echo.

REM Demander à l'utilisateur de choisir un lecteur
set /p drive="Choisir le disque dur, n'oubliez pas le deux-points (ex: C:) : "

REM Vérifier si le lecteur existe
if not exist "%drive%\" (
    echo Le disque dur %drive% n'existe pas.
    pause
    exit /b
)

REM Exécuter chkdsk sur le lecteur choisi
echo Ex‚cution de chkdsk sur %drive%...
echo -----------------------------------
echo.
chkdsk %drive% /F /R
echo.
echo Veuillez red‚marrer Windows pour terminer.
echo Voulez-vous red‚marrer maintenant ?
echo (La r‚paration peut durer plusieurs heures.)
echo.
echo 1) Red‚marrer maintenant
echo 2) Red‚marrer plus tard
choice /c:12
if %ERRORLEVEL% ==1 goto reboot
if %ERRORLEVEL% ==2 goto passed
:reboot
shutdown -r -t 1
echo Windows va red‚marrer.
pause
:passed
goto menu
:exit
exit
