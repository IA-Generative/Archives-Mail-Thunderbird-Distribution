@echo off
REM ============================================================
REM  aide-dates-archivage.bat
REM  AIDE A L'ARCHIVAGE MANUEL (utile sur Thunderbird 31.x-45,
REM  ou le critere "Anciennete en jours" n'existe pas).
REM
REM  Role : calcule les DATES BUTOIR "il y a 3 / 6 / 12 mois"
REM         a saisir dans Thunderbird :
REM           Rechercher des messages -> critere Date
REM           -> "est avant le" -> [date affichee ici]
REM
REM  N'ARCHIVE RIEN : ce script ne fait qu'afficher les dates.
REM  L'archivage reste manuel (Ctrl+A sur les resultats, puis A).
REM
REM  Utilise PowerShell (present sur tout Windows) pour un calcul
REM  de date fiable, independant de la locale.
REM ============================================================

powershell -NoProfile -ExecutionPolicy Bypass -Command "$d=Get-Date; Write-Host ''; Write-Host ('  Aujourd''hui : ' + $d.ToString('dddd dd MMMM yyyy')) -ForegroundColor Cyan; Write-Host ''; Write-Host '  Dans Thunderbird : clic droit sur le dossier -> Rechercher des messages...'; Write-Host '  Critere : Date  ->  est avant le  ->  saisir la date ci-dessous,'; Write-Host '  puis Ctrl+A sur les resultats et touche A (Archiver).'; Write-Host ''; Write-Host '  --------------------------------------------------------------'; @(@('Plus de 3 mois',3,90),@('Plus de 6 mois',6,180),@('Plus d''un an  ',12,365)) | ForEach-Object { Write-Host ('    {0}   (~{1,3} j)   ->   est avant le   {2}' -f $_[0],$_[2],$d.AddMonths(-$_[1]).ToString('dd/MM/yyyy')) -ForegroundColor Green }; Write-Host '  --------------------------------------------------------------'; Write-Host ''; Write-Host '  Astuce : une date fixe ne bouge pas dans le temps. Relancez ce'; Write-Host '  script a chaque session d''archivage pour des dates a jour.'; Write-Host ''"

pause
