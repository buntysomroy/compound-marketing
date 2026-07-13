#!/bin/bash
set -e

# Setup script for Claude Code cloud environments
# This script runs before Claude Code launches in cloud sessions
# It uses relative paths and environment variables for portability

echo "=== Claude Code Web Setup Script ==="
echo "Environment: $(uname -s) $(uname -m)"
echo "Working directory: $(pwd)"

# Only run cloud-specific setup in cloud environments
if [ "$CLAUDE_CODE_REMOTE" = "true" ]; then
  echo "✓ Running in cloud environment (CLAUDE_CODE_REMOTE=true)"

  # Example: Install tools that aren't pre-installed
  # apt update && apt install -y gh || true

  # Example: Pull Docker images if using docker compose
  # docker compose pull || true

  echo "✓ Cloud-specific setup complete"
else
  echo "• Running locally or in unsupported environment (CLAUDE_CODE_REMOTE != true)"
  echo "• Skipping cloud-specific setup"
fi

# Verify project directory is accessible
if [ -n "$CLAUDE_PROJECT_DIR" ]; then
  echo "✓ Project directory: $CLAUDE_PROJECT_DIR"
  ls -la "$CLAUDE_PROJECT_DIR" | head -5
else
  echo "• No CLAUDE_PROJECT_DIR set (expected in cloud)"
fi

echo "=== Setup Complete ==="
exit 0
