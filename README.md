# Archives Mail Thunderbird — Distribution

Outils et procédure pour **décharger des boîtes mail saturées** (jusqu'à ~80 Go)
vers une **archive partagée sur le SAN**, consultable par plusieurs personnes
**sans risque de verrou ni de corruption**.

Le principe : on archive par année-mois sur un poste central, on pousse les
fichiers sur le SAN (archive « maître », jamais modifiée), puis chaque poste
utilisateur recopie l'archive dans un **cache local en lecture seule**. Deux
Thunderbird n'ouvrent ainsi jamais le même fichier → aucun verrou possible.

👉 **Procédure complète : [MODE-OPERATOIRE.md](MODE-OPERATOIRE.md)**

## Structure du dépôt

| Dossier / fichier      | Contenu                                                                 |
|------------------------|-------------------------------------------------------------------------|
| `MODE-OPERATOIRE.md`   | Procédure pas-à-pas (poste central, postes utilisateurs, dépannage)     |
| `Note-de-cadrage.docx` | Note de cadrage du projet                                               |
| `scripts/`             | Scripts Windows `.bat` (push vers SAN, synchro cache local, tâche planifiée) |
| `schemas/`             | Schémas d'architecture et de processus (`drawio/` sources, `png/` rendus) |
| `private/`             | Sorties locales sensibles — **ignoré par git** (voir `private/README.md`) |

## Scripts (`scripts/`)

> Les scripts contiennent des **placeholders** à adapter une seule fois
> (`\\SERVEUR-SAN\...`, `prenom.nom`). Aucune valeur réelle n'est versionnée.

| Script                              | Rôle                                                       |
|-------------------------------------|------------------------------------------------------------|
| `1-push-archives-vers-san.bat`      | Poste central : envoie les archives Thunderbird vers le SAN |
| `2-sync-cache-local.bat`            | Poste utilisateur : recopie l'archive du SAN en cache local |
| `3-installer-tache-planifiee.bat`   | Installe la synchro automatique (tâche planifiée Windows)   |

## Hygiène du dépôt

- `.gitignore` durci : `private/`, secrets (`.env`, clés, `*.pem`…), fichiers OS
  (`.DS_Store`, `Thumbs.db`), journaux `*.log`.
- Anti-fuite **local et bloquant** : hook pre-commit
  [gitleaks](https://github.com/gitleaks/gitleaks) (`.pre-commit-config.yaml`).
  Installation : `pre-commit install`. Un commit contenant un secret est refusé.
