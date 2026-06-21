# codex-config

Ce repository versionne la configuration personnelle Codex de Cyril.

## Regles Projet

- Modifier la configuration source ici, jamais directement dans `~/.codex`.
- Relancer `./install.sh` apres modification pour remettre les symlinks en place.
- Les preferences globales chargees par Codex vivent dans `global/AGENTS.md`.
- `install.sh` doit rester idempotent et sauvegarder les fichiers existants avant remplacement.
- Les skills deployes sont declaratifs : un skill retire de `skills/` doit etre
  purge de `~/.codex/skills/` par `install.sh`.
- Ne pas ajouter de plugin ou MCP sans demande explicite.
