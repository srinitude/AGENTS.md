#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
THIS_FILE="$SCRIPT_DIR/test_portability.sh"

source "$SCRIPT_DIR/runner.sh"

# ═══════════════════════════════════════
#  LINE ENDINGS: no CRLF in source files
# ═══════════════════════════════════════

echo "line endings: no CRLF in source files"

while IFS= read -r -d '' file; do
  rel="${file#"$REPO_DIR"/}"
  has_cr="$(tr -d '\r' < "$file" | cmp -s - "$file" && echo "no" || echo "yes")"
  assert_eq "$rel has no CRLF" "no" "$has_cr"
done < <(find "$REPO_DIR" -type f \( -name "*.md" -o -name "*.sh" -o -name "*.txt" \) -not -path "*/node_modules/*" -print0)

# ═══════════════════════════════════════
#  .gitattributes: enforces LF line endings
# ═══════════════════════════════════════

echo ""
echo "gitattributes: exists and enforces LF"

assert_file_exists ".gitattributes exists" "$REPO_DIR/.gitattributes"

if [ -f "$REPO_DIR/.gitattributes" ]; then
  ga_content="$(cat "$REPO_DIR/.gitattributes")"
else
  ga_content=""
fi
assert_contains "enforces LF for sh" "$ga_content" "*.sh"
assert_contains "enforces LF for md" "$ga_content" "*.md"
assert_contains "enforces LF for txt" "$ga_content" "*.txt"
assert_contains "uses eol=lf" "$ga_content" "eol=lf"

# ═══════════════════════════════════════
#  SCRIPTS: no platform-specific commands
# ═══════════════════════════════════════

echo ""
echo "portability: no GNU-only flags in install.sh"

check_gnu_flags() {
  local file="$1" rel="$2"
  local count

  count="$(grep -c 'sort -z' "$file" || true)"
  assert_eq "$rel has no sort -z" "0" "$count"

  count="$(grep -c 'grep -P' "$file" || true)"
  assert_eq "$rel has no grep -P" "0" "$count"

  count="$(grep -c 'sed -i' "$file" || true)"
  assert_eq "$rel has no sed -i" "0" "$count"

  count="$(grep -c 'readlink -f' "$file" || true)"
  assert_eq "$rel has no readlink -f" "0" "$count"
}

check_gnu_flags "$REPO_DIR/install.sh" "install.sh"

echo ""
echo "portability: no GNU-only flags in test scripts"

while IFS= read -r -d '' test_file; do
  [ "$test_file" = "$THIS_FILE" ] && continue
  rel="${test_file#"$REPO_DIR"/}"
  check_gnu_flags "$test_file" "$rel"
done < <(find "$REPO_DIR" -name "*.sh" -type f -not -path "$THIS_FILE" -print0)

# ═══════════════════════════════════════
#  SHEBANGS: all scripts use env bash
# ═══════════════════════════════════════

echo ""
echo "portability: shebangs use env bash"

while IFS= read -r -d '' file; do
  rel="${file#"$REPO_DIR"/}"
  first_line="$(head -1 "$file")"
  assert_eq "$rel shebang" "#!/usr/bin/env bash" "$first_line"
done < <(find "$REPO_DIR" -name "*.sh" -type f -print0)

# ═══════════════════════════════════════
#  GENERATED FILES: compose produces LF output
# ═══════════════════════════════════════

echo ""
echo "portability: generated files have LF line endings"

TMPDIR_PORT="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_PORT"' EXIT

bash "$REPO_DIR/install.sh" "$TMPDIR_PORT" code >/dev/null 2>&1
generated="$TMPDIR_PORT/AGENTS.md"

has_cr="$(tr -d '\r' < "$generated" | cmp -s - "$generated" && echo "no" || echo "yes")"
assert_eq "composed output has no CRLF" "no" "$has_cr"

echo ""
echo "portability: scattered files have LF line endings"

scatter_dir="$TMPDIR_PORT/scatter"
mkdir -p "$scatter_dir"
bash "$REPO_DIR/install.sh" --scatter "$scatter_dir" src:code docs:writing >/dev/null 2>&1

for f in "$scatter_dir/AGENTS.md" "$scatter_dir/src/AGENTS.md" "$scatter_dir/docs/AGENTS.md"; do
  rel="${f#"$scatter_dir"/}"
  has_cr="$(tr -d '\r' < "$f" | cmp -s - "$f" && echo "no" || echo "yes")"
  assert_eq "scatter $rel has no CRLF" "no" "$has_cr"
done

# ═══════════════════════════════════════
#  UTF-8: all content files are valid UTF-8
# ═══════════════════════════════════════

echo ""
echo "portability: all content files are valid UTF-8"

check_utf8() {
  python3 -c "
import sys
with open(sys.argv[1], 'rb') as f:
    try:
        f.read().decode('utf-8')
        print('yes')
    except:
        print('no')
" "$1"
}

while IFS= read -r -d '' file; do
  rel="${file#"$REPO_DIR"/}"
  is_valid="$(check_utf8 "$file")"
  assert_eq "$rel is valid UTF-8" "yes" "$is_valid"
done < <(find "$REPO_DIR" -type f \( -name "*.md" -o -name "*.sh" -o -name "*.txt" \) -print0)

# ═══════════════════════════════════════
#  TEMP DIRECTORIES: mktemp works without GNU flags
# ═══════════════════════════════════════

echo ""
echo "portability: mktemp usage is cross-platform"

while IFS= read -r -d '' test_file; do
  [ "$test_file" = "$THIS_FILE" ] && continue
  rel="${test_file#"$REPO_DIR"/}"
  has_template="$(grep -c 'mktemp.*-t\|mktemp.*--tmpdir' "$test_file" || true)"
  assert_eq "$rel uses portable mktemp" "0" "$has_template"
done < <(find "$REPO_DIR" -name "test_*.sh" -type f -print0)

# ═══════════════════════════════════════
#  PATH SEPARATORS: no hardcoded backslashes
# ═══════════════════════════════════════

echo ""
echo "portability: no hardcoded backslash paths"

while IFS= read -r -d '' script; do
  rel="${script#"$REPO_DIR"/}"
  has_backslash_path="$(grep -cE '\\\\[a-zA-Z]' "$script" || true)"
  assert_eq "$rel has no backslash paths" "0" "$has_backslash_path"
done < <(find "$REPO_DIR" -name "*.sh" -type f -print0)

echo ""
print_results
