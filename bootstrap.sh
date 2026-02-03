#!/bin/bash
# Bootstrap script for Agent Moltbook - WSL2 Ubuntu
# Idempotent: can be run multiple times safely

set -e

echo "=========================================="
echo "  Agent Moltbook - Bootstrap Script"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 already installed"
        return 0
    else
        return 1
    fi
}

# 1. Node.js 22+
echo "--- Checking Node.js ---"
if check_command node; then
    NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 22 ]; then
        echo -e "${YELLOW}Node.js version < 22, upgrading...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
else
    echo "Installing Node.js 22..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi
echo "Node.js: $(node --version)"

# 2. Git
echo ""
echo "--- Checking Git ---"
if ! check_command git; then
    echo "Installing Git..."
    sudo apt-get update
    sudo apt-get install -y git
fi
echo "Git: $(git --version)"

# 3. Docker
echo ""
echo "--- Checking Docker ---"
if ! check_command docker; then
    echo "Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo usermod -aG docker $USER
    echo -e "${YELLOW}! Docker installed. You may need to restart your terminal for group changes.${NC}"
fi
echo "Docker: $(docker --version 2>/dev/null || echo 'installed, restart terminal for access')"

# 4. OpenClaw
echo ""
echo "--- Checking OpenClaw ---"
if ! check_command openclaw; then
    echo "Installing OpenClaw..."
    npm install -g openclaw
fi
echo "OpenClaw: $(openclaw --version 2>/dev/null || echo 'installed')"

# 5. Codex CLI
echo ""
echo "--- Checking Codex CLI ---"
if ! check_command codex; then
    echo "Installing Codex CLI..."
    npm install -g @openai/codex
fi
echo "Codex CLI: $(codex --version 2>/dev/null || echo 'installed')"

# 6. Clone or update repo
echo ""
echo "--- Setting up workspace ---"
WORKSPACE_DIR="$HOME/workspace/agent-moltbook"
if [ -d "$WORKSPACE_DIR" ]; then
    echo "Workspace exists, pulling latest..."
    cd "$WORKSPACE_DIR"
    git pull origin main || true
else
    echo "Cloning repository..."
    mkdir -p "$HOME/workspace"
    cd "$HOME/workspace"
    git clone https://github.com/roomi-fields/agent-moltbook.git
fi

# 7. Copy configs to OpenClaw directory
echo ""
echo "--- Configuring OpenClaw ---"
OPENCLAW_DIR="$HOME/.openclaw"
mkdir -p "$OPENCLAW_DIR/skills"

# Copy SOUL.md
if [ -f "$WORKSPACE_DIR/config/SOUL.md" ]; then
    cp "$WORKSPACE_DIR/config/SOUL.md" "$OPENCLAW_DIR/SOUL.md"
    echo -e "${GREEN}✓${NC} SOUL.md copied to ~/.openclaw/"
fi

# Copy skills
if [ -d "$WORKSPACE_DIR/config/skills" ]; then
    cp -r "$WORKSPACE_DIR/config/skills/"* "$OPENCLAW_DIR/skills/"
    echo -e "${GREEN}✓${NC} Skills copied to ~/.openclaw/skills/"
fi

# 8. Summary
echo ""
echo "=========================================="
echo -e "${GREEN}  Bootstrap Complete!${NC}"
echo "=========================================="
echo ""
echo "Workspace: $WORKSPACE_DIR"
echo "OpenClaw config: $OPENCLAW_DIR"
echo ""
echo -e "${YELLOW}=== MANUAL STEPS REQUIRED ===${NC}"
echo ""
echo "1. Run OpenClaw onboarding:"
echo "   $ openclaw onboard"
echo "   - Choose Gemini 2.0 Flash as LLM"
echo "   - Get API key: https://aistudio.google.com/apikey"
echo "   - Setup Telegram bot via @BotFather"
echo ""
echo "2. Login to Codex CLI:"
echo "   $ codex --login"
echo ""
echo "3. Create .env file:"
echo "   $ cp $WORKSPACE_DIR/.env.example $WORKSPACE_DIR/.env"
echo "   $ nano $WORKSPACE_DIR/.env"
echo ""
echo "4. Join Moltbook (via Telegram to your agent):"
echo '   "Lis https://moltbook.com/skill.md et suis les instructions"'
echo ""
echo "5. Start the agent:"
echo "   $ cd $WORKSPACE_DIR"
echo "   $ docker compose up -d"
echo ""
