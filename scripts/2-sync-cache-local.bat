@echo off
REM ============================================================
REM  2-sync-cache-local.bat
REM  A EXECUTER SUR CHAQUE POSTE UTILISATEUR
REM
REM  Role : recopie l'archive depuis le SAN vers un cache local,
REM         place les fichiers en LECTURE SEULE, et laisse a
REM         chaque poste son propre index .msf.
REM         => aucun verrou possible entre les Thunderbird.
REM
REM  Ce script est concu pour etre lance automatiquement par une
REM  tache planifiee (voir 3-installer-tache-planifiee.bat).
REM ============================================================

setlocal enabledelayedexpansion

REM ===== PARAMETRES A ADAPTER (une seule fois) =====

REM Dossier source sur le SAN (archive maitre de la boite a consulter).
REM Mettez ici le sous-dossier SAN de la boite concernee.
set "SOURCE=\\SERVEUR-SAN\Partage\Archives-Mail\prenom.nom"

REM Nom du dossier tel qu'il apparaitra dans Thunderbird,
REM sous "Dossiers locaux".
set "NOM_DOSSIER=Archives-Partagees"

REM =================================================

REM --- Reperage automatique du profil Thunderbird ---
set "TBPROFILE="
for /d %%P in ("%APPDATA%\Thunderbird\Profiles\*.default-release") do set "TBPROFILE=%%P"
if not defined TBPROFILE for /d %%P in ("%APPDATA%\Thunderbird\Profiles\*.default") do set "TBPROFILE=%%P"
if not defined TBPROFILE (
  echo ERREUR : profil Thunderbird introuvable. & exit /b 1
)

set "LOCALROOT=%TBPROFILE%\Mail\Local Folders"
set "CACHE=%LOCALROOT%\%NOM_DOSSIER%.sbd"
set "LOG=%LOCALAPPDATA%\Archives-Mail-sync.log"

echo [%DATE% %TIME%] Debut de la synchronisation>>"%LOG%"

REM --- Creation du conteneur visible dans Thunderbird ---
if not exist "%LOCALROOT%" mkdir "%LOCALROOT%"
if not exist "%CACHE%" mkdir "%CACHE%"
REM Fichier "conteneur" (mbox vide) pour que le dossier soit visible
if not exist "%LOCALROOT%\%NOM_DOSSIER%" type nul > "%LOCALROOT%\%NOM_DOSSIER%"

REM --- Liberation des attributs avant copie (evite tout blocage) ---
attrib -R "%CACHE%\*" /S /D >nul 2>&1

REM --- Copie incrementale depuis le SAN ---
REM   /MIR     : reproduit la source (ajouts + suppressions)
REM   /XF *.msf: on NE touche PAS aux index locaux de Thunderbird
robocopy "%SOURCE%" "%CACHE%" /MIR /XF *.msf /R:2 /W:5 /NFL /NDL /NP /LOG+:"%LOG%"

REM --- Passage des archives en LECTURE SEULE (sauf les index .msf) ---
for /R "%CACHE%" %%F in (*) do @if /I not "%%~xF"==".msf" attrib +R "%%F" >nul 2>&1

echo [%DATE% %TIME%] Synchronisation terminee>>"%LOG%"
endlocal
exit /b 0
