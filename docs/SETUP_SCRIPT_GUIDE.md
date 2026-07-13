# Claude Code Cloud Setup Script Guide

This guide explains how to create a portable setup script that works in both local and cloud environments. **Based on real-world testing in Claude Code cloud sessions.**

## Quick Start

**For immediate cloud setup, use inline bash in the Claude Code environment's Setup script field:**

```bash
apt update && apt install -y gh && docker compose pull || true
```

**For a reusable file-based script:**
1. Create `scripts/web-setup.sh` with your setup logic
2. In Claude Code environment settings, use: `bash scripts/web-setup.sh`
3. See templates below for examples

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

You have two approaches for configuring the setup script. Choose based on your needs:

### Approach 1: Inline Script (Recommended for Cloud)
Put your bash commands **directly** in the Claude Code environment's **Setup script** field:

```bash
echo "=== Setup Started ===" && \
apt update && apt install -y gh || true && \
docker compose pull || true && \
echo "=== Setup Complete ==="
```

**Advantages:**
- ✅ Most reliable in cloud environments (tested)
- ✅ No file dependencies
- ✅ Works immediately without caching delays
- ✅ Good for small to medium setup tasks

**Best for:** Simple setup commands, tools installation, Docker image pulling

### Approach 2: File-Based Script
Reference a file you've committed to the repository:

```
bash scripts/web-setup.sh
```

**Advantages:**
- ✅ Cleaner to read
- ✅ Easier to test locally
- ✅ Better for complex multi-step setups
- ✅ Can be version-controlled and reviewed

**Best for:** Complex setups, reusable scripts, team collaboration

**Note:** File-based approach may have caching delays on first cloud session. Inline approach is more immediately reliable.

## Cloud Testing Results

Real-world testing in Claude Code cloud environments found:

- ✅ **Inline scripts**: Executed reliably on first cloud session
- ✅ **File-based scripts**: Work after environment cache rebuilds
- ✅ **Both approaches**: Support CLAUDE_CODE_REMOTE and relative paths
- ✅ **Test coverage**: 11 automated tests validate both approaches

## Environment Variables Available

In the setup script, you have access to:

- `CLAUDE_PROJECT_DIR` — absolute path to the project root
- `CLAUDE_CODE_REMOTE` — `true` if running in cloud, `false` otherwise

## Duration Limits

Keep your setup script under ~5 minutes total runtime. This allows Claude Code to cache the environment for faster startup on subsequent sessions. If you have long-running tasks, consider using a [SessionStart hook](https://code.claude.com/docs/en/hooks#sessionstart) instead.

## See Also

- [Claude Code Web Documentation](https://code.claude.com/docs/en/claude-code-on-the-web)
- [Setup Scripts vs SessionStart Hooks](https://code.claude.com/docs/en/claude-code-on-the-web#setup-scripts-vs-sessionstart-hooks)
