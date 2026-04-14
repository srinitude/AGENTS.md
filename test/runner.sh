#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0
ERRORS=()

assert_eq() {
  local label="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then
    PASS=$((PASS + 1))
    echo "  ✓ $label"
    return
  fi
  FAIL=$((FAIL + 1))
  ERRORS+=("  ✗ $label — expected: '$expected', got: '$actual'")
  echo "  ✗ $label"
}

assert_contains() {
  local label="$1" haystack="$2" needle="$3"
  if echo "$haystack" | grep -qF -- "$needle"; then
    PASS=$((PASS + 1))
    echo "  ✓ $label"
    return
  fi
  FAIL=$((FAIL + 1))
  ERRORS+=("  ✗ $label — expected to contain: '$needle'")
  echo "  ✗ $label"
}

assert_not_contains() {
  local label="$1" haystack="$2" needle="$3"
  if ! echo "$haystack" | grep -qF -- "$needle"; then
    PASS=$((PASS + 1))
    echo "  ✓ $label"
    return
  fi
  FAIL=$((FAIL + 1))
  ERRORS+=("  ✗ $label — expected NOT to contain: '$needle'")
  echo "  ✗ $label"
}

assert_file_exists() {
  local label="$1" path="$2"
  if [ -f "$path" ]; then
    PASS=$((PASS + 1))
    echo "  ✓ $label"
    return
  fi
  FAIL=$((FAIL + 1))
  ERRORS+=("  ✗ $label — file not found: $path")
  echo "  ✗ $label"
}

assert_file_not_exists() {
  local label="$1" path="$2"
  if [ ! -f "$path" ]; then
    PASS=$((PASS + 1))
    echo "  ✓ $label"
    return
  fi
  FAIL=$((FAIL + 1))
  ERRORS+=("  ✗ $label — file unexpectedly exists: $path")
  echo "  ✗ $label"
}

assert_file_not_empty() {
  local label="$1" path="$2"
  if [ -s "$path" ]; then
    PASS=$((PASS + 1))
    echo "  ✓ $label"
    return
  fi
  FAIL=$((FAIL + 1))
  ERRORS+=("  ✗ $label — file is empty: $path")
  echo "  ✗ $label"
}

print_results() {
  echo ""
  echo "Results: $PASS passed, $FAIL failed"
  if [ ${#ERRORS[@]} -gt 0 ]; then
    echo ""
    echo "Failures:"
    for err in "${ERRORS[@]}"; do
      echo "$err"
    done
  fi
  [ "$FAIL" -eq 0 ]
}
