# Codex

Guidelines comportementales communes a tout projet. A completer avec les instructions specifiques.

## Avant de coder

- Explore le contexte du projet (README.md, docs, fichiers sources significatifs).
- Si tu as du mal a interpreter ma demande ou si tu hesites entre plusieurs approches, demande : je prefere une question a 200 lignes a refaire.
- Si tu vois plus simple que ce que je demande, propose-le avant d'implementer.
- Si tu vois que ma demande mene a un anti-pattern, previens-moi.
- Evalue l'echelle d'effort pour calibrer le process.

## Echelle d'effort

Sur-processer une petite tache gaspille du temps et des tokens.

- **XS** (typo, fix 1 ligne, config) : direct. Pas de plan, pas de skill superpowers.
- **S** (1 feature simple, jusqu'a 3 fichiers) : plan inline 3-5 bullets, code, tests, commit.
- **M** (multi-couches ou decisions UX/API a arbitrer) : `superpowers:brainstorming` puis execution inline.
- **L+** (multi-jours, refactor transverse, migration) : full superpowers (`superpowers:writing-plans` puis `superpowers:subagent-driven-development`).

Garde-fou : avant `superpowers:subagent-driven-development`, estime le cout en tokens et wallclock. Si le travail est estime a moins de 8h de dev, demande-moi confirmation explicite avec le chiffrage.

## Delegation

Un `spawn_agent` dynamique herite modele et effort du parent : plein tarif, plus
le contexte de base (~21k tokens) repaye a chaque spawn. Pire : les sous-agents
sont factures en tier Fast quel que soit le tier de la session (bug
openai/codex#30407, sans workaround). Spawner reste un outil d'isolation, a
utiliser avec parcimonie.

- Inline par defaut, volume mecanique compris.
- Exploration a deleguer : agent nomme `explore` (custom agent pinne sur
  luna@medium, read-only) — seul le resume revient dans le contexte principal.
- Le layering par modele passe par les custom agents (`~/.codex/agents/*.toml`,
  champs `model` + `model_reasoning_effort`) et les profils : `codex --profile
  luna` en volume, `codex --profile sol` en escalade archi/security.
- Jamais d'effort `ultra` : il spawne ses propres sous-agents paralleles
  (2-5x tokens, caches isoles, factures Fast). `max` fait le meme travail en
  sequentiel.
- Deterministe : script, hook ou commande, sans modele du tout.

## Pendant que tu codes

- Le minimum qui resout le probleme. Pas d'abstraction au cas ou, pas de config pour plus tard, pas de gestion d'erreur pour des cas impossibles.
- Pas de `catch` silencieux. Pas de `unwrap` hors tests. Une erreur remonte ou est traitee, jamais avalee.
- Edition chirurgicale : ne touche pas au code voisin sans rapport. Signale le dead code non lie sans le supprimer.
- Tests avec le code, pas apres. Pour un bug, ecris d'abord un test qui le reproduit, puis corrige.
- Le formatage passe par les hooks du projet; ne le relance pas manuellement.

## Avant de dire que c'est fait

Preuve d'execution obligatoire : tests qui passent, app qui demarre, endpoint qui repond. Si tu ne peux pas verifier toi-meme, dis-le explicitement.

## Git

- Lineaire : rebase, pas de merge commits.
- Conventional Commits, message = pourquoi, pas le quoi.
- Pas de `--no-verify`, pas de force push hors branche personnelle.

## Stacks

- Python : `uv`, jamais `pip` ou `poetry`. Details dans `stack-python`.
- TypeScript/JavaScript : `bun`, jamais `npm`, `yarn`, `pnpm` ou `node` direct. Details dans `stack-ts`.
- Rust : `cargo` et clippy pedantic. Details dans `stack-rust`.

## Outils

| Besoin | Preference | Fallback si indisponible ou en echec |
| --- | --- | --- |
| Recherche contenu semantique | `mgrep "query"` | `rg`, puis recherche integree |
| Recherche regex/litterale | `rg` | recherche integree |
| Recherche structure multi-lignes | `ast-grep` / `sg` | lecture ciblee |
| Recherche fichiers | `fd` | `rg --files`, puis glob |
| Explorer un fichier inconnu de plus de 200 lignes | agent `explore` | lecture ciblee par sections |
| Web | `mgrep --web --answer` | recherche web ciblee, en prevenant |
| Documentation de bibliotheque | plugin `context7` | web sur la source officielle |
| Extraction JSON/YAML | `jq` / `yq` | parseur structure, jamais un dump massif |

La preference est forte, mais si elle echoue, dis-le et utilise le fallback.

## RTK

- Le hook PreToolUse (`scripts/rtk-codex-hook.sh`) reecrit automatiquement les commandes supportees quand `rtk` est installe.
- Utilise directement `rtk read`, `rtk err`, `rtk log`, `rtk json` ou `rtk summary` quand leur sortie filtree est utile.
- Ne relance jamais `rtk init` ou `rtk init --global`.

## Contexte

- `/clear` entre deux taches sans lien.
- `/compact Keep: <ce qui compte>` quand tu sens des oublis.
- Gros perimetre a explorer : agent `explore`, puis resume dans le contexte principal.
- Ne mentionne pas un gros fichier sans raison; donne le chemin et ce que tu cherches.
- Memoire cross-session : memoire native Codex sous `~/.codex/memories`.

## Auto-amelioration

Quand un pattern se degage du travail, cristallise-le dans les skills, la memoire native ou `AGENTS.md`.

- Declencheur : procedure repetee 2-3 fois, correction recurrente ou piege evite de justesse.
- Quoi : skill neuf, evolution d'un skill, entree memoire ou instruction globale selon la portee.
- Quand : aux frontieres de tache ou de session, jamais au milieu d'une implementation.
- Comment : propose un diff; je le revois avant ecriture. Jamais de commit automatique.
- Garde-fous : pas d'over-skilling, edition chirurgicale et mini-eval pour un skill sensible.

Le hook Stop `scripts/reflect-nudge.sh` le rappelle une fois par session si du travail a eu lieu.

---

Ces regles fonctionnent si tu poses les questions avant de coder, si les diffs restent scopes, si tu verifies avant de dire fait, et si tu ne lances jamais `superpowers:subagent-driven-development` sans avoir chiffre le cout.
