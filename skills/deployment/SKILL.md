---
name: deployment
description: "Conventions de deploiement de Cyril : CI/CD GitHub Actions, gh CLI, Docker Compose, serveurs Debian/Ubuntu, Postgres. Utiliser pour deployer, ecrire un workflow CI/CD, ou diagnostiquer un deploiement."
---

# Deployment

CI/CD par defaut : GitHub Actions. Cibles : VPS, serveurs dedies ou NAS maison,
tous Debian/Ubuntu. Packaging : Docker + Docker Compose. Base de donnees :
PostgreSQL.

## Outils

- `gh` pour piloter GitHub Actions depuis le terminal.
- `docker compose` v2, sans tiret.
- Ansible pour la configuration des serveurs quand le projet en dispose.

```bash
gh workflow run <workflow>
gh run list --workflow=<wf>
gh run watch
gh run view <id> --log-failed
```

## Priorites

1. Reproductibilite : le deploiement part de l'etat du repo.
2. Migrations DB versionnees, jouees avant ou avec le deploiement du code.
3. Secrets hors du repo : GitHub Actions secrets en CI, `.env` non versionne cote serveur.
4. Healthcheck apres deploiement.

## Regles

- Pipeline GitHub Actions : lint + tests + build avant tout deploiement.
- Image Docker taguee par SHA de commit; jamais `latest` en production.
- `docker-compose.yml` versionne; override prod separe si necessaire.
- Rollback = redeployer le tag precedent; conserver les N dernieres images.
- Postgres : volume nomme persistant, jamais dans le conteneur applicatif.
- Pas de livraison par `ssh` + commande manuelle hors incident explicite.

Verifier le run et le healthcheck avant de declarer un deploiement reussi.
