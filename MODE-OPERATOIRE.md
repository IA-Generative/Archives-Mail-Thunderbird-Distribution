# Mode opératoire — Archives mail partagées (Thunderbird)

**Objectif** : décharger les boîtes saturées (jusqu'à 80 Go) vers une archive partagée sur le SAN, consultable par plusieurs personnes **sans risque de verrou ni de corruption**.

---

## Comment ça marche (en une minute)

1. Sur un **poste central « mail »**, on archive les anciens messages d'une boîte. Thunderbird les range automatiquement **par année-mois** et les retire du serveur (la boîte se vide).
2. Ces fichiers d'archive sont **poussés sur le SAN** (l'archive « maître », qu'on ne modifie plus).
3. Sur **chaque poste utilisateur**, un script recopie l'archive dans un **cache local en lecture seule**. Thunderbird lit ce cache.

**Pourquoi aucun verrou n'est possible :** deux Thunderbird n'ouvrent **jamais** le même fichier. Chacun a sa propre copie locale et son propre index. Le SAN ne sert qu'à distribuer.

**Pourquoi la synchro est rapide :** une fois un mois écoulé, son fichier ne change plus jamais. Seul le mois en cours est recopié à chaque synchro — l'historique ne retransite pas.

---

## Partie 1 — Poste central « mail » (archivage + envoi sur le SAN)

> À faire par la personne en charge de l'archivage, **une boîte à la fois**.

### 1.1 Préparer Thunderbird pour archiver par année-mois (à faire une fois par boîte)

1. Ouvrir Thunderbird, connecter la boîte concernée.
2. Menu **☰ → Paramètres des comptes** → sélectionner le compte → **Copies et dossiers**.
3. Section **Archives** : cocher **« Conserver les archives de messages dans »** et choisir **Dossiers locaux**.
4. Cliquer sur **Options d'archivage…** → choisir **« Archives mensuelles »** (un dossier par mois). Valider.

### 1.2 Décharger les anciens messages (vide le serveur)

> ⚠️ **À vérifier d'abord si la boîte est en IMAP.** Avant d'archiver vers les *Dossiers locaux*, il faut que les messages soient **téléchargés en entier** sur le poste. Sinon Thunderbird n'archive que les **en-têtes** : les messages quittent le serveur **sans copie complète locale** → perte de contenu.
> Pour forcer le téléchargement : **☰ → Paramètres des comptes → Synchronisation et espace disque** → cocher **« Conserver les messages… sur cet ordinateur »**, puis laisser Thunderbird se synchroniser complètement (compteur de téléchargement à zéro) avant d'archiver. *(En POP, les messages sont déjà en local : rien à faire.)*

1. Ouvrir le dossier de la boîte (ex. *Courrier entrant*).
2. Sélectionner les messages anciens à archiver (ex. tout ce qui est antérieur à l'année en cours) :
   - clic sur le 1er message, puis **Maj + clic** sur le dernier ;
   - ou **Ctrl + A** pour tout sélectionner.
3. Appuyer sur la touche **A** (Archiver), ou clic droit → **Archiver**.
4. Thunderbird déplace les messages dans **Dossiers locaux → Archives**, classés par année-mois, **et les retire du serveur**. La boîte se vide d'autant.

> 💡 Pour récupérer la place côté serveur, pensez à vider/compacter la Corbeille du compte après l'archivage.

### 1.3 Sélectionner précisément les messages de plus de 3, 6 ou 12 mois

Plutôt que de sélectionner « à l'œil », on cible les messages par **ancienneté**.
L'action **Archiver** (touche **A**) range ensuite ces messages dans
**Dossiers locaux → Archives** par année-mois (réglages de l'étape 1.1) et les
retire du serveur — exactement comme au 1.2.

**Seuils de référence :** 3 mois ≈ **90 jours** · 6 mois ≈ **180 jours** · 1 an = **365 jours**.

#### Méthode A — Recherche par ancienneté *(recommandée, précise)*

1. **Clic droit** sur le dossier à traiter (ex. *Courrier entrant*) →
   **Rechercher des messages…** *(raccourci **Ctrl+Maj+F**)*.
   Sur les branches anciennes : **Édition → Rechercher → Rechercher des messages…**.
2. En haut, vérifier le **dossier** ciblé (cocher *Inclure les sous-dossiers* si besoin).
3. Régler le critère **(deux possibilités selon la version)** :
   - **Versions récentes :** **« Ancienneté en jours »** → **« est supérieure à »** →
     seuil voulu (**90**, **180** ou **365**).
   - **Branches anciennes (31–45) :** le critère « Ancienneté en jours » **n'existe
     pas** dans la fenêtre de recherche → utiliser **« Date »** → **« est avant le »**
     → saisir la **date butoir** (= aujourd'hui moins 3, 6 ou 12 mois). Cette
     variante par date **fonctionne sur toutes les versions**.

   > 💡 La date fixe est figée : elle ne « bouge » pas dans le temps, contrairement
   > à l'ancienneté en jours. Pour un archivage récurrent sur version ancienne,
   > recalculer la date à chaque passage (ou utiliser la **méthode B**).
   >
   > 🛠️ Pour ne pas calculer à la main, double-cliquer sur
   > **`scripts/aide-dates-archivage.bat`** : il affiche les dates butoir
   > « il y a 3 / 6 / 12 mois » à recopier dans le champ « est avant le ».
   > *(Il n'archive rien — il calcule seulement les dates.)*
4. Cliquer **Rechercher**.
5. Dans la liste de résultats : **Ctrl+A** pour tout sélectionner, puis touche **A**
   (Archiver) — ou clic droit → **Archiver**.

#### Méthode B — Tri par date dans la liste *(sans recherche)*

1. Dans le dossier, cliquer sur l'en-tête de colonne **Date** pour trier du plus
   récent au plus ancien.
2. Repérer la limite (3 / 6 / 12 mois), cliquer le **1er** message à archiver,
   puis **Maj + clic** sur le **dernier** (le plus ancien) pour sélectionner toute la plage.
3. Touche **A** (Archiver).

#### Pour répéter l'opération (archivage récurrent)

Dans la fenêtre de recherche (méthode A), le bouton
**« Enregistrer comme dossier de recherche »** crée un **dossier virtuel**
(ex. *« Plus de 6 mois »*) qui se met à jour tout seul au fil du temps. Il suffit
d'y revenir périodiquement et de faire **Ctrl+A → A**.

> ⚠️ **Avant d'archiver, deux rappels :**
> - En **IMAP**, s'assurer que les messages sont **téléchargés en entier** (voir
>   l'avertissement du 1.2), sinon seuls les en-têtes sont archivés → perte de contenu.
> - L'archivage doit être réglé en **mensuel** (étape 1.1) pour bénéficier de la
>   synchro incrémentale (seul le mois en cours retransite ensuite).

### 1.4 Envoyer l'archive sur le SAN

1. **Fermer complètement Thunderbird** (obligatoire : sinon les fichiers sont verrouillés).
2. Ouvrir le fichier **`1-push-archives-vers-san.bat`** avec **clic droit → Modifier**, et renseigner en haut :
   - `BOITE` = identifiant de la boîte (ex. `prenom.nom`) — ce sera son dossier sur le SAN ;
   - `DEST` = chemin du partage SAN (ex. `\\SERVEUR-SAN\Partage\Archives-Mail\%BOITE%`).
3. Enregistrer, puis **double-cliquer** sur `1-push-archives-vers-san.bat`.
4. Le script copie l'archive vers le SAN et écrit un journal `_journal-push.log` dans le dossier de destination.

> Pour une nouvelle boîte : on recommence en 1.1 (changer `BOITE`). On peut renommer le dossier *Archives* entre deux boîtes, ou utiliser un profil Thunderbird distinct par boîte.

---

## Partie 2 — Poste utilisateur (consultation en lecture seule)

> À faire sur chaque poste qui doit **consulter** une archive. Aucun logiciel à installer : tout est natif Windows.

### 2.1 Mise en place (une seule fois par poste)

1. Copier les fichiers **`2-sync-cache-local.bat`** et **`3-installer-tache-planifiee.bat`** dans un même dossier local, par exemple `C:\Outils\`.
2. Ouvrir **`2-sync-cache-local.bat`** avec **clic droit → Modifier** et renseigner en haut :
   - `SOURCE` = sous-dossier SAN de la boîte à consulter (ex. `\\SERVEUR-SAN\Partage\Archives-Mail\prenom.nom`) ;
   - `NOM_DOSSIER` = nom affiché dans Thunderbird (par défaut `Archives-Partagees`).
3. Enregistrer.
4. Double-cliquer sur **`3-installer-tache-planifiee.bat`** : la synchro devient automatique (chaque jour + à l'ouverture de session).
5. Lancer une 1re synchro tout de suite en double-cliquant sur **`2-sync-cache-local.bat`** (la 1re copie peut être longue selon la taille).

### 2.2 Voir les archives dans Thunderbird

1. Ouvrir (ou redémarrer) Thunderbird.
2. Sous **Dossiers locaux**, un dossier **Archives-Partagees** apparaît, avec les sous-dossiers par année-mois, **en lecture seule**.

> Après chaque synchro, **redémarrer Thunderbird** pour voir le mois le plus récent. Un dossier qui semble vide ? Clic droit → **Propriétés → Réparer le dossier** (reconstruit l'index local).

---

## Dépannage rapide

| Symptôme | Cause probable | Solution |
|---|---|---|
| La copie échoue côté central | Thunderbird est resté ouvert | Fermer Thunderbird, relancer le `.bat` |
| Le dossier n'apparaît pas | Thunderbird pas redémarré | Fermer/rouvrir Thunderbird |
| Un dossier semble vide | Index pas encore construit | Clic droit → Propriétés → **Réparer le dossier** |
| « Accès refusé » sur le SAN | Droits manquants | Vérifier les permissions du partage avec l'admin |
| Synchro très longue à chaque fois | Archives en un seul gros fichier | Vérifier que l'archivage est bien en **mensuel** (étape 1.1) |

---

## Notes techniques

- **Lecture seule** : les fichiers d'archive sont passés en lecture seule sur les postes. Thunderbird peut donc les **lire** mais pas les modifier — c'est voulu (intégrité de l'archive). Les index `.msf` restent, eux, modifiables localement.
- **Aucun verrou inter-postes** : chaque poste lit sa propre copie locale et possède son propre index. Le format mbox de Thunderbird ne supporte pas l'accès concurrent à un même fichier ; cette architecture l'évite totalement.
- **Outils utilisés** : tous natifs Windows (`robocopy`, `attrib`, `schtasks`). Rien à installer côté postes utilisateurs.
- **Compatibilité des versions** : le dispositif fonctionne de **Thunderbird 31.7.0 jusqu'aux branches actuelles (140 et au-delà)**. Le format mbox, l'arborescence du profil et l'archivage natif par année-mois sont identiques sur toute cette plage, et **mbox reste le format de stockage par défaut** sur les versions récentes. Un **parc mélangeant plusieurs versions est supporté** (chaque poste lit sa propre copie locale). L'**obsolescence** des versions anciennes est **connue et assumée** : elle n'affecte pas le fonctionnement du dispositif.
- **Équivalences d'interface** : sur les branches anciennes (31–45), utiliser la barre de menus **Outils → Paramètres des comptes** ; l'onglet de téléchargement IMAP hors-ligne peut s'appeler **« Synchronisation et stockage »** (au lieu de « …espace disque »). Sur les versions récentes, passer par **☰ → Paramètres**. Réglages et emplacements de fichiers restent identiques.
- **Add-on** : ImportExportTools **NG** exige TB 68+ ; il n'est **pas requis** ici (archivage natif). Sur les branches anciennes, c'est l'add-on *ImportExportTools « classique »* qui conviendrait, si jamais besoin.
