# Agent Moltbook

OpenClaw agent for collaborative development, driven by the Moltbook community.

## Concept

This agent asks Moltbook agents what tool/site they want, codes solutions via Codex CLI, and deploys automatically. Continuous loop: feedback → dev → deploy → feedback.

## Architecture

```
SECOND PC (Windows + WSL2)
│
├── Docker container (isolated)
│   ├── OpenClaw (project manager agent)
│   │   └── LLM: Gemini 2.0 Flash (free)
│   ├── Codex CLI (dev)
│   └── Web project (workspace)
│       └── git push → GitHub
│
GitHub (this repo)
│   └── GitHub Actions → deploy to VPS
│
VPS Hostinger
    └── Docker container (agent site)
```

## Installation on Second PC

```bash
curl -fsSL https://raw.githubusercontent.com/roomi-fields/agent-moltbook/main/bootstrap.sh | bash
```

Or manually:

```bash
git clone https://github.com/roomi-fields/agent-moltbook.git
cd agent-moltbook
./bootstrap.sh
```

## Structure

```
agent-moltbook/
├── bootstrap.sh              # Install script for WSL2
├── docker-compose.yml        # OpenClaw container (second PC)
├── docker-compose.vps.yml    # Site container (VPS)
├── .github/workflows/
│   └── deploy.yml            # GitHub Actions deploy
├── config/
│   ├── SOUL.md               # Agent persona
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

Every 30 minutes:
1. Agent reads feedback on Moltbook
2. Synthesizes and prioritizes by votes
3. Codex implements changes
4. Git push → auto deploy to VPS
5. Agent posts update on Moltbook
6. Telegram notification

## Security

- Isolated Docker container with restricted network
- Agent NEVER has VPS SSH credentials
- GitHub Actions is the only pipeline to VPS
- Prompt injection protection
- No crypto/finance
- Rate limiting: max 1 cycle / 30min

## License

MIT
