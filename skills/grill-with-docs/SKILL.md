---
name: grill-with-docs
description: Interview contradictoire qui challenge un plan/design contre le langage du projet (glossaire CONTEXT.md) et les decisions documentees (ADR). Utiliser pour stress-tester un plan, aligner le vocabulaire, ou quand l'utilisateur mentionne "grill me" / "grill with docs".
---

# Grill With Docs

Interviewer l'utilisateur sans relache sur chaque aspect du plan jusqu'a une
comprehension partagee. Parcourir les branches de decision une par une, en
resolvant les dependances entre decisions. Pour chaque question, donner la
reponse recommandee.

Poser les questions une a la fois et attendre le retour avant de continuer.

Si une question peut trouver sa reponse en explorant le codebase, explorer le
codebase au lieu de demander.

## Conscience Du Domaine

Pendant l'exploration, reperer la documentation existante :

```text
/
+-- CONTEXT.md
+-- docs/
|   +-- adr/
+-- src/
```

Repo multi-contextes : un `CONTEXT-MAP.md` a la racine pointe vers chaque
contexte. Voir `CONTEXT-FORMAT.md`.

Creation paresseuse : ne creer `CONTEXT.md` que quand le premier terme est
resolu, `docs/adr/` que quand le premier ADR est necessaire.

## Pendant La Session

- Challenger contre le glossaire. Si l'utilisateur emploie un terme qui entre en
  conflit avec `CONTEXT.md`, le signaler aussitot.
- Affuter le vocabulaire flou. Sur un terme vague ou surcharge, proposer un
  terme canonique precis.
- Discuter des scenarios concrets qui sondent les cas limites.
- Croiser avec le code quand l'utilisateur affirme comment quelque chose marche.

## Mettre A Jour CONTEXT.md

Quand un terme est resolu, mettre a jour `CONTEXT.md` tout de suite. Ne pas
batcher.

`CONTEXT.md` est uniquement un glossaire : aucun detail d'implementation, pas
une spec, pas un bloc-notes. Ce qu'un terme est, pas ce qu'il fait.

Format : voir `CONTEXT-FORMAT.md`.

## ADR Avec Parcimonie

Ne proposer un ADR que si les trois sont vrais :

1. Dur a inverser.
2. Surprenant sans contexte.
3. Resultat d'un vrai arbitrage.

Si l'un des trois manque, pas d'ADR. Format : voir `ADR-FORMAT.md`.
