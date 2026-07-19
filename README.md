# codex-config

Configuration personnelle partagee par Codex CLI et l'application : instructions
globales, config TOML, hooks, regles de securite, plugins, skills et preferences UI.

## Installation

```bash
cd ~/src/codex-config
./install.sh
```

L'installation est idempotente. Elle cree des sauvegardes datees avant de remplacer
des fichiers existants dans `~/.codex`. Les fichiers que Codex peut reecrire sont
copies; scripts, assets et skills sont symlinkes. L'etat de confiance des hooks est
preserve lors des reinstallations.

Sous WSL2, `install.sh` déploie aussi la configuration pour l'application Codex
Windows quand `/mnt/c/Users/$USER/.codex` existe. Cette cible reçoit des copies
réelles, pas des symlinks WSL, afin d'être lisible par l'application native.
Le `config.toml` Windows est app-owned : il est créé seulement s'il manque, puis
préservé pour laisser l'application native gérer ses sections runtime, desktop,
plugins Chrome et Computer Use.

Pour forcer un autre chemin Windows :

```bash
CODEX_CONFIG_WINDOWS_DIR=/mnt/c/Users/cyril/.codex ./install.sh
```

## Mise à jour

```bash
cd ~/src/codex-config
./update.sh
```

`update.sh` fait un `git pull --ff-only`, puis relance `install.sh`.

## Ce qui est déployé

| Source | Cible | Rôle |
| --- | --- | --- |
| `global/AGENTS.md` | `~/.codex/AGENTS.md` + Windows si detecte | Instructions globales Codex (copie) |
| `AGENTS.md` | repo root | Instructions specifiques a ce repo |
| `config.toml` | `~/.codex/config.toml` (copie); Windows seede seulement si absent | Reglages communs, TUI, Desktop et plugins |
| `hooks.json` | `~/.codex/hooks.json` + Windows si detecte | Protection des fichiers, formatage, RTK et rappel de fin (copie) |
| `rules/default.rules` | `~/.codex/rules/default.rules` + Windows si detecte | Interdictions de commandes destructrices (copie) |
| `skills/*` | `~/.agents/skills/*` (`~/.codex/skills/*` sous Windows) | Skills personnels Codex |
| `scripts/` | `~/.codex/scripts/` + Windows si detecte | Implementations des hooks et notification |
| `assets/` | `~/.codex/assets/` + Windows si detecte | MP3 de fin de travail |
| `agents/` | `~/.codex/agents/` + Windows si detecte | Custom agents dormants tant que le multi-agent est desactive |

## Skills Personnels

| Skill | Rôle |
| --- | --- |
| `codex-config` | Modifier ce repo et redeployer proprement |
| `autoship` | Produire une petite feature/fix en autonomie totale sur demande explicite |
| `mvp` | Démarrer un MVP/POC avec les stacks préférées |
| `grill-with-docs` | Challenger un plan/design avec glossaire `CONTEXT.md` et ADR |
| `nvim-config` | Modifier la configuration Neovim personnelle |
| `openclaw` | Travailler sur Nestor/openclaw et son déploiement |
| `lotusim-developer` | Build/run/contribution à LOTUSim |
| `opensource-contributor` | Process avant PR/issue sur repo open source tiers |
| `stack-python` | Conventions Python : uv, ruff, mypy, pytest |
| `stack-ts` | Conventions TypeScript/JavaScript : Bun uniquement |
| `stack-rust` | Conventions Rust : cargo, rustfmt, clippy |
| `api-design` | Conception API REST/GraphQL |
| `deployment` | CI/CD GitHub Actions, Docker Compose, serveurs Debian/Ubuntu |

Les skills Claude dependants de MCPs non configures cote Codex (`linear`,
`notion`) ne sont pas portes. Les historiques, memoires et caches restent propres
a chaque produit.

`install.sh` installe les marketplaces Mixedbread, Anthropic et Ponytail dans un
`CODEX_HOME` temporaire relie aux caches locaux, puis active les plugins compatibles
declares dans `config.toml`. Les chemins et timestamps de cache ne sont pas versionnes.
`security-guidance` reste desactive : ses hooks Anthropic utilisent des champs
`Stop` et `SessionStart` que Codex 0.144.1 rejette.

## Modeles

