# Claude Cloud Environment Setup Plugin - Implementation Plan

**Repository:** `buntysomroy/claude-cloud-environment-setup` (to be created)  
**Status:** Planning phase  
**Created:** 2026-07-13

---

## Overview

A standalone Claude Code plugin that automates and guides the setup of Claude Code cloud environments. Two complementary skills manage the complete lifecycle of cloud environment configuration.

### Problem Solved

- Users struggle to configure Claude Code cloud environments correctly
- Setup scripts need updating as project requirements evolve
- Claude cannot programmatically update Claude Code environment settings
- Manual steps to apply setup scripts are unclear and error-prone

### Solution

Two interactive skills that:
1. **Analyze** repository requirements
2. **Ask** users what they need
3. **Generate** setup scripts
4. **Guide** users through manual application steps

---

## Architecture

### Skill 1: `/cloud-setup-guide` (Initial Setup)

**Purpose:** Create initial cloud environment setup from scratch

**Workflow:**
1. User runs `/cloud-setup-guide` in Claude desktop
2. Skill scans repository for:
   - `package.json` (Node.js dependencies)
   - `requirements.txt` / `pyproject.toml` (Python dependencies)
   - `Dockerfile` (Docker requirements)
   - `.github/workflows/` (CI/CD insights)
   - `docker-compose.yml` (Services to run)
   - Other framework-specific configs

3. Checks GitHub integration:
   - Is GitHub connector installed?
   - If multiple: asks which one to use
   - Validates access

4. Interactive questions:
   - "Which of these tools do you need in cloud?"
   - "Any additional packages to install?"
   - "Do you need Docker images pulled?"
   - "Any custom setup steps?"

5. Generates setup script with:
   - Environment detection (`CLAUDE_CODE_REMOTE`)
   - Tool installations
   - Docker operations
   - Custom logic

6. Guides user:
   ```
   Your setup script is ready!
   
   To apply it:
   1. Go to https://claude.ai/code
   2. Click the cloud icon (top right)
   3. Create or edit an environment
   4. Scroll to "Setup script" field
   5. Paste this code:
   [GENERATED SCRIPT]
   ```

7. Provides test command:
   ```bash
   CLAUDE_CODE_REMOTE=true bash scripts/web-setup.sh
   ```

---

### Skill 2: `/update-cloud-setup` (Maintenance)

**Purpose:** Update existing cloud setup as project needs evolve

**Workflow:**
1. User runs `/update-cloud-setup` when project changes
2. Skill reads canonical setup script:
   - `scripts/web-setup.sh` (if exists)
   - Or existing setup from user

3. Analyzes current setup:
   - Parses existing configuration
   - Identifies what's already set up
   - Shows current state

4. Interactive questions:
   - "What new tools/dependencies to add?"
   - "Remove anything?"
   - "Update existing sections?"

5. Merges with existing script:
   - Preserves working configurations
   - Adds new requirements
   - Removes deprecated items
   - Maintains best practices

6. Shows diff:
   ```
   Current setup:
   [EXISTING]
   
   Proposed changes:
   + apt install -y new-tool
   - remove old-dependency
   
   New setup:
   [MERGED VERSION]
   ```

7. Same guidance to apply in claude.ai/code

---

## Technical Implementation

### Repository Structure

```
claude-cloud-environment-setup/
├── README.md
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── skills/
│   ├── cloud-setup-guide/
│   │   ├── cloud-setup-guide.md
│   │   └── (skill definition)
│   └── update-cloud-setup/
│       ├── update-cloud-setup.md
│       └── (skill definition)
├── templates/
│   ├── setup-script-template.sh
│   └── inline-setup-template.sh
├── reference/
│   ├── SETUP_GUIDE.md (from compound-marketing)
│   ├── TESTING_GUIDE.md (from compound-marketing)
│   └── BEST_PRACTICES.md
└── docs/
    └── ARCHITECTURE.md
```

### Plugin Metadata

**plugin.json:**
- Name: Claude Cloud Environment Setup
- Version: 0.1.0
- Author: Bunty Somroy / Red Pine Digital
- Description: Interactive skills for Claude Code cloud environment configuration
- Skills: cloud-setup-guide, update-cloud-setup

