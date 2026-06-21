---
name: openclaw
description: "Travailler sur Nestor/openclaw : VM NAS locale, configuration du service, workspace agent, services actifs et deploiement via Ansible."
---

# Openclaw — Nestor

Nestor est un assistant IA personnel tournant sur une VM KVM locale, accessible
via Telegram.

OpenClaw est une plateforme open-source auto-hebergee qui transforme un LLM en
agent personnel persistant, accessible via messagerie. Nestor est l'instance
OpenClaw personnelle de Cyril.

## Concepts

- Gateway : control plane WebSocket qui route messages, sessions et workspace.
- Channel adapters : normalisent les entrees Telegram, WhatsApp, Slack, etc.
  Nestor utilise Telegram.
- Agent runtime : assemble historique, prompts, skills et tools pour executer la
  boucle agentique.
- Workspace : repertoire Markdown durable injecte dans l'agent.
- Skills : playbooks `SKILL.md` lazy-loaded.
- Heartbeat : tours periodiques, toutes les 4h entre 08h et 22h30.
- Memoire : fichiers Markdown durables + rappel semantique.

## Acces

- VM : `cyril@192.168.122.100` via ProxyJump `nas`.
- SSH : `ssh -J nas cyril@192.168.122.100`.
- Ansible : `~/src/openclaw/ansible/`.
- Config sur VM : `~/.openclaw/`.
- Service : `systemctl --user status openclaw-gateway`.
- VNC : `vnc-openclaw.home.moron.at`.

## Architecture

```text
~/.openclaw/
├── openclaw.json
├── .env
└── workspace/
    ├── SOUL.md
    ├── AGENTS.md
    ├── HEARTBEAT.md
    ├── TOOLS.md
    ├── USER.md
    ├── MEMORY.md
    ├── memory/
    └── skills/
```

## Modeles

- Principal : `google/gemini-3-flash-preview`.
- Fallbacks : `google/gemini-3-pro-preview`, `google/gemini-2.5-flash-lite`.
- Subagents : `google/gemini-2.5-flash`.
- Ne pas utiliser Flash Lite comme modele principal : il confond outils natifs
  et skills.

## Services Actifs

| Service | Outil | Etat | Notes |
| --- | --- | --- | --- |
| Gmail | `gog gmail` | OK | API Google, pas de browser |
| Google Calendar | `gog calendar` | OK | API Google, pas de browser |
| Recherche web | skill `ddg-search` | OK | Python pur |
| Meteo | skill `weather` | OK | |
| Google Keep | browser headless | Partiel | Chrome doit etre lance manuellement |
| Carrefour Drive | browser CDP port 19222 | Partiel | Chrome non-headless + Xvfb DISPLAY:1 |

## Chrome VM NAS

- Chrome tourne en service systemd permanent sur la VM.
- Xvfb + Chrome demarrent au boot et redemarrent automatiquement si crash.
- Sessions Carrefour / Google Keep persistantes dans
  `~/.openclaw/browser/chrome-profile`.
- Debug port : `9222`; display : `:1`.
- VNC : `vnc-openclaw.home.moron.at`.

## Regles

- Ne jamais committer `.env` ou secrets.
- Ne pas utiliser Flash Lite comme modele principal.
- Modifier localement dans `~/src/openclaw/`.
- Deployer via Ansible :
  `ansible-playbook -i ansible/inventory.yml ansible/playbooks/03-openclaw.yml`.
- Redemarrer si besoin :
  `ssh -J nas cyril@192.168.122.100 'systemctl --user restart openclaw-gateway'`.
- Verifier par status systemd puis test Telegram.
- Les fichiers workspace sont relus au prochain message sans redemarrage.

## Montees De Version Openclaw

Ne pas mettre a jour openclaw via `npm i -g openclaw`. Le mecanisme canonique
est la commande CLI `openclaw update`.

Le `openclaw` du PATH interactif tape un Node v18 et peut echouer avec
`Node v22+ required`. Invoquer via Node v24 :

```bash
NODE=~/.nvm/versions/node/v24.13.1/bin/node
DIST=~/.nvm/versions/node/v24.13.1/lib/node_modules/openclaw
$NODE $DIST/dist/index.js update --dry-run
```

- Canaux : `--channel stable|beta|dev`, persiste dans `openclaw.json` bloc
  `update`; vide = stable par defaut.
- `stable` / `beta` : install en mode package npm, limite a ce qui est publie.
- `dev` : bascule en checkout git, build depuis GitHub, plus a risque.
- `--tag <version|dist-tag|spec>` cible une version precise.
- `--dry-run` previsualise la version cible et l'action.
- Options utiles : `--no-restart`, `--yes`, `--timeout <s>`.
- Etat : `openclaw update status`; assistant interactif :
  `openclaw update wizard`.
- Plugins versionnes separement via
  `openclaw plugins install/update/uninstall`.
- Un plugin peut exiger un runtime minimum; par exemple le plugin codex 0.139
  vit dans `@openclaw/codex@2026.6.6-beta.1` et exige un runtime openclaw au
  moins `2026.6.6-beta.1`.
- Toujours redemarrer ensuite via `openclaw gateway restart`, puis verifier
  `gateway ready` et heartbeat/Telegram dans les logs.

## Re-Auth OAuth Codex/OpenAI Sur VM Headless

La VM n'a pas de navigateur pratique pour le flow OAuth. Le flow navigateur de
`codex login` ou `openclaw models auth login --provider openai` ouvre un
callback sur `localhost:<port>` de la VM. La methode fiable est de forwarder ce
port via SSH et d'ouvrir l'URL depuis le navigateur local.

```bash
# 1. Depuis le laptop, ouvrir une session avec le port de callback forwarde.
#    Codex ecoute historiquement sur 1455; confirmer via redirect_uri.
ssh -J nas -L 1455:localhost:1455 cyril@192.168.122.100

# 2. Dans cette session, lancer le login sans --device-code.
openclaw models auth login --provider openai --force

# 3. Ouvrir l'URL affichee dans le navigateur du laptop, se connecter, approuver.
# 4. La redirection localhost:1455 revient a la VM via le tunnel.
```

- Si `redirect_uri=http://localhost:XXXX` utilise un autre port, refaire le
  tunnel avec `ssh -L XXXX:localhost:XXXX`.
- Codex 0.139 expose aussi `codex login --with-access-token` et
  `--with-api-key`, lus sur stdin, si un token est recupere autrement.
- Le flow par defaut imprime l'URL et ecoute le port meme sans navigateur sur la
  VM; le tunnel suffit.
- `--force` supprime les autres profils du provider. Pour ajouter un second
  compte, lancer le login sans `--force`.
- Si le terminal ne rend pas la main apres succes navigateur, l'auth est souvent
  deja persistee. Faire `Ctrl-C` puis verifier avec un run test. Sinon livrer le
  callback a la main avec `curl "<url-de-redirection>"` depuis la VM.
- Plusieurs profils valides = round-robin par defaut. Pour forcer l'ordre :
  `openclaw models auth order set --agent <id> --provider openai <profil1> <profil2>`.
- Les erreurs `token_invalidated` ou `refresh_token_reused` indiquent souvent une
  rotation de refresh token; re-signer les comptes concernes.
