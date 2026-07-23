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
- **L+** (multi-jours, refactor transverse, migration) : `superpowers:writing-plans`, puis execution sequentielle par lots valides.

Pour une tache L+, produire un plan explicite, deleguer seulement les lots bornes et independants, et demander une validation humaine aux frontieres importantes.

## Modeles et effort

- Defaut : `gpt-5.6-sol` @ `xhigh` pour l'orchestration, l'architecture, les demandes ambigues, les decisions techniques dimensionnantes ou pointues et toute implementation jugee critique.
- Profil `terra` @ `high` pour une implementation bornee, clairement specifiee, non critique et moins couteuse.
- Profil `luna` @ `high` pour le volume mecanique, la recherche et les transformations simples.
- Profil `sol-high` pour reduire ponctuellement l'effort de Sol.
- Sous-agent `worker` : `terra` @ `high` par defaut; sous-agent `explore` : `luna` @ `high` en lecture seule.
- Sous-agent `critical` : `sol` @ `xhigh` pour toute implementation critique ou risquee.
- `max` est une escalade ponctuelle pour un probleme profond et indivisible qui resiste a `xhigh`, jamais un defaut permanent.
- Sous-agent `super-joker` : `sol` @ `ultra`, uniquement apres un blocage concret de l'orchestrateur `xhigh` et si le probleme beneficie d'un fan-out borne.

## Delegation

Le multi-agent Codex est active. L'agent principal Sol xhigh orchestre, conçoit l'architecture, prend les decisions techniques dimensionnantes ou pointues, integre et verifie.

- XS : direct, sans sous-agent.
- S clairement bornee et non critique : deleguer l'implementation a `worker` quand le brief suffit a travailler en autonomie.
- Implementation critique ou risquee : conserver le travail dans l'agent principal ou utiliser `critical`; jamais `worker` ou `explore`.
- Exploration read-only bornee : utiliser `explore`.
- M/L+ : paralleliser seulement deux taches ou plus reellement independantes, puis attendre et synthetiser leurs resultats.
- Les sous-agents produisent du travail et des preuves; l'agent principal reste l'arbitre des choix d'architecture.
- Ne jamais faire modifier les memes fichiers par plusieurs agents.
- Apres un blocage `xhigh`, utiliser `max` si le probleme est indivisible ou `super-joker` s'il se decompose proprement; revenir ensuite a l'orchestrateur `xhigh`.
- `fast_mode` reste desactive; aucun tier Fast implicite.
- Deterministe : script, hook ou commande, sans modele du tout.

## Pendant que tu codes

- Le minimum qui resout le probleme. Pas d'abstraction au cas ou, pas de config pour plus tard, pas de gestion d'erreur pour des cas impossibles.
- Pas de `catch` silencieux. Pas de `unwrap` hors tests. Une erreur remonte ou est traitee, jamais avalee.
- Edition chirurgicale : ne touche pas au code voisin sans rapport. Signale le dead code non lie sans le supprimer.
- Tests avec le code, pas apres. Pour un bug, ecris d'abord un test qui le reproduit, puis corrige.
- Le formatage passe par les hooks du projet; ne le relance pas manuellement.

## Avant de dire que c'est fait

Preuve d'execution obligatoire : tests qui passent, app qui demarre, endpoint qui repond. Si tu ne peux pas verifier toi-meme, dis-le explicitement.
- Quand le projet fournit des controles locaux pertinents (format, lint, tests, qualimetrie), les executer avant de conclure ; une compilation seule ne les remplace pas.

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
| Explorer un fichier inconnu de plus de 200 lignes | lecture ciblee par sections | `rtk read`, puis `sed`/`rg` cible |
| Web | `mgrep --web --answer` | recherche web ciblee, en prevenant |
| Documentation de bibliotheque | plugin `context7` | web sur la source officielle |
| Extraction JSON/YAML | `jq` / `yq` | parseur structure, jamais un dump massif |

La preference est forte, mais si elle echoue, dis-le et utilise le fallback.

## RTK

- Le hook PreToolUse (`scripts/rtk-codex-hook.sh`) reecrit automatiquement les commandes supportees quand `rtk` est installe.
- La sortie filtree rtk n'est pas la sortie brute : dans une pipe vers un programme qui exige les bytes exacts (`git diff | git apply`, `patch`, checksum), utilise `rtk proxy <cmd>` ou `--output=<fichier>`.
- Utilise directement `rtk read`, `rtk err`, `rtk log`, `rtk json` ou `rtk summary` quand leur sortie filtree est utile.
- Ne relance jamais `rtk init` ou `rtk init --global`.

## Contexte

- `/clear` entre deux taches sans lien.
- `/compact Keep: <ce qui compte>` quand tu sens des oublis.
- Gros perimetre a explorer : lecture ciblee, notes intermediaires, puis synthese inline.
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

Ces regles fonctionnent si tu poses les questions avant de coder, si les diffs restent scopes, si tu verifies avant de dire fait, et si la delegation reste bornee et observable.
