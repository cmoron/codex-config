---
name: nvim-config
description: "Modifier la configuration Neovim personnelle de Cyril dans ~/src/nvim-config : plugins lazy.nvim, LSP, keybindings, formatters et workflow de reload."
---

# Neovim Config — ~/src/nvim-config

Configuration Neovim personnelle pour Neovim 0.11+. Le repo est symlinke vers
`~/.config/nvim`.

## Structure

```text
~/src/nvim-config/
├── init.lua
├── lazy-lock.json
├── stylua.toml
└── scripts/
```

Tout est principalement dans `init.lua` :

1. Settings de base.
2. Autocmds.
3. Mappings globaux.
4. Bootstrap lazy.nvim.
5. Plugins et configs inline.
6. Configuration LSP.
7. Java via nvim-jdtls.

## Conventions

- Leader key : espace.
- Modifier le repo source, pas `~/.config/nvim` directement.
- Garder les changements localises.
- Verifier la syntaxe Lua quand possible.
- Recharger dans Neovim avec `<leader><CR>`.

## Points d'attention

- `K` est reserve au scroll rapide, pas au hover.
- Hover LSP : `H`.
- Format manuel : `<leader>f`.
- Pas de format automatique a la sauvegarde.
- LSP actifs : pyright, bashls, ts_ls, svelte, rust_analyzer, ruff, Java via nvim-jdtls.