- Defaut : `gpt-5.6-sol` @ `medium`. C'est le point de depart Power recommande pour
  le travail general, ambigu et les arbitrages. L'objectif est de payer un meilleur
  premier passage plutot que plusieurs reprises d'un modele moins fort.
- Profil `terra` @ `medium` : implementation bornee, spec claire, travail quotidien
  ou le cout prime davantage que l'ambiguite.
- Profil `luna` @ `medium` : volume mecanique, recherche, transformations simples.
- Profil `sol-high` : architecture, securite, debug difficile.
- `max` reste une escalade ponctuelle apres echec; `ultra` est interdit.
- `multi_agent`, `multi_agent_v2` et `fast_mode` sont explicitement desactives tant
  que les regressions openai/codex#29940, #30407, #31814 et #32031 ne sont pas
  corrigees et verifiees sur une release.
- Les custom agents sous `agents/` restent versionnes mais dormants pour pouvoir
  retester le layering une fois le harness stabilise.

## Statusline

Codex CLI configure sa statusbar native via `tui.status_line` dans
`config.toml`. La configuration active affiche le modèle avec niveau de
raisonnement, les limites d'utilisation, le contexte, le répertoire courant, la
branche git et la progression de la tâche.

## Fenêtre de contexte

Le cache modèle local Codex (`~/.codex/models_cache.json`, client 0.144.5) expose
actuellement `gpt-5.5` et `gpt-5.6-sol` avec une fenêtre maximale de 272k tokens.
La fenêtre utilisable affichée autour de 258k correspond à cette limite avec la
marge effective de Codex. Ce n'est pas configurable à 1M depuis `config.toml`.

## App et TUI

Les reglages communs vivent a la racine de `config.toml`. `[tui]` configure la
statusline du terminal; `[desktop]` conserve les preferences stables de l'app
(theme, follow-ups, niveau de detail et cible d'ouverture).

Computer Use, Node REPL, hashes de confiance, notices de migration, caches et
marketplaces locales generes par l'app ne sont pas versionnes.

Les mutations runtime de l'app ou du CLI restent dans `~/.codex/config.toml` et
ne salissent pas le depot. Relancer `install.sh` reapplique la source stable tout
en conservant la table dynamique `[hooks.state]`.

## Hooks

- `protect-env.sh` bloque les patchs vers `.env` et `.env.*`.
- `format-on-save.sh` lance le formatter deja installe pour les fichiers modifies.
- `rtk-codex-hook.sh` reecrit les commandes shell via RTK : Codex exige
  `permissionDecision: "allow"` en plus du schema Claude emis par `rtk hook claude`.
  Ne pas remplacer par `rtk init -g --codex` : ce built-in est le mode
  instructions (~70-80 % de fiabilite, mesure a 2/82 ici), pas un hook —
  `rtk hook codex` n'existe pas upstream.
- RTK et Atuin sont utilises quand leurs binaires sont disponibles.
- Apres toute modification de `hooks.json`, re-truster les hooks une fois via
  `/hooks` dans le TUI (le hash de confiance porte sur la definition du hook).
- `reflect-nudge.sh` renvoie toujours du JSON valide pour le contrat `Stop` Codex.
- La notification sonore utilise `notify`, pas un hook `Stop`.

## Notification sonore

`scripts/notify-sound.sh` joue le MP3 Warcraft 3 de fin de travail. Il est compatible
macOS, WSL2 et fallback terminal bell.

## Structure

```text
.
├── AGENTS.md
├── agents/
│   └── explore.toml
├── global/
│   └── AGENTS.md
├── config.toml
├── hooks.json
├── rules/
│   └── default.rules
├── skills/
│   ├── api-design/
│   ├── autoship/
│   ├── codex-config/
│   ├── deployment/
│   ├── grill-with-docs/
│   ├── lotusim-developer/
│   ├── mvp/
│   ├── nvim-config/
│   ├── openclaw/
│   ├── opensource-contributor/
│   ├── stack-python/
│   ├── stack-rust/
│   └── stack-ts/
├── scripts/
│   ├── format-on-save.sh
│   ├── notify-sound.sh
│   ├── protect-env.sh
│   └── reflect-nudge.sh
├── tests/
│   ├── test-hooks.sh
│   └── test-install.sh
├── assets/
│   └── warcraft-3-paysan-travail-termine.mp3
├── install.sh
└── update.sh
```
