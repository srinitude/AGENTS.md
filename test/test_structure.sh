#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$SCRIPT_DIR/runner.sh"

# ── Repo structure ──

echo "repo: required files exist"

assert_file_exists "root AGENTS.md exists" "$REPO_DIR/AGENTS.md"
assert_file_exists "README.md exists" "$REPO_DIR/README.md"
assert_file_exists "LICENSE exists" "$REPO_DIR/LICENSE"
assert_file_exists "install.sh exists" "$REPO_DIR/install.sh"
assert_file_exists "install.sh is executable" "$REPO_DIR/install.sh"

is_executable="$([ -x "$REPO_DIR/install.sh" ] && echo "yes" || echo "no")"
assert_eq "install.sh has execute permission" "yes" "$is_executable"

# ── Every domain directory has an AGENTS.md ──

echo ""
echo "repo: domain directories"

domain_count=0
while IFS= read -r -d '' file; do
  domain_count=$((domain_count + 1))
done < <(find "$REPO_DIR" -name "AGENTS.md" -not -path "$REPO_DIR/AGENTS.md" -print0)

assert_eq "at least one domain exists" "1" "$([ "$domain_count" -ge 1 ] && echo 1 || echo 0)"

# ── Root AGENTS.md structural contracts ──

echo ""
echo "root AGENTS.md: structural contracts"

root_content="$(cat "$REPO_DIR/AGENTS.md")"

assert_contains "defines hierarchy rules" "$root_content" "Hierarchy"
assert_contains "defines enforcement" "$root_content" "Enforcement"
assert_contains "addresses inheritance" "$root_content" "root authority"
assert_contains "addresses contradictions" "$root_content" "contradicts"
assert_contains "supports unlimited nesting" "$root_content" "Nesting depth is unlimited"
assert_contains "constraints accumulate downward" "$root_content" "never remove"

# ── Root AGENTS.md: core principles present ──

echo ""
echo "root AGENTS.md: core principles"

assert_contains "constraints produce quality" "$root_content" "Constraints"
assert_contains "process over output" "$root_content" "Process"
assert_contains "observable behavior" "$root_content" "Observable"
assert_contains "explicit over implicit" "$root_content" "Explicit"
assert_contains "small focused units" "$root_content" "Small"
assert_contains "earned output" "$root_content" "Earned"

# ── All AGENTS.md files: content quality ──

echo ""
echo "all AGENTS.md: content quality"

while IFS= read -r -d '' file; do
  rel="${file#"$REPO_DIR"/}"

  assert_file_not_empty "$rel is not empty" "$file"

  content="$(cat "$file")"
  line_count="$(echo "$content" | wc -l | tr -d ' ')"
  has_substance="$([ "$line_count" -ge 10 ] && echo "yes" || echo "no")"
  assert_eq "$rel has substance (>=10 lines)" "yes" "$has_substance"

  has_sections="$(echo "$content" | grep -c "^## " || true)"
  has_enough_sections="$([ "$has_sections" -ge 2 ] && echo "yes" || echo "no")"
  assert_eq "$rel has sections (>=2 ## headings)" "yes" "$has_enough_sections"

  has_bullets="$(echo "$content" | grep -c "^\* " || true)"
  has_enough_bullets="$([ "$has_bullets" -ge 3 ] && echo "yes" || echo "no")"
  assert_eq "$rel uses bullet constraints (>=3)" "yes" "$has_enough_bullets"

  has_must_or_shall="$(echo "$content" | grep -ciE "(must|shall|prohibited|required|enforce|never|always|strictly)" || true)"
  is_imperative="$([ "$has_must_or_shall" -ge 3 ] && echo "yes" || echo "no")"
  assert_eq "$rel uses imperative language" "yes" "$is_imperative"

done < <(find "$REPO_DIR" -name "AGENTS.md" -print0)

# ── README references all domains ──

echo ""
echo "README.md: domain coverage"

readme="$(cat "$REPO_DIR/README.md")"

while IFS= read -r -d '' file; do
  rel="${file#"$REPO_DIR"/}"
  dir="$(dirname "$rel")"
  assert_contains "README mentions $dir" "$readme" "$dir"
done < <(find "$REPO_DIR" -name "AGENTS.md" -not -path "$REPO_DIR/AGENTS.md" -print0)

assert_contains "README documents install.sh" "$readme" "install.sh"

# ── llms.txt ──

echo ""
echo "llms.txt: exists and has required content"

assert_file_exists "llms.txt exists" "$REPO_DIR/llms.txt"
assert_file_not_empty "llms.txt is not empty" "$REPO_DIR/llms.txt"

llms_content="$(cat "$REPO_DIR/llms.txt")"

assert_contains "has title" "$llms_content" "agents-md"
assert_contains "describes what repo is" "$llms_content" "AGENTS.md"
assert_contains "explains install.sh" "$llms_content" "install.sh"
assert_contains "explains compose mode" "$llms_content" "compose"
assert_contains "explains scatter mode" "$llms_content" "scatter"
assert_contains "lists code domain" "$llms_content" "code"
assert_contains "lists writing domain" "$llms_content" "writing"
assert_contains "explains hierarchy" "$llms_content" "hierarchy"
assert_contains "explains root AGENTS.md" "$llms_content" "root"
assert_contains "mentions testing" "$llms_content" "test"
assert_contains "mentions license" "$llms_content" "Apache"

# Verify all domain AGENTS.md files are referenced in llms.txt
while IFS= read -r -d '' file; do
  rel="${file#"$REPO_DIR"/}"
  assert_contains "llms.txt references $rel" "$llms_content" "$rel"
done < <(find "$REPO_DIR" -name "AGENTS.md" -not -path "$REPO_DIR/AGENTS.md" -print0)

# ── LICENSE ──

echo ""
echo "LICENSE: Apache 2.0"

license="$(cat "$REPO_DIR/LICENSE")"
assert_contains "is Apache 2.0" "$license" "Apache License"
assert_contains "is version 2.0" "$license" "Version 2.0"

echo ""
print_results
