#!/bin/bash

# Test suite for scripts/web-setup.sh
# Tests the setup script in various environments and scenarios

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SETUP_SCRIPT="$SCRIPT_DIR/web-setup.sh"
TESTS_PASSED=0
TESTS_FAILED=0

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_test() {
  echo -e "${BLUE}→ Test: $1${NC}"
}

log_pass() {
  echo -e "${GREEN}✓ PASS${NC}: $1"
  ((TESTS_PASSED++))
}

log_fail() {
  echo -e "${RED}✗ FAIL${NC}: $1"
  ((TESTS_FAILED++))
}

log_info() {
  echo -e "${YELLOW}ℹ INFO${NC}: $1"
}

# Cleanup temporary test files
cleanup() {
  rm -f "$TEMP_OUTPUT" "$TEMP_ERROR" 2>/dev/null
}

trap cleanup EXIT

# Test 1: Script exists and is executable
test_script_exists() {
  log_test "Script exists and is executable"

  if [ ! -f "$SETUP_SCRIPT" ]; then
    log_fail "Setup script not found at $SETUP_SCRIPT"
    return 1
  fi

  if [ ! -x "$SETUP_SCRIPT" ]; then
    log_fail "Setup script is not executable"
    return 1
  fi

  log_pass "Script exists and is executable"
  return 0
}

# Test 2: Script runs with default environment (local mode)
test_default_local_mode() {
  log_test "Script runs in default/local mode"

  TEMP_OUTPUT=$(mktemp)
  TEMP_ERROR=$(mktemp)

  cd "$PROJECT_DIR"

  if bash "$SETUP_SCRIPT" >"$TEMP_OUTPUT" 2>"$TEMP_ERROR"; then
    if grep -q "Running locally or in unsupported environment" "$TEMP_OUTPUT" || \
       grep -q "Setup Complete" "$TEMP_OUTPUT"; then
      log_pass "Script exits successfully in local mode"
      return 0
    else
      log_fail "Script output doesn't indicate local mode or completion"
      log_info "Output was: $(cat "$TEMP_OUTPUT")"
      return 1
    fi
  else
    log_fail "Script failed to run in local mode"
    log_info "Error output: $(cat "$TEMP_ERROR")"
    return 1
  fi
}

# Test 3: Script runs with CLAUDE_CODE_REMOTE=true (cloud mode)
test_cloud_mode() {
  log_test "Script runs in cloud mode (CLAUDE_CODE_REMOTE=true)"

  TEMP_OUTPUT=$(mktemp)
  TEMP_ERROR=$(mktemp)

  cd "$PROJECT_DIR"

  if CLAUDE_CODE_REMOTE=true bash "$SETUP_SCRIPT" >"$TEMP_OUTPUT" 2>"$TEMP_ERROR"; then
    if grep -q "Running in cloud environment" "$TEMP_OUTPUT"; then
      log_pass "Script correctly identifies cloud environment"
      return 0
    else
      log_fail "Script doesn't recognize cloud mode"
      log_info "Output was: $(cat "$TEMP_OUTPUT")"
      return 1
    fi
  else
    log_fail "Script failed to run in cloud mode"
    log_info "Error output: $(cat "$TEMP_ERROR")"
    return 1
  fi
}

# Test 4: Script runs with CLAUDE_CODE_REMOTE=false (explicit local mode)
test_explicit_local_mode() {
  log_test "Script runs with CLAUDE_CODE_REMOTE=false"

  TEMP_OUTPUT=$(mktemp)
  TEMP_ERROR=$(mktemp)

  cd "$PROJECT_DIR"

  if CLAUDE_CODE_REMOTE=false bash "$SETUP_SCRIPT" >"$TEMP_OUTPUT" 2>"$TEMP_ERROR"; then
    if grep -q "Running locally or in unsupported environment" "$TEMP_OUTPUT"; then
      log_pass "Script correctly handles explicit local mode"
      return 0
    else
      log_fail "Script doesn't recognize explicit local mode"
      log_info "Output was: $(cat "$TEMP_OUTPUT")"
      return 1
    fi
  else
    log_fail "Script failed with explicit local mode"
    log_info "Error output: $(cat "$TEMP_ERROR")"
    return 1
  fi
}

# Test 5: Script uses relative paths (working from project directory)
test_relative_paths() {
  log_test "Script uses relative paths from project directory"

  TEMP_OUTPUT=$(mktemp)
  TEMP_ERROR=$(mktemp)

  # Change to project directory and run script with relative path
  cd "$PROJECT_DIR"

  if bash scripts/web-setup.sh >"$TEMP_OUTPUT" 2>"$TEMP_ERROR"; then
    if grep -q "Working directory:" "$TEMP_OUTPUT"; then
      log_pass "Script reports working directory correctly"
      return 0
    else
      log_fail "Script doesn't report working directory"
      return 1
    fi
  else
    log_fail "Script failed when run from project directory"
    return 1
  fi
}

