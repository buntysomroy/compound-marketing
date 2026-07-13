# Testing the Setup Script

This guide explains how to test `scripts/web-setup.sh` to ensure it works correctly in both local and cloud environments.

## Automated Testing

### Run the Full Test Suite

```bash
bash scripts/test-setup.sh
```

This runs 11 comprehensive tests covering:
- ✓ Script existence and executability
- ✓ Local mode behavior (default)
- ✓ Cloud mode behavior (CLAUDE_CODE_REMOTE=true)
- ✓ Explicit local mode (CLAUDE_CODE_REMOTE=false)
- ✓ Relative path handling
- ✓ Exit code correctness
- ✓ Script quality (shebang, error handling)
- ✓ Output message presence
- ✓ Environment variable handling (CLAUDE_PROJECT_DIR)
- ✓ Portability across invocation methods

All tests must pass before the script is considered production-ready.

### Test Output

Successful test run:

```
===============================================
Claude Code Setup Script Test Suite
===============================================

→ Test: Script exists and is executable
✓ PASS: Script exists and is executable

...

===============================================
Test Results
===============================================
Passed: 11
Failed: 0

All tests passed!
```

### Add Tests to CI/CD

To run tests in your GitHub Actions workflow, add:

```yaml
- name: Test setup script
  run: bash scripts/test-setup.sh
```

## Manual Testing

### Test in Default Mode (Local)

```bash
bash scripts/web-setup.sh
```

Expected output:
- Should print "Running locally or in unsupported environment"
- Should complete with "Setup Complete"
- Exit code: 0

### Test in Cloud Mode

```bash
CLAUDE_CODE_REMOTE=true bash scripts/web-setup.sh
```

Expected output:
- Should print "Running in cloud environment (CLAUDE_CODE_REMOTE=true)"
- Should complete with "Setup Complete"
- Exit code: 0

### Test with Cloud Project Directory

```bash
CLAUDE_CODE_REMOTE=true CLAUDE_PROJECT_DIR=/path/to/project bash scripts/web-setup.sh
```

Expected output:
- Should print "Project directory: /path/to/project"
- Should list first 5 files in the project directory
- Exit code: 0

## Test Coverage

The test suite covers:

| Feature | Coverage |
|---------|----------|
| Script execution | ✓ Multiple invocation methods |
| Environment modes | ✓ Local, cloud, and explicit modes |
| Environment variables | ✓ CLAUDE_CODE_REMOTE, CLAUDE_PROJECT_DIR |
| Path handling | ✓ Relative and absolute paths |
| Exit codes | ✓ Success and error scenarios |
| Output quality | ✓ Expected messages and formatting |
| Script quality | ✓ Shebang, error handling (set -e) |

## Troubleshooting Failed Tests

### If a test fails:

1. **Check the error message** — the test will indicate what failed
2. **Review the script** — examine `scripts/web-setup.sh` for issues
3. **Test manually** — run the failing scenario directly:
   ```bash
   bash scripts/web-setup.sh
   echo "Exit code: $?"
   ```
4. **Check environment** — ensure required tools/directories exist
5. **Review logs** — test output includes detailed error information

### Common Issues

**Script not executable:**
```bash
chmod +x scripts/web-setup.sh
```

**Path problems:**
- Ensure you run tests from the project root
- Check that `scripts/` directory exists
- Verify relative paths in the setup script

**Environment variables:**
- Use `export CLAUDE_CODE_REMOTE=true` for shell session testing
- Or inline: `CLAUDE_CODE_REMOTE=true bash scripts/web-setup.sh`

## Testing Best Practices

1. **Always run before commit** — ensure all tests pass before pushing changes
2. **Test both modes** — verify cloud and local behavior
3. **Test from different directories** — confirm relative path handling
4. **Check error handling** — verify the script fails gracefully on errors
5. **Review output** — ensure messages are clear and helpful

## Advanced Testing

### Test with Specific Environment Variables

```bash
# Test with custom project directory
CLAUDE_PROJECT_DIR=/custom/path bash scripts/web-setup.sh

# Test with both variables
CLAUDE_CODE_REMOTE=true CLAUDE_PROJECT_DIR=/app bash scripts/web-setup.sh

# Test in non-bash shell (for portability check)
sh scripts/web-setup.sh
```

### Capture Test Output for Review

```bash
# Save output for comparison
bash scripts/test-setup.sh > test-results.log 2>&1

# Review results
cat test-results.log
```

### Debug a Failing Test

```bash
# Run specific test manually
cd /path/to/project
CLAUDE_CODE_REMOTE=true bash scripts/web-setup.sh

# Add debug output
bash -x scripts/web-setup.sh  # Shows each command executed
```

## Continuous Testing

The test suite should be integrated into:
- Pre-commit hooks (test before committing)
- GitHub Actions (test on every push)
- Pull request checks (block merge if tests fail)

## See Also

- [SETUP_SCRIPT_GUIDE.md](./SETUP_SCRIPT_GUIDE.md) — How to write and configure setup scripts
- [Claude Code Web Documentation](https://code.claude.com/docs/en/claude-code-on-the-web)
