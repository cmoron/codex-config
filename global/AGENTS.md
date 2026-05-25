# Codex — Cyril Moron

Instructions comportementales communes a tout projet. Les instructions locales
du depot priment quand elles sont plus specifiques.

## Avant De Coder

- Explorer le contexte utile du projet : README, docs, fichiers similaires,
  configuration et tests existants.
- Si la demande est ambigue ou si deux approches se valent vraiment, poser une
  question courte avant d'implementer.
- Si une solution locale plus simple existe, la proposer avant de partir sur une
  approche plus lourde.
- Si la demande pousse vers un anti-pattern, le signaler clairement.
- Calibrer l'effort avant de choisir le process.

## Echelle D'Effort

Sur-processer une petite tache gaspille du temps et des tokens.

| Taille | Signaux | Process |
| --- | --- | --- |
| XS | Typo, fix 1 ligne, config simple | Direct : diagnostiquer, corriger, verifier. Pas de plan. |
| S | Feature simple, 1 couche, jusqu'a 3 fichiers | Plan inline 3-5 bullets si utile, code, tests. |
| M | Plusieurs fichiers/couches, arbitrage API/UX | Plan court, execution par tranches verticales, validations intermediaires. |
| L+ | Migration, refactor transverse, travail multi-jours | Plan explicite ou ADR avant implementation, decoupage en PRs. |

Garde-fou : avant de dispatcher des sous-agents ou de lancer un gros plan,
estimer cout en tokens et wallclock. Si le travail estime est inferieur a 8h de
dev, demander confirmation explicite avant d'utiliser un workflow lourd.

Anti-patterns a eviter :

- Plan massif pour une tache qui tient en une PR.
- Sous-agents pour une edition triviale.
- Refactor de stack sans verifier une solution locale plus simple.
- Abstraction "au cas ou" sans complexite reelle a absorber.

## Pendant Le Code

- Faire le minimum qui resout le probleme.
- Garder les changements scopes a la demande; ne pas toucher au code voisin non
  lie.
- Si du dead code non lie apparait, le signaler au lieu de le supprimer.
- Pas de `catch` silencieux. Pas de `unwrap` hors tests. Une erreur remonte ou
  est traitee explicitement.
- Tests avec le code, pas comme decoration apres coup. Pour un bug, ecrire
  d'abord un test qui le reproduit quand c'est praticable.
- Respecter les scripts, formatters et linters du projet. Eviter les
  reformattages massifs non lies.
- Preferer les commandes non interactives.
- Si le worktree est sale, ne jamais revert les changements non lies; travailler
  autour.

## Avant De Dire "Fait"

Preuve d'execution obligatoire quand elle est possible : tests qui passent, app
qui demarre, endpoint qui repond, commande de validation executee. "Ca devrait
marcher" n'est pas suffisant.

Si une verification ne peut pas etre lancee localement, le dire explicitement et
indiquer le risque residuel.

## Git

- Git lineaire : rebase, pas de merge commits.
- Conventional Commits : le message explique le pourquoi, pas seulement le quoi.
- Pas de `wip`, pas de `update` vague.
- Pas de `--no-verify`.
- Pas de force-push sauf demande explicite.
- Commit seulement si demande explicite ou workflow du projet deja etabli.

## Toolchains

- Python : `uv` pour deps/envs, `ruff` pour lint + format, `mypy` pour types,
  `pytest` pour tests. CLI : `typer` + `rich` par defaut.
- JavaScript/TypeScript : `bun` uniquement pour runtime, package manager,
  bundler et tests. Ne pas utiliser `npm`, `pnpm`, `yarn` ou `node` sauf
  contrainte explicite du projet.
- Rust : `cargo`, `rustfmt`, `clippy`; pas de `unwrap` hors tests.

## Outils

| Besoin | Preference | Fallback |
| --- | --- | --- |
| Recherche contenu semantique | `mgrep "query"` | `rg`, puis recherche integree |
| Recherche regex/litterale | `rg` | recherche integree |
| Recherche structure multi-lignes | `ast-grep` / `sg` | lecture ciblee |
| Recherche fichiers | `fd` | `rg --files`, puis glob |
| Gros fichier inconnu | lire par sections avec `sed -n` | lecture complete si court |
| Documentation de bibliotheque | Context7 quand disponible | web cible sur source officielle |
| Web | rechercher seulement si info volatile, demande explicite ou precision requise | citer les sources |
| JSON / YAML | `jq` / `yq` | parseur structure, pas de dump massif |

Le pattern general : preference forte, fallback pragmatique. Si l'outil prefere
echoue, le dire brievement et basculer.

## Skills Personnels

Skills deployes par `~/src/codex-config/install.sh` dans `~/.codex/skills/`.
Les skills portent les competences; les agents definissent les metiers.

- `codex-config` : modifier cette configuration Codex source.
- `mvp` : demarrer un MVP/POC avec les stacks preferees.
- `grill-me` : challenger un plan/design par questions successives.
- `nvim-config` : modifier la configuration Neovim personnelle.
- `openclaw` : travailler sur Nestor/openclaw et son deploiement.
- `stack-python` : conventions Python, uv, ruff, mypy, pytest.
- `stack-ts` : conventions TypeScript/JavaScript, Bun uniquement.
- `stack-rust` : conventions Rust, cargo, rustfmt, clippy.
- `api-design` : conception API REST/GraphQL, schemas, versioning, erreurs.
- `deployment` : CI/CD GitHub Actions, Docker Compose, serveurs Debian/Ubuntu.

Ne pas ajouter de plugin ou MCP sans demande explicite. Les integrations Claude
Linear/Notion ne sont pas supposees disponibles dans Codex par defaut.

## Stack De Reference

Cette stack est une preference, pas un dogme. Adapter aux contraintes du projet.

- API : FastAPI Python 3.12, ou routes API Next.js si l'app Next le justifie.
- UI simple MVP/POC : FastAPI + Svelte + Vite, Bun cote frontend.
- Full JS si impose : React + Express + Bun, Prisma, Biome.
- DB relationnelle : PostgreSQL.
- ORM : SQLAlchemy async cote Python, Prisma cote TypeScript.
- Auth : JWT + refresh tokens, ou NextAuth si l'app Next.js le justifie.
- Infra : Docker Compose en dev, deploiement conteneurise en prod.

## Communication

- Reponses concises, factuelles, actionnables.
- Mentionner les fichiers modifies et les verifications faites.
- Pour un code review, commencer par bugs, risques et regressions avec references
  fichier/ligne.
- Si une verification n'a pas pu etre lancee, le dire clairement.
