@echo off
REM ============================================================
REM  1-push-archives-vers-san.bat
REM  A EXECUTER SUR LE POSTE "MAIL" (poste d'archivage central)
REM
REM  Role : envoie les fichiers d'archive du profil Thunderbird
REM         vers le repertoire partage du SAN (archive maitre).
REM
REM  IMPORTANT : FERMER THUNDERBIRD avant de lancer ce script,
REM  sinon les fichiers sont verrouilles et la copie echoue.
REM ============================================================

setlocal enabledelayedexpansion

REM ===== PARAMETRES A ADAPTER (a faire une seule fois) =====

REM Nom de la boite : sert de sous-dossier sur le SAN.
REM Exemple : prenom.nom
set "BOITE=prenom.nom"

REM Nom du dossier d'archive dans Thunderbird.
REM "Archives" = dossier cree par la fonction Archiver de Thunderbird.
set "DOSSIER_TB=Archives"

REM Repertoire partage SAN (archive maitre, lecture seule pour les autres).
set "DEST=\\SERVEUR-SAN\Partage\Archives-Mail\%BOITE%"

REM =========================================================

echo.
echo === Envoi des archives de la boite "%BOITE%" vers le SAN ===
echo.

REM --- Reperage automatique du profil Thunderbird ---
set "TBPROFILE="
for /d %%P in ("%APPDATA%\Thunderbird\Profiles\*.default-release") do set "TBPROFILE=%%P"
if not defined TBPROFILE for /d %%P in ("%APPDATA%\Thunderbird\Profiles\*.default") do set "TBPROFILE=%%P"
if not defined TBPROFILE (
  echo ERREUR : profil Thunderbird introuvable.
  echo Verifiez que Thunderbird est bien installe pour cet utilisateur.
  pause
  exit /b 1
)

set "SOURCE=%TBPROFILE%\Mail\Local Folders\%DOSSIER_TB%.sbd"

if not exist "%SOURCE%" (
  echo ERREUR : le dossier d'archive est introuvable :
  echo   %SOURCE%
  echo Avez-vous bien archive des messages dans Thunderbird ?
  pause
  exit /b 1
)

REM --- Creation du dossier destination sur le SAN si absent ---
if not exist "%DEST%" mkdir "%DEST%"

REM --- Copie miroir vers le SAN ---
REM   /MIR     : reproduit la source (ajouts + suppressions)
REM   /XF *.msf: on n'envoie PAS les index (ils sont locaux a chaque poste)
REM   /R:2 /W:5: 2 essais, 5 s d'attente si un fichier est occupe
robocopy "%SOURCE%" "%DEST%" /MIR /XF *.msf /R:2 /W:5 /NP /LOG+:"%DEST%\_journal-push.log"

echo.
echo === Termine ===
echo Journal de la copie : %DEST%\_journal-push.log
echo.
pause
endlocal
