# Ship - choregraphie de livraison

Reference appelee par le skill `autoship`. Hypothese : build et tests verts,
travail sur la branche `autoship/<slug>`.

## 0. Atterrissage

Classer les zones touchees par le diff branche vs base :

- DB : migrations, schemas SQL, `schema.prisma`, changements de modele
  persistants.
- Auth/secrets : auth, permissions, `.env*`, secrets, paiement.
- CI-CD/infra : `.github/workflows/**`, `Dockerfile`, `docker-compose*`,
  scripts de deploiement, IaC.

Aucune zone sensible et aucun gate degrade : atterrissage auto.

Zone sensible ou gate degrade : PR prete, stop avant merge/deploy.

La taille du diff ne choisit pas l'atterrissage; elle est seulement signalee dans
le rapport.

## 1. Commit Et PR

1. Commit conventionnel : `<type>(<scope>): <raison courte>`.
2. `git push -u origin autoship/<slug>`.
3. `gh pr create --fill --base <branche-par-defaut>`.

Si `gh` n'est pas authentifie ou si le remote n'existe pas, stopper proprement
avec branche locale et rapport.

## 2. CI De PR

1. Suivre la CI avec `gh pr checks --watch` ou `gh run watch <run-id>`.
2. CI verte + atterrissage PR prete : stop ici, PR laissee pour revue.
3. CI verte + atterrissage auto : continuer.
4. CI rouge : diagnostiquer avec `gh run view <id> --log-failed`, corriger,
   recommit, repush. Borne : 3 tentatives.
5. Toujours rouge apres 3 tentatives : convertir en draft si possible, laisser
   branche + PR en place, rapport.

## 3. Merge Et Surveillance

Uniquement en atterrissage auto.

1. `gh pr merge --squash --delete-branch`.
2. Surveiller le run sur la branche par defaut.
3. Si une cible staging existe : deployer staging, verifier le healthcheck, puis
   promouvoir vers prod et verifier prod.
4. Si aucun staging n'existe : deployer prod directement et signaler ce risque
   dans le rapport.
5. Main CI verte + healthcheck OK : succes.
6. Main CI rouge ou healthcheck KO : auto-correction post-merge.

## 4. Auto-Correction Post-Merge

Boucle bornee a 3 iterations :

1. Diagnostiquer CI main ou logs de deploiement.
2. Creer une branche `autoship/<slug>-fix-<n>`.
3. Corriger avec tests si pertinent.
4. Creer PR, attendre CI verte, merge squash.
5. Surveiller main + deploiement.

Si main/prod restent casses apres 3 iterations, tenter un revert via PR :

1. Identifier les commits introduits par ce run.
2. Creer `autoship/<slug>-revert`.
3. `git revert --no-edit <sha>` du plus recent au plus ancien si necessaire.
4. PR, CI, merge squash, redeploiement, healthcheck.

Si le revert restaure l'etat sain, rapporter un succes degrade : la feature n'est
pas livree, mais l'etat sain est restaure.

Si le revert echoue, stopper et escalader explicitement.
