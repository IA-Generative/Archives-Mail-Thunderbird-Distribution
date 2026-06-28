@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM  5-installer-thunderbird-moderne.bat
REM  A EXECUTER EN ADMINISTRATEUR, sur le POSTE CENTRAL d'archivage.
REM
REM  Role : installer une version MODERNE de Thunderbird (canal ESR)
REM         pour pouvoir AUTOMATISER l'archivage par anciennete via un
REM         module d'auto-archivage (ex. AutoarchiveReloaded), qui
REM         declenche l'archivage NATIF et conserve donc le classement
REM         annee-mois (indispensable a la synchro incrementale).
REM
REM  Ce script :
REM    1) telecharge l'installeur Thunderbird ESR (win64, francais) ;
REM    2) l'installe en mode silencieux ;
REM    3) rappelle la marche a suivre pour le module d'archivage.
REM
REM  NB : la version 31.x ne sait PAS automatiser l'archivage.
REM       Reservez-la aux postes de CONSULTATION (lecture seule).
REM ============================================================

REM ===== PARAMETRES =====
set "LANGUE=fr"
REM Canal : "thunderbird-esr-latest-ssl" (ESR, recommande parc gere)
REM         "thunderbird-latest-ssl"     (version courante)
set "PRODUCT=thunderbird-esr-latest-ssl"
set "FALLBACK=thunderbird-latest-ssl"
set "SETUP=%TEMP%\thunderbird-setup.exe"
REM ======================

echo.
echo === Telechargement de Thunderbird (%PRODUCT%, %LANGUE%, win64) ===
curl -L -f -o "%SETUP%" "https://download.mozilla.org/?product=%PRODUCT%&os=win64&lang=%LANGUE%"
if errorlevel 1 (
  echo Canal ESR indisponible, bascule sur le canal "%FALLBACK%"...
  curl -L -f -o "%SETUP%" "https://download.mozilla.org/?product=%FALLBACK%&os=win64&lang=%LANGUE%"
)
if not exist "%SETUP%" (
  echo ERREUR : telechargement impossible. Verifiez la connexion ou le proxy.
  pause
  exit /b 1
)

echo.
echo === Installation silencieuse (necessite les droits administrateur) ===
"%SETUP%" /S
echo Installation lancee. Si rien ne se passe, relancez ce script via
echo "Executer en tant qu'administrateur".

echo.
echo === ETAPE SUIVANTE : module d'archivage automatique ===
echo  1) Ouvrir Thunderbird, menu Modules complementaires et themes.
echo  2) Rechercher AutoarchiveReloaded (ou un module equivalent maintenu),
echo     VERIFIER la compatibilite avec la version installee, puis installer.
echo  3) Configurer : archiver les messages de plus de 90 / 180 / 365 jours,
echo     et activer le declenchement au demarrage de Thunderbird.
echo  4) Verifier que l'archivage est MENSUEL (Parametres des comptes,
echo     Copies et dossiers, Options d'archivage).
echo.
echo  Deploiement en parc : voir scripts\policies.json.exemple
echo  (installation forcee du module via une strategie d'entreprise).
echo.
pause
endlocal
