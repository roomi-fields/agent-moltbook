# Agent Moltbook

Agent OpenClaw de développement collaboratif, piloté par la communauté Moltbook.

## Concept

Cet agent demande aux agents de Moltbook ce qu'ils veulent comme outil/site, code les solutions via Codex CLI, et déploie automatiquement. Boucle continue : feedback -> dev -> deploy -> feedback.

## Architecture

```
SECOND PC (Windows + WSL2)
│
├── Docker container isolé
│   ├── OpenClaw (agent chef de projet)
│   │   └── LLM : Gemini 2.0 Flash (gratuit)
│   ├── Codex CLI (dev)
│   └── Projet web (workspace)
│       └── git push → GitHub
│
GitHub (ce repo)
│   └── GitHub Actions → deploy sur VPS
│
VPS Hostinger
    └── Container Docker isolé (site agent)
```

## Installation sur le second PC

```bash
curl -fsSL https://raw.githubusercontent.com/roomi-fields/agent-moltbook/main/bootstrap.sh | bash
```

Ou manuellement :

```bash
git clone https://github.com/roomi-fields/agent-moltbook.git
cd agent-moltbook
./bootstrap.sh
```

## Structure

```
agent-moltbook/
├── bootstrap.sh              # Script d'install pour WSL2
├── docker-compose.yml        # Container OpenClaw (second PC)
├── docker-compose.vps.yml    # Container site (VPS)
├── .github/workflows/
│   └── deploy.yml            # GitHub Actions deploy
├── config/
│   ├── SOUL.md               # Persona de l'agent
│   └── skills/
│       ├── codex-dev/
│       │   └── SKILL.md
│       └── moltbook-dev-loop/
│           └── SKILL.md
├── site/
│   ├── package.json
│   ├── changelog.json
│   └── src/
│       └── index.html
└── .env.example
```

## Workflow

Toutes les 6 heures :
1. L'agent lit les feedbacks sur Moltbook
2. Synthétise et priorise par votes
3. Codex implémente les changements
4. Git push -> deploy auto sur VPS
5. L'agent poste un update sur Moltbook
6. Notification Telegram

## Sécurité

- Container Docker isolé avec réseau restreint
- L'agent n'a JAMAIS les credentials SSH du VPS
- GitHub Actions seul pipeline vers le VPS
- Protection contre prompt injection
- Pas de crypto/finance
- Rate limiting : max 1 cycle / 6h

## Licence

MIT
