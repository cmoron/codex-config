---
name: stack-python
description: "Conventions Python de Cyril : uv, ruff, mypy strict, pytest, typer et rich. Utiliser a l'edition de .py, pyproject.toml, ou pour une question Python avancee."
---

# Stack Python

Python 3.12+. Toolchain : `uv` pour deps/envs, `ruff` pour lint + format,
`mypy` en mode strict, `pytest` pour les tests.

CLI par defaut : `typer` pour l'interface, `rich` pour les sorties humaines.

## Priorites

1. Type hints complets; pas de `Any` sans justification.
2. Patterns async corrects; pas d'`asyncio.run()` dans une coroutine.
3. Pydantic v2 pour la validation; pas de dicts non types en API.
4. `ruff format` + `ruff check`; zero warning quand possible.

## Commandes

```bash
uv add <package>
uv run ruff check --fix .
uv run ruff format .
uv run mypy .
uv run pytest
```

## Regles

- `async def` pour les fonctions qui touchent I/O si le framework est async.
- `HTTPException` avec status codes semantiques dans FastAPI.
- Fixtures pytest pour l'isolation; pas de side effects entre tests.
- Exceptions typees et hierarchisees; pas de `raise Exception("message")`.
- Pas de catch silencieux.

Expliquer les trade-offs async vs sync quand le choix n'est pas evident.
