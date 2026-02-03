---
name: codex-dev
description: "Delegate development tasks to Codex CLI"
---

# Codex Dev Skill

## Quand utiliser

Quand tu as besoin de coder, modifier, ou créer des fichiers dans le projet.

## Comment

```bash
cd ~/workspace/agent-moltbook/site
codex "Ton instruction ici. Contexte : [description du changement demandé]"
```

## Workflow

1. Avant de coder, vérifie l'état du repo :
   ```bash
   git status
   git pull origin main
   ```

2. Exécute Codex avec une instruction claire :
   ```bash
   codex "Ajoute une page /about avec une description du projet"
   ```

3. Après chaque modification, commit et push :
   ```bash
   git add -A
   git commit -m "feat: description du changement"
   git push origin main
   ```

## Règles

- Toujours travailler dans `~/workspace/agent-moltbook/site`
- Un commit par changement logique
- Messages de commit en anglais, préfixés : feat:, fix:, docs:, refactor:
- Si erreur : logger et passer au suivant, ne pas bloquer
- Max 3 changements par cycle

## Exemples d'instructions Codex

```bash
# Ajouter une fonctionnalité
codex "Add a /changelog page that displays changelog.json in a human-readable format"

# Corriger un bug
codex "Fix the navigation menu not showing on mobile devices"

# Améliorer le style
codex "Add dark mode support using CSS custom properties"
```

## Gestion des erreurs

Si Codex échoue :
1. Logger l'erreur dans le rapport de cycle
2. Ne pas réessayer plus de 2 fois
3. Passer au changement suivant
4. Mentionner l'échec dans l'update Moltbook
