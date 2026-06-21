---
name: autoship
description: Produire une petite feature/fix en autonomie totale : cartographie, plan, build, review, verification comportementale, doc et livraison. Utiliser seulement quand l'utilisateur demande explicitement autoship, fire-and-forget, ou une livraison autonome a faible risque.
---

# Autoship

Production autonome d'une petite feature ou d'un fix a faible risque de
regression. Mode fire-and-forget : pas de pause pour validation humaine apres le
lancement explicite par l'utilisateur.

L'etat terminal doit toujours etre clair :

- livre : merge/deploiement fait et verifie ;
- PR prete : branche poussee, PR verte, stop avant merge/deploy ;
- WIP : build ou tests toujours KO apres retries bornes ;
- bloque : cause externe precise.

## Principe

Orchestrer les briques existantes, pas reinventer le workflow du projet. Retries
bornes a 3 par phase. Toute condition risquee degrade vers une PR prete ou un
WIP documente, jamais vers une question en plein run.

## Phase 0 - Preflight

1. Lire les conventions du projet : `AGENTS.md`, README, docs, manifestes
   (`pyproject.toml`, `package.json`, `Cargo.toml`), workflows GitHub Actions.
2. Etablir explicitement les commandes de test, lint, build, workflow CI et cible
   de deploiement si elle existe.
3. Verifier l'etat git. Si le worktree contient des changements non lies,
   travailler autour sans les revert; si l'isolement est impossible, stopper avec
   rapport avant modification.
4. Creer une branche `autoship/<slug>` depuis la branche par defaut a jour.
5. Si aucune commande de test fiable n'existe, ne pas modifier le code; produire
   un rapport.

## Phase 1 - Map

Comprendre le code utile a la tache : zones impactees, contrats, tests existants,
chemins d'execution. Garder le contexte cible.

## Phase 2 - Plan

Produire un plan court et interne, calibre pour une petite feature/fix. Le plan
sert a executer, pas a demander validation.

## Phase 3 - Build Loop

Pour chaque tranche :

1. Ajouter ou ajuster le test qui couvre le comportement quand c'est praticable.
2. Implementer le minimum.
3. Lancer lint/tests/build pertinents.
4. Corriger jusqu'a vert ou jusqu'a 3 tentatives.

Faire ensuite une review du diff complet : bugs, regressions, erreurs de contrat,
tests manquants, simplification possible. Corriger puis re-verifier.

## Phase 3bis - Spec Gate

Comparer le diff a la demande initiale. Verifier que les criteres d'acceptation
et edge cases evidents sont couverts. Si ecart : rework borne a 3 tentatives,
puis degrade vers PR prete avec raison `spec-gate`.

## Phase 3ter - Verification Comportementale

Les tests verts ne suffisent pas. Observer le comportement reel attendu :
lancer l'app si necessaire, appeler l'endpoint, executer le flux CLI, ou verifier
l'UI avec Playwright quand le projet s'y prete.

Si KO : rework borne a 3 tentatives, puis degrade vers PR prete avec raison
`verify`.

## Phase 4 - Doc

Mettre a jour README, docs ou changelog seulement si le changement le justifie.
Pas de documentation decorative.

## Phase 5 - Ship

Suivre `references/ship.md`. Le choix d'atterrissage depend du risque :

- auto : aucune zone sensible, gates verts ;
- PR prete : DB, auth/secrets, CI-CD/infra, gate degrade ou doute significatif.

## Garde-Fous

- Pas de boucle infinie.
- Pas de `--no-verify`, pas de force push.
- Historique lineaire : rebase/squash.
- Conventional Commits.
- Etat laisse explicite : branche, PR, commit, verification, cause d'arret.

## Rapport Final

Toujours produire :

- Tache.
- Statut : livre, PR prete, WIP, bloque.
- Fait : phases franchies, branche, PR, commits.
- Verifications lancees et resultat.
- Cause precise si degrade.
- Action manuelle requise, le cas echeant.
