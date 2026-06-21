# Format De CONTEXT.md

`CONTEXT.md` est le glossaire du langage ubiquitaire d'un contexte : le
vocabulaire partage entre l'utilisateur et l'agent.

## Structure

```md
# {Nom du contexte}

{Une ou deux phrases : ce qu'est ce contexte et pourquoi il existe.}

## Langage

**Commande**:
{Une ou deux phrases decrivant le terme.}
_Eviter_: achat, transaction

**Facture**:
Une demande de paiement envoyee au client apres livraison.
_Eviter_: note, demande de paiement

**Client**:
Une personne ou organisation qui passe des commandes.
_Eviter_: acheteur, compte, utilisateur
```

## Regles

- Choisir un terme canonique quand plusieurs mots existent.
- Definitions serrees : une a deux phrases max.
- Definir ce que le terme est, pas ce qu'il fait.
- N'inclure que les termes specifiques au projet.
- Grouper les termes sous des sous-titres quand des clusters naturels emergent.

## Mono Vs Multi-Contexte

Mono-contexte : un seul `CONTEXT.md` a la racine.

Multi-contextes : un `CONTEXT-MAP.md` a la racine liste les contextes, ou ils
vivent et comment ils se relient :

```md
# Context Map

## Contextes

- [Commandes](./src/commandes/CONTEXT.md) - recoit et suit les commandes client
- [Facturation](./src/facturation/CONTEXT.md) - genere factures et encaisse

## Relations

- **Commandes -> Facturation** : Commandes emet `CommandePassee`; Facturation le
  consomme pour generer une facture.
```

Inference :

- Si `CONTEXT-MAP.md` existe, le lire pour trouver les contextes.
- Sinon, si un `CONTEXT.md` racine existe, mono-contexte.
- Si ni l'un ni l'autre, creer un `CONTEXT.md` racine paresseusement au premier
  terme resolu.

Quand plusieurs contextes existent, inferer celui auquel se rapporte le sujet.
Si c'est ambigu, demander.
