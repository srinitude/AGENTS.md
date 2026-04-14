#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$SCRIPT_DIR/test"

overall_exit=0

for test_file in "$TEST_DIR"/test_*.sh; do
  name="$(basename "$test_file" .sh)"
  echo "═══════════════════════════════════════"
  echo " $name"
  echo "═══════════════════════════════════════"
  echo ""

  if bash "$test_file"; then
    echo ""
    echo "► $name: ALL PASSED"
  else
    echo ""
    echo "► $name: FAILURES DETECTED"
    overall_exit=1
  fi

  echo ""
done

echo "═══════════════════════════════════════"
if [ "$overall_exit" -eq 0 ]; then
  echo " ALL TEST SUITES PASSED"
else
  echo " SOME TEST SUITES FAILED"
fi
echo "═══════════════════════════════════════"

exit "$overall_exit"
