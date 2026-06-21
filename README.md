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

Sous WSL2, `install.sh` déploie aussi la configuration pour l'application Codex
Windows quand `/mnt/c/Users/$USER/.codex` existe. Cette cible reçoit des copies
réelles, pas des symlinks WSL, afin d'être lisible par l'application native.

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
| `global/AGENTS.md` | `~/.codex/AGENTS.md` + Windows si detecte | Instructions globales Codex |
| `AGENTS.md` | repo root | Instructions specifiques a ce repo |
| `config.toml` | `~/.codex/config.toml` + Windows si detecte | Modèle, projets trusted, plugins |
| `rules/default.rules` | `~/.codex/rules/default.rules` + Windows si detecte | Approbations persistantes |
| `skills/*` | `~/.codex/skills/*` + Windows si detecte | Skills personnels Codex |
| `scripts/` | `~/.codex/scripts/` + Windows si detecte | Notification sonore |
| `assets/` | `~/.codex/assets/` + Windows si detecte | MP3 de fin de travail |

## Skills Personnels

| Skill | Rôle |
| --- | --- |
| `codex-config` | Modifier ce repo et redeployer proprement |
| `autoship` | Produire une petite feature/fix en autonomie totale sur demande explicite |
| `mvp` | Démarrer un MVP/POC avec les stacks préférées |
| `grill-with-docs` | Challenger un plan/design avec glossaire `CONTEXT.md` et ADR |
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
│   ├── api-design/
│   ├── autoship/
│   ├── codex-config/
│   ├── deployment/
│   ├── grill-with-docs/
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
