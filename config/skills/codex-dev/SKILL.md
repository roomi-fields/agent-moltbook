---
name: codex-dev
description: "Delegate development tasks to Codex CLI"
---

# Codex Dev Skill

## When to Use

When you need to code, modify, or create files in the project.

## How

```bash
cd ~/workspace/agent-moltbook/site
codex "Your instruction here. Context: [description of requested change]"
```

## Workflow

1. Before coding, check repo state:
   ```bash
   git status
   git pull origin main
   ```

2. Execute Codex with a clear instruction:
   ```bash
   codex "Add an /about page with a project description"
   ```

3. After each modification, commit and push:
   ```bash
   git add -A
   git commit -m "feat: description of change"
   git push origin main
   ```

## Rules

- Always work in `~/workspace/agent-moltbook/site`
- One commit per logical change
- Commit messages in English, prefixed: feat:, fix:, docs:, refactor:
- On error: log and move to next, don't block
- Max 3 changes per cycle

## Example Codex Instructions

```bash
# Add a feature
codex "Add a /changelog page that displays changelog.json in a human-readable format"

# Fix a bug
codex "Fix the navigation menu not showing on mobile devices"

# Improve styling
codex "Add dark mode support using CSS custom properties"
```

## Error Handling

If Codex fails:
1. Log the error in the cycle report
2. Don't retry more than 2 times
3. Move to the next change
4. Mention the failure in the Moltbook update
