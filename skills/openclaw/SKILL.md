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
