---
name: codex-config
description: Modifier la configuration Codex personnelle de Cyril dans ~/src/codex-config, puis redeployer via install.sh. Utiliser pour AGENTS.md, config.toml, skills, rules et scripts Codex.
---

# Codex Config — ~/src/codex-config

Ce repo centralise la configuration personnelle Codex. Modifier la source ici,
jamais directement dans `~/.codex`.

## Structure

```text
~/src/codex-config/
├── AGENTS.md              # Instructions propres a ce repo
├── global/AGENTS.md       # Instructions globales deployees dans ~/.codex/AGENTS.md
├── config.toml            # Modele, sandbox, TUI, plugins, MCPs
├── rules/default.rules    # Regles persistantes d'approbation
├── skills/                # Skills personnels Codex
├── scripts/               # Helpers de notification
├── assets/                # Assets utilitaires
├── install.sh             # Symlinks WSL + copies Windows idempotents
└── update.sh              # Pull fast-forward + install
```

## Workflow

1. Lire les fichiers existants avant modification.
2. Garder les changements scopes a la demande.
3. Ne pas ajouter de plugin ou MCP sans demande explicite.
4. Relancer `./install.sh` apres modification pour remettre les symlinks/copies en place.
5. Verifier avec au minimum `bash -n install.sh update.sh scripts/*.sh`.
6. Si un skill est ajoute/supprime/renomme, tenir `global/AGENTS.md` et `README.md`
   synchronises.

## Conventions

- Instructions globales en francais, concises et actionnables.
- Preferer ASCII dans les fichiers de config sauf besoin explicite.
- Conventional commits.
- Ne jamais modifier ou supprimer les skills systeme dans `~/.codex/skills/.system`.
- `install.sh` purge les symlinks de skills geres par ce repo qui ont disparu de
  la source; ne pas contourner ce deploiement declaratif.
- Sous WSL2, `install.sh` copie aussi les fichiers geres vers
  `/mnt/c/Users/$USER/.codex` si ce dossier existe. Ne pas symlinker cette cible :
  l'application Windows doit lire des fichiers reels.