# Test 6: Script sets up exit code correctly
test_exit_code() {
  log_test "Script exits with code 0 on success"

  cd "$PROJECT_DIR"

  bash "$SETUP_SCRIPT" >/dev/null 2>&1
  local exit_code=$?

  if [ "$exit_code" -eq 0 ]; then
    log_pass "Script exits with code 0"
    return 0
  else
    log_fail "Script exits with code $exit_code instead of 0"
    return 1
  fi
}

# Test 7: Script has shebang and uses set -e
test_script_quality() {
  log_test "Script has proper shebang and error handling"

  if head -1 "$SETUP_SCRIPT" | grep -q "^#!/bin/bash"; then
    log_pass "Script has correct shebang"
  else
    log_fail "Script missing or has incorrect shebang"
    return 1
  fi

  if grep -q "set -e" "$SETUP_SCRIPT"; then
    log_pass "Script uses 'set -e' for error handling"
    return 0
  else
    log_fail "Script missing 'set -e' directive"
    return 1
  fi
}

# Test 8: Script outputs expected key messages
test_output_messages() {
  log_test "Script outputs expected messages"

  TEMP_OUTPUT=$(mktemp)
  TEMP_ERROR=$(mktemp)

  cd "$PROJECT_DIR"
  bash "$SETUP_SCRIPT" >"$TEMP_OUTPUT" 2>"$TEMP_ERROR"

  local missing_messages=0

  local expected_messages=(
    "Claude Code Web Setup Script"
    "Environment:"
    "Working directory:"
    "Setup Complete"
  )

  for msg in "${expected_messages[@]}"; do
    if ! grep -q "$msg" "$TEMP_OUTPUT"; then
      log_fail "Missing expected message: '$msg'"
      missing_messages=$((missing_messages + 1))
    fi
  done

  if [ $missing_messages -eq 0 ]; then
    log_pass "All expected messages present"
    return 0
  else
    return 1
  fi
}

# Test 9: CLAUDE_PROJECT_DIR handling when set
test_claude_project_dir() {
  log_test "Script handles CLAUDE_PROJECT_DIR environment variable"

  TEMP_OUTPUT=$(mktemp)
  TEMP_ERROR=$(mktemp)

  cd "$PROJECT_DIR"

  if CLAUDE_PROJECT_DIR="$PROJECT_DIR" bash "$SETUP_SCRIPT" >"$TEMP_OUTPUT" 2>"$TEMP_ERROR"; then
    if grep -q "Project directory:" "$TEMP_OUTPUT"; then
      log_pass "Script processes CLAUDE_PROJECT_DIR variable"
      return 0
    else
      log_fail "Script doesn't show project directory info"
      return 1
    fi
  else
    log_fail "Script failed with CLAUDE_PROJECT_DIR set"
    return 1
  fi
}

# Test 10: Script works from different directories
test_different_directories() {
  log_test "Script is portable (works from different directories)"

  TEMP_OUTPUT=$(mktemp)
  TEMP_ERROR=$(mktemp)

  # Test from project root
  cd "$PROJECT_DIR"
  if ! bash scripts/web-setup.sh >"$TEMP_OUTPUT" 2>"$TEMP_ERROR"; then
    log_fail "Script failed when run from project root"
    return 1
  fi

  # Test with absolute path
  if ! bash "$SETUP_SCRIPT" >"$TEMP_OUTPUT" 2>"$TEMP_ERROR"; then
    log_fail "Script failed when run with absolute path"
    return 1
  fi

  log_pass "Script is portable across different invocation methods"
  return 0
}

# Main test runner
main() {
  echo -e "${BLUE}===============================================${NC}"
  echo -e "${BLUE}Claude Code Setup Script Test Suite${NC}"
  echo -e "${BLUE}===============================================${NC}"
  echo ""

  # Run all tests
  test_script_exists
  test_default_local_mode
  test_cloud_mode
  test_explicit_local_mode
  test_relative_paths
  test_exit_code
  test_script_quality
  test_output_messages
  test_claude_project_dir
  test_different_directories

  # Summary
  echo ""
  echo -e "${BLUE}===============================================${NC}"
  echo -e "${BLUE}Test Results${NC}"
  echo -e "${BLUE}===============================================${NC}"
  echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
  echo -e "${RED}Failed: $TESTS_FAILED${NC}"
  echo ""

  if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
  else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
  fi
}

# Run tests
main
