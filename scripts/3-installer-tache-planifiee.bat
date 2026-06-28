@echo off
REM ============================================================
REM  3-installer-tache-planifiee.bat
REM  A EXECUTER UNE SEULE FOIS PAR POSTE UTILISATEUR
REM
REM  Role : programme la synchronisation automatique du cache
REM         - chaque jour a 07h30
REM         - et a chaque ouverture de session
REM
REM  Placez ce fichier dans le MEME dossier que
REM  "2-sync-cache-local.bat".
REM ============================================================

set "SCRIPT=%~dp02-sync-cache-local.bat"

if not exist "%SCRIPT%" (
  echo ERREUR : "2-sync-cache-local.bat" est introuvable a cote de ce fichier.
  pause
  exit /b 1
)

schtasks /Create /TN "DTNUM - Sync Archives Mail (quotidien)" /TR "\"%SCRIPT%\"" /SC DAILY /ST 07:30 /RL LIMITED /F
schtasks /Create /TN "DTNUM - Sync Archives Mail (session)"   /TR "\"%SCRIPT%\"" /SC ONLOGON /RL LIMITED /F

echo.
echo === Taches planifiees creees ===
echo La synchronisation se lancera automatiquement.
echo Vous pouvez aussi lancer "2-sync-cache-local.bat" manuellement a tout moment.
echo.
pause
