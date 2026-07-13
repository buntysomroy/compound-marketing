# Claude Code Cloud Setup Script Guide

This guide explains how to create a portable setup script that works in both local and cloud environments.

## Overview

Setup scripts run before Claude Code launches in cloud sessions. They're useful for:
- Installing dependencies not pre-installed in the cloud
- Pulling Docker images
- Setting up environment-specific tools
- Pre-caching large downloads

## Key Principles

### 1. Use Relative Paths Only
❌ **Wrong:**
```bash
cd /home/user/my-project
cd /absolute/path/to/something
```

✅ **Correct:**
```bash
# Working directory is already the project root
bash scripts/something.sh
# Or explicitly use the project directory variable:
bash "$CLAUDE_PROJECT_DIR/scripts/something.sh"
```

### 2. Check for Cloud Environment
Not all setup needs to run in cloud. Use the `CLAUDE_CODE_REMOTE` environment variable:

```bash
#!/bin/bash
set -e

if [ "$CLAUDE_CODE_REMOTE" = "true" ]; then
  # Cloud-only setup
  docker compose pull
  apt install -y my-tool
else
  # Local-only or optional setup
  npm install
fi
```

### 3. Handle Failures Gracefully
Use `|| true` for non-critical commands to prevent setup failure on intermittent errors:

```bash
apt update && apt install -y optional-tool || true
```

## Template

Here's a complete template you can adapt:

```bash
#!/bin/bash
set -e

echo "=== Setup Script Started ==="

# Only run cloud-specific setup in cloud environments
if [ "$CLAUDE_CODE_REMOTE" = "true" ]; then
  echo "• Installing cloud-only dependencies..."
  
  # Example installations
  apt update && apt install -y gh || true
  docker compose pull || true
  
  echo "✓ Cloud setup complete"
fi

# Shared setup (runs in both cloud and local)
echo "• Running shared setup..."
# Your commands here

echo "=== Setup Complete ==="
exit 0
```

## Testing

### Test Locally
```bash
bash scripts/web-setup.sh
```

### Test in Cloud Mode
```bash
CLAUDE_CODE_REMOTE=true bash scripts/web-setup.sh
```

### Test in Local Mode
```bash
CLAUDE_CODE_REMOTE=false bash scripts/web-setup.sh
```

## Configuration in Claude Code

In your Claude Code web environment settings, set the **Setup script** field to:

```
bash scripts/web-setup.sh
```

That's it! No absolute paths, no `cd` commands needed.

## Environment Variables Available

In the setup script, you have access to:

- `CLAUDE_PROJECT_DIR` — absolute path to the project root
- `CLAUDE_CODE_REMOTE` — `true` if running in cloud, `false` otherwise

## Duration Limits

Keep your setup script under ~5 minutes total runtime. This allows Claude Code to cache the environment for faster startup on subsequent sessions. If you have long-running tasks, consider using a [SessionStart hook](https://code.claude.com/docs/en/hooks#sessionstart) instead.

## See Also

- [Claude Code Web Documentation](https://code.claude.com/docs/en/claude-code-on-the-web)
- [Setup Scripts vs SessionStart Hooks](https://code.claude.com/docs/en/claude-code-on-the-web#setup-scripts-vs-sessionstart-hooks)