**marketplace.json:**
- Source: buntysomroy/claude-cloud-environment-setup
- Categories: DevOps, Claude Code, Setup
- Tags: cloud, environment, automation, setup-scripts

---

## Key Features

### Skill 1: `/cloud-setup-guide`

**Capabilities:**
- ✅ Scan repositories for dependency patterns
- ✅ Detect common frameworks/languages
- ✅ Check GitHub connector status
- ✅ Interactive dependency selection
- ✅ Generate inline or file-based setup scripts
- ✅ Provide step-by-step application guidance
- ✅ Generate test commands

**Inputs:**
- Repository directory (auto-detected or specified)
- User preferences (interactive)

**Outputs:**
- Generated setup script (bash)
- Application instructions with links
- Test command

---

### Skill 2: `/update-cloud-setup`

**Capabilities:**
- ✅ Read existing setup script files
- ✅ Parse and analyze current configuration
- ✅ Merge new requirements with existing setup
- ✅ Show diffs before applying
- ✅ Validate script syntax
- ✅ Preserve existing configurations

**Inputs:**
- Path to existing setup script (auto-detected: `scripts/web-setup.sh`)
- New requirements (interactive)
- Merge strategy preferences

**Outputs:**
- Updated setup script
- Diff/changelog
- Application instructions

---

## Integration Points

### Dependencies

From compound-marketing repo:
- `scripts/web-setup.sh` — Template to adapt
- `scripts/test-setup.sh` — Use for validation
- `docs/SETUP_SCRIPT_GUIDE.md` — Copy to reference/
- `docs/TESTING_SETUP_SCRIPT.md` — Copy to reference/

### External APIs

- GitHub API (via MCP) — read repository contents
- Claude Code API — None (manual user steps for env updates)

### Limitations

- ⚠️ Cannot programmatically update Claude Code environment settings
- ⚠️ User must manually paste script into claude.ai/code UI
- Solution: Clear, guided instructions with direct links

---

## Testing Strategy

### Unit Testing
- Script generation with various input combinations
- Parsing of existing setup scripts
- Diff generation logic

### Integration Testing
- Test with sample repositories (Node.js, Python, Multi-language)
- Verify GitHub connector detection
- Validate generated scripts with `test-setup.sh`

### Manual Testing
- Run `/cloud-setup-guide` on compound-marketing repo
- Run `/update-cloud-setup` with existing setup
- Verify application workflow in claude.ai/code

---

## Rollout Plan

### Phase 1: Foundation (Week 1)
- [ ] Create repository
- [ ] Set up plugin structure
- [ ] Copy reference docs from compound-marketing
- [ ] Implement skill 1: `/cloud-setup-guide`
- [ ] Test with compound-marketing repo

### Phase 2: Maintenance (Week 2)
- [ ] Implement skill 2: `/update-cloud-setup`
- [ ] Integration testing between skills
- [ ] Documentation and examples

### Phase 3: Polish (Week 3)
- [ ] Error handling and edge cases
- [ ] User experience refinement
- [ ] Marketplace metadata

### Phase 4: Release (Week 4)
- [ ] Publish to marketplace
- [ ] Create demo/tutorial
- [ ] Gather user feedback

---

## Success Criteria

✅ Users can bootstrap cloud environments in <5 minutes  
✅ Setup scripts are repeatable and testable  
✅ Documentation is clear and actionable  
✅ Skills handle common repository patterns  
✅ Guidance prevents common errors  

---

## Related Documentation

- [Claude Code Cloud Setup Guide](./SETUP_SCRIPT_GUIDE.md)
- [Setup Script Testing Guide](./TESTING_SETUP_SCRIPT.md)

## Files to Copy

When creating new repository, copy these from compound-marketing:
- `docs/SETUP_SCRIPT_GUIDE.md` → `reference/SETUP_GUIDE.md`
- `docs/TESTING_SETUP_SCRIPT.md` → `reference/TESTING_GUIDE.md`
- `scripts/web-setup.sh` → `templates/setup-script-template.sh`
- `scripts/test-setup.sh` → `tools/test-setup.sh`

---

## Notes

- Plugin will be public and installable from marketplace
- Designed for Claude desktop app
- Web-only skills (for claude.ai/code sessions) can be added later
- Initially targets Node.js, Python, Docker workflows
- Extensible for other frameworks

