# codex-config

Configuration personnelle de Codex CLI : instructions globales, config TOML, règles
d'approbation, skills personnels, scripts utilitaires et assets.

## Installation

```bash
cd ~/src/codex-config
./install.sh
```

L'installation est idempotente. Elle crée des sauvegardes datées avant de remplacer
des fichiers existants non symlinkés dans `~/.codex`.

## Mise à jour

```bash
cd ~/src/codex-config
./update.sh
```

`update.sh` fait un `git pull --ff-only`, puis relance `install.sh`.

## Ce qui est déployé

| Source | Cible | Rôle |
| --- | --- | --- |
| `global/AGENTS.md` | `~/.codex/AGENTS.md` | Instructions globales Codex |
| `AGENTS.md` | repo root | Instructions specifiques a ce repo |
| `config.toml` | `~/.codex/config.toml` | Modèle, projets trusted, plugins |
| `rules/default.rules` | `~/.codex/rules/default.rules` | Approbations persistantes |
| `skills/*` | `~/.codex/skills/*` | Skills personnels Codex |
| `scripts/` | `~/.codex/scripts/` | Notification sonore |
| `assets/` | `~/.codex/assets/` | MP3 de fin de travail |

## Skills Personnels

| Skill | Rôle |
| --- | --- |
| `codex-config` | Modifier ce repo et redeployer proprement |
| `mvp` | Démarrer un MVP/POC avec les stacks préférées |
| `grill-me` | Challenger un plan/design par questions successives |
| `nvim-config` | Modifier la configuration Neovim personnelle |
| `openclaw` | Travailler sur Nestor/openclaw et son déploiement |
| `stack-python` | Conventions Python : uv, ruff, mypy, pytest |
| `stack-ts` | Conventions TypeScript/JavaScript : Bun uniquement |
| `stack-rust` | Conventions Rust : cargo, rustfmt, clippy |
| `api-design` | Conception API REST/GraphQL |
| `deployment` | CI/CD GitHub Actions, Docker Compose, serveurs Debian/Ubuntu |

Les skills Claude dépendants de MCPs non configurés côté Codex (`linear`,
`notion`) ne sont pas portés ici pour respecter la règle projet : ne pas ajouter
de plugin ou MCP sans demande explicite.

Les plugins et outils Claude-only (`claude-code-setup`, `graphify` comme skill
auto-enregistre, `superpowers`, `claude-mem`, etc.) ne sont pas installes par ce
repo Codex.

## Statusline

Codex CLI configure sa statusbar native via `tui.status_line` dans
`config.toml`. La configuration active affiche le modèle avec niveau de
raisonnement, le répertoire courant, la branche git et le contexte restant.

## Context7

Context7 est configure comme serveur MCP remote dans `config.toml`.

Pour l'authentifier sans committer de secret, exposer la cle API dans
l'environnement :

```bash
export CONTEXT7_API_KEY=ctx7sk-...
```

Codex transmet cette variable au serveur via le header `CONTEXT7_API_KEY`.

## Notification sonore

`scripts/notify-sound.sh` joue le MP3 Warcraft 3 de fin de travail. Il est compatible
macOS, WSL2 et fallback terminal bell.

## Structure

```text
.
├── AGENTS.md
├── global/
│   └── AGENTS.md
├── config.toml
├── rules/
│   └── default.rules
├── skills/
│   ├── codex-config/
│   ├── api-design/
│   ├── deployment/
│   ├── grill-me/
│   ├── mvp/
│   ├── nvim-config/
│   ├── openclaw/
│   ├── stack-python/
│   ├── stack-rust/
│   └── stack-ts/
├── scripts/
│   └── notify-sound.sh
├── assets/
│   └── warcraft-3-paysan-travail-termine.mp3
├── install.sh
└── update.sh
```
