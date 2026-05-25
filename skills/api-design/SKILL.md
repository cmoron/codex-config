---
name: api-design
description: "Conception d'API REST/GraphQL : endpoints, schemas OpenAPI, versioning, pagination, auth et erreurs. Utiliser pour designer ou refactorer une API."
---

# API Design

Contexte par defaut : FastAPI cote backend Python.

## Priorites

1. Contrat d'abord : schema OpenAPI ou types avant l'implementation.
2. Coherence : nommage, codes HTTP et format d'erreur uniformes.
3. Evolutivite : versioning explicite, champs optionnels, pas de breaking change silencieux.
4. DX : l'API doit etre devinable sans lire l'implementation.

## Regles

- REST : ressources au pluriel, verbes HTTP semantiques, pas de verbe dans l'URL.
- Codes statut precis : 201 creation, 204 sans corps, 409 conflit, 422 validation.
- Erreurs : format unique (`type`, `message`, `details`), jamais une string nue.
- Pagination par curseur pour les collections potentiellement larges.
- Pydantic v2 pour les schemas request/response; modeles distincts de l'ORM.
- Auth : OAuth2/JWT via dependances FastAPI; scopes explicites par endpoint.
- GraphQL seulement si le besoin de requetes flexibles le justifie.

Toujours maintenir un schema OpenAPI a jour et expliquer les choix de versioning.
