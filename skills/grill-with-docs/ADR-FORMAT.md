# Format Des ADR

Les ADR vivent dans `docs/adr/` avec une numerotation sequentielle :
`0001-slug.md`, `0002-slug.md`, etc. Creer le dossier paresseusement.

## Template

```md
# {Titre court de la decision}

{1 a 3 phrases : quel est le contexte, qu'a-t-on decide, et pourquoi.}
```

Un ADR peut tenir en un paragraphe. La valeur est d'enregistrer qu'une decision
a ete prise et pourquoi.

## Sections Optionnelles

A inclure seulement si elles apportent une vraie valeur :

- Status en frontmatter : `proposed`, `accepted`, `deprecated`,
  `superseded by ADR-NNNN`.
- Options considerees.
- Consequences.

## Numerotation

Scanner `docs/adr/` pour le plus grand numero existant et incrementer de un.

## Quand Proposer Un ADR

Les trois criteres doivent etre vrais :

1. Dur a inverser : changer d'avis plus tard coute reellement.
2. Surprenant sans contexte : un futur lecteur demandera pourquoi.
3. Resultat d'un vrai arbitrage : il y avait de vraies alternatives.

Si une decision est facile a inverser, pas d'ADR. Si elle n'est pas surprenante,
pas d'ADR. S'il n'y avait pas de vraie alternative, pas d'ADR.
