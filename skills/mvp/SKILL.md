---
name: mvp
description: Creer un MVP ou POC rapidement avec les stacks preferees de Cyril. Eviter les choix par defaut inadaptes comme Next.js sans besoin SSR, npm/yarn/pnpm/node, SQLite en prod ou pip install direct.
---

# MVP / POC — Stacks et conventions

Utiliser ce skill quand on demarre un nouveau projet de zero : MVP, POC,
prototype ou side project.

## Choix de stack

### API seule

FastAPI + Python 3.12 :

- Gestion deps/envs : `uv`.
- ORM : SQLAlchemy async.
- Migrations : Alembic.
- Tests : pytest.
- Lint/format/types : `ruff`, `mypy`.
- DB : PostgreSQL via `docker-compose.yml`.
- Structure attendue : `src/<app>/main.py`, `models.py`, `schemas.py`,
  `database.py`, `routers/`, `tests/`.
- Auth : JWT si utile au POC, sinon pas d'auth artificielle.

### Web app complete a UI non critique

FastAPI + Svelte + Vite :

- `backend/` en FastAPI.
- `frontend/` en Svelte + Vite.
- Bun uniquement cote frontend : `bun install`, `bun run dev`, `bun test`.
- Pas de SvelteKit sauf besoin explicite de routing/SSR produit.
- `docker-compose.yml` avec backend, frontend et Postgres si DB requise.

### Full JS si impose

React + Express + Bun :

- Monorepo Bun workspaces.
- Prisma pour l'ORM.
- Biome pour lint + format.
- Pas de `npm`, `pnpm`, `yarn` ou `node` sauf contrainte projet explicite.

### CLI seule

Python + Typer :

- `typer` pour l'interface CLI.
- `rich` pour les sorties humaines.
- JSON sur stdout pour les sorties machine.
- Erreurs sur stderr et exit codes propres.
- `--help` exploitable par un agent.

## Base De Donnees

- PostgreSQL par defaut; SQLite seulement si contrainte explicite.
- Migrations : Alembic cote FastAPI, Prisma migrate cote TypeScript.
- Volume Docker nomme et persistant.

```yaml
postgres:
  image: postgres:16-alpine
  environment:
    POSTGRES_DB: monprojet
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password
  ports:
    - "5432:5432"
  volumes:
    - postgres_data:/var/lib/postgresql/data
```

## CI/CD Minimal

GitHub Actions des le depart :

- checkout.
- setup Python ou Bun selon la stack.
- lint.
- tests.
- build si frontend ou image Docker.

## Regles de base

- Toujours fournir un `docker-compose.yml` fonctionnel des le depart quand une DB est requise.
- Eviter SQLite en prod.
- Ne jamais utiliser `pip install` directement : `uv add` ou `uv tool`.
- Tests avant ou avec le code.
- CI minimale GitHub Actions : lint + tests.
- `.env` jamais committe, variables documentees dans `.env.example` si utile.
- `.gitignore` adapte des le depart : `.env`, `__pycache__`, `node_modules`, artefacts de build.
