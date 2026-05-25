---
name: stack-rust
description: "Conventions Rust de Cyril : cargo, rustfmt, clippy, thiserror/anyhow. Utiliser a l'edition de .rs, Cargo.toml, ou pour une question Rust."
---

# Stack Rust

Rust edition 2021 ou celle imposee par le projet.

## Priorites

1. Satisfaction du borrow checker sans `unsafe` sauf justification explicite.
2. Idiomes Rust : iterateurs, propagation `?`, traits `From`/`Into`, `Display`/`Error`.
3. Zero-cost abstractions; pas d'allocations inutiles.
4. `clippy::all` et `clippy::pedantic` quand le projet l'accepte.

## Commandes

```bash
cargo fmt
cargo clippy --all-targets -- -W clippy::pedantic
cargo test
```

## Regles

- Jamais `unwrap()` / `expect()` hors tests.
- `thiserror` pour les erreurs de librairie, `anyhow` pour les binaires.
- `derive(Debug, Clone)` par defaut sur les structs publiques quand pertinent.
- Lifetime elision partout ou c'est possible.

Expliquer pourquoi le borrow checker se plaint, pas seulement comment contourner
le probleme.
