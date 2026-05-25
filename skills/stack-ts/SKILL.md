---
name: stack-ts
description: "Conventions TypeScript/JavaScript de Cyril : Bun uniquement, types stricts, gestion d'erreurs explicite. Utiliser a l'edition de .ts/.tsx, package.json, ou pour une question TypeScript."
---

# Stack TypeScript

`bun` uniquement : runtime, package manager, bundler, test runner.

Ne pas utiliser `npm`, `pnpm`, `yarn` ou `node` sauf contrainte explicite du
projet.

## Commandes

```bash
bun add <package>
bun install
bun run <script>
bun test
bun build
```

## Priorites

1. Types stricts : `strict: true` dans `tsconfig.json`, pas d'`any` implicite.
2. Gestion d'erreurs explicite; pas de catch silencieux.
3. Respect du formatter/linter du projet, Biome par defaut pour un nouveau POC.

## Regles

- Toute commande JS passe par `bun`.
- Pas de `node_modules` gere par un autre outil que Bun.
- Un module = une responsabilite.
- Types partages dans un package dedie si le projet devient multi-app.
