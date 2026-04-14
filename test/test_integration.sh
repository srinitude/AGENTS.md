#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL="$REPO_DIR/install.sh"

source "$SCRIPT_DIR/runner.sh"

TMPDIR_BASE="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_BASE"' EXIT

new_target() {
  local dir="$TMPDIR_BASE/$(uuidgen 2>/dev/null || echo $$-$RANDOM)"
  mkdir -p "$dir"
  echo "$dir"
}

# ═══════════════════════════════════════
#  GREENFIELD: empty projects
# ═══════════════════════════════════════

echo "greenfield: empty directory, root only"

target="$(new_target)"
bash "$INSTALL" "$target" >/dev/null 2>&1

assert_file_exists "AGENTS.md created" "$target/AGENTS.md"
file_count="$(find "$target" -type f | wc -l | tr -d ' ')"
assert_eq "only one file created" "1" "$file_count"

# ── Greenfield: compose single domain ──

echo ""
echo "greenfield: compose single domain"

target="$(new_target)"
bash "$INSTALL" "$target" code >/dev/null 2>&1

assert_file_exists "AGENTS.md created" "$target/AGENTS.md"
file_count="$(find "$target" -type f | wc -l | tr -d ' ')"
assert_eq "only one file created" "1" "$file_count"

# ── Greenfield: compose all domains ──

echo ""
echo "greenfield: compose all domains"

target="$(new_target)"
bash "$INSTALL" "$target" architecture code data planning research writing >/dev/null 2>&1
content="$(cat "$target/AGENTS.md")"

assert_contains "has architecture" "$content" "# Domain: architecture"
assert_contains "has code" "$content" "# Domain: code"
assert_contains "has data" "$content" "# Domain: data"
assert_contains "has planning" "$content" "# Domain: planning"
assert_contains "has research" "$content" "# Domain: research"
assert_contains "has writing" "$content" "# Domain: writing"
assert_contains "has root" "$content" "Hierarchy & Inheritance"

domain_count="$(grep -c "^# Domain:" "$target/AGENTS.md")"
assert_eq "exactly 6 domain sections" "6" "$domain_count"

# ── Greenfield: scatter all domains ──

echo ""
echo "greenfield: scatter all domains"

target="$(new_target)"
bash "$INSTALL" --scatter "$target" \
  src:code docs:writing analysis:data design:architecture \
  specs:research roadmap:planning >/dev/null 2>&1

assert_file_exists "root AGENTS.md" "$target/AGENTS.md"
assert_file_exists "src/AGENTS.md" "$target/src/AGENTS.md"
assert_file_exists "docs/AGENTS.md" "$target/docs/AGENTS.md"
assert_file_exists "analysis/AGENTS.md" "$target/analysis/AGENTS.md"
assert_file_exists "design/AGENTS.md" "$target/design/AGENTS.md"
assert_file_exists "specs/AGENTS.md" "$target/specs/AGENTS.md"
assert_file_exists "roadmap/AGENTS.md" "$target/roadmap/AGENTS.md"

file_count="$(find "$target" -name "AGENTS.md" | wc -l | tr -d ' ')"
assert_eq "exactly 7 AGENTS.md files" "7" "$file_count"

root_content="$(cat "$target/AGENTS.md")"
assert_not_contains "root has no domain content" "$root_content" "# Domain:"

# ═══════════════════════════════════════
#  BROWNFIELD: projects with existing files
# ═══════════════════════════════════════

echo ""
echo "brownfield: preserves existing project files (compose)"

target="$(new_target)"
echo '{"name": "my-app"}' > "$target/package.json"
mkdir -p "$target/src"
echo "console.log('hello');" > "$target/src/index.js"
echo "# My App" > "$target/README.md"

bash "$INSTALL" "$target" code >/dev/null 2>&1

assert_file_exists "AGENTS.md created" "$target/AGENTS.md"
assert_file_exists "package.json preserved" "$target/package.json"
assert_file_exists "src/index.js preserved" "$target/src/index.js"
assert_file_exists "README.md preserved" "$target/README.md"

pkg_content="$(cat "$target/package.json")"
assert_contains "package.json untouched" "$pkg_content" "my-app"

js_content="$(cat "$target/src/index.js")"
assert_contains "index.js untouched" "$js_content" "console.log"

readme_content="$(cat "$target/README.md")"
assert_contains "README.md untouched" "$readme_content" "# My App"

# ── Brownfield: preserves existing files (scatter) ──

echo ""
echo "brownfield: preserves existing project files (scatter)"

target="$(new_target)"
mkdir -p "$target/src" "$target/docs"
echo "fn main() {}" > "$target/src/main.rs"
echo "# Architecture" > "$target/docs/design.md"
echo "[workspace]" > "$target/Cargo.toml"

bash "$INSTALL" --scatter "$target" src:code docs:writing >/dev/null 2>&1

assert_file_exists "src/main.rs preserved" "$target/src/main.rs"
assert_file_exists "docs/design.md preserved" "$target/docs/design.md"
assert_file_exists "Cargo.toml preserved" "$target/Cargo.toml"
assert_file_exists "src/AGENTS.md created" "$target/src/AGENTS.md"
assert_file_exists "docs/AGENTS.md created" "$target/docs/AGENTS.md"

rs_content="$(cat "$target/src/main.rs")"
assert_contains "main.rs untouched" "$rs_content" "fn main()"

# ── Brownfield: overwrites existing AGENTS.md ──

echo ""
echo "brownfield: overwrites existing AGENTS.md (compose)"

target="$(new_target)"
echo "Old rules that should be replaced." > "$target/AGENTS.md"

bash "$INSTALL" "$target" code >/dev/null 2>&1

content="$(cat "$target/AGENTS.md")"
assert_not_contains "old content gone" "$content" "Old rules that should be replaced"
assert_contains "new content present" "$content" "Hierarchy & Inheritance"
assert_contains "domain content present" "$content" "RED → GREEN → REFACTOR"

# ── Brownfield: overwrites existing AGENTS.md (scatter) ──

echo ""
echo "brownfield: overwrites existing AGENTS.md (scatter)"

target="$(new_target)"
echo "Old root rules." > "$target/AGENTS.md"
mkdir -p "$target/src"
echo "Old src rules." > "$target/src/AGENTS.md"

bash "$INSTALL" --scatter "$target" src:code >/dev/null 2>&1

root_content="$(cat "$target/AGENTS.md")"
assert_not_contains "old root gone" "$root_content" "Old root rules"
assert_contains "new root present" "$root_content" "Hierarchy & Inheritance"

src_content="$(cat "$target/src/AGENTS.md")"
assert_not_contains "old src gone" "$src_content" "Old src rules"
assert_contains "new src present" "$src_content" "RED → GREEN → REFACTOR"

# ── Brownfield: complex monorepo structure ──

echo ""
echo "brownfield: complex monorepo scatter"

target="$(new_target)"
mkdir -p "$target/packages/api/src"
mkdir -p "$target/packages/web/src"
mkdir -p "$target/docs/architecture"
mkdir -p "$target/docs/user-guide"
mkdir -p "$target/scripts"
mkdir -p "$target/data/pipelines"
mkdir -p "$target/.github/workflows"

echo "api code" > "$target/packages/api/src/server.ts"
echo "web code" > "$target/packages/web/src/app.tsx"
echo "deploy script" > "$target/scripts/deploy.sh"
echo "pipeline" > "$target/data/pipelines/etl.py"
echo "ci config" > "$target/.github/workflows/ci.yml"

bash "$INSTALL" --scatter "$target" \
  packages/api:code \
  packages/web:code \
  docs/architecture:architecture \
  docs/user-guide:writing \
  data/pipelines:data >/dev/null 2>&1

assert_file_exists "root AGENTS.md" "$target/AGENTS.md"
assert_file_exists "api AGENTS.md" "$target/packages/api/AGENTS.md"
assert_file_exists "web AGENTS.md" "$target/packages/web/AGENTS.md"
assert_file_exists "arch docs AGENTS.md" "$target/docs/architecture/AGENTS.md"
assert_file_exists "user guide AGENTS.md" "$target/docs/user-guide/AGENTS.md"
assert_file_exists "data AGENTS.md" "$target/data/pipelines/AGENTS.md"

assert_file_exists "api source preserved" "$target/packages/api/src/server.ts"
assert_file_exists "web source preserved" "$target/packages/web/src/app.tsx"
assert_file_exists "deploy script preserved" "$target/scripts/deploy.sh"
assert_file_exists "pipeline preserved" "$target/data/pipelines/etl.py"
assert_file_exists "ci config preserved" "$target/.github/workflows/ci.yml"

api_content="$(cat "$target/packages/api/AGENTS.md")"
web_content="$(cat "$target/packages/web/AGENTS.md")"
arch_content="$(cat "$target/docs/architecture/AGENTS.md")"
guide_content="$(cat "$target/docs/user-guide/AGENTS.md")"
data_content="$(cat "$target/data/pipelines/AGENTS.md")"

assert_contains "api has code rules" "$api_content" "RED → GREEN → REFACTOR"
assert_contains "web has code rules" "$web_content" "RED → GREEN → REFACTOR"
assert_contains "arch has architecture rules" "$arch_content" "Problem Before Solution"
assert_contains "guide has writing rules" "$guide_content" "Purpose Before Prose"
assert_contains "data has data rules" "$data_content" "Assumptions Before Transformations"

assert_file_not_exists "scripts has no AGENTS.md" "$target/scripts/AGENTS.md"
assert_file_not_exists ".github has no AGENTS.md" "$target/.github/AGENTS.md"

# ═══════════════════════════════════════
#  DOMAIN ISOLATION: no cross-contamination
# ═══════════════════════════════════════

echo ""
echo "domain isolation: each domain file is self-contained"

target="$(new_target)"
bash "$INSTALL" --scatter "$target" \
  a:code b:writing c:research d:data e:architecture f:planning >/dev/null 2>&1

pairs=(
  "a:RED → GREEN → REFACTOR"
  "b:Purpose Before Prose"
  "c:Question Before Investigation"
  "d:Assumptions Before Transformations"
  "e:Problem Before Solution"
  "f:Scope Decomposition"
)

for pair in "${pairs[@]}"; do
  dir="${pair%%:*}"
  marker="${pair#*:}"
  content="$(cat "$target/$dir/AGENTS.md")"
  assert_contains "$dir has its own rules" "$content" "$marker"
done

cross_checks=(
  "a:Purpose Before Prose"
  "a:Question Before Investigation"
  "b:RED → GREEN → REFACTOR"
  "b:Assumptions Before Transformations"
  "c:Purpose Before Prose"
  "c:Scope Decomposition"
  "d:Problem Before Solution"
  "d:RED → GREEN → REFACTOR"
  "e:Purpose Before Prose"
  "e:Scope Decomposition"
  "f:RED → GREEN → REFACTOR"
  "f:Question Before Investigation"
)

for pair in "${cross_checks[@]}"; do
  dir="${pair%%:*}"
  marker="${pair#*:}"
  content="$(cat "$target/$dir/AGENTS.md")"
  assert_not_contains "$dir has no foreign rules ($marker)" "$content" "$marker"
done

# ═══════════════════════════════════════
#  COMPOSE DOMAIN ORDERING
# ═══════════════════════════════════════

echo ""
echo "compose: domains appear in argument order"

target="$(new_target)"
bash "$INSTALL" "$target" writing code >/dev/null 2>&1
content="$(cat "$target/AGENTS.md")"

writing_pos="$(echo "$content" | grep -n "# Domain: writing" | head -1 | cut -d: -f1)"
code_pos="$(echo "$content" | grep -n "# Domain: code" | head -1 | cut -d: -f1)"

assert_eq "writing before code" "1" "$([ "$writing_pos" -lt "$code_pos" ] && echo 1 || echo 0)"

target="$(new_target)"
bash "$INSTALL" "$target" code writing >/dev/null 2>&1
content="$(cat "$target/AGENTS.md")"

code_pos="$(echo "$content" | grep -n "# Domain: code" | head -1 | cut -d: -f1)"
writing_pos="$(echo "$content" | grep -n "# Domain: writing" | head -1 | cut -d: -f1)"

assert_eq "code before writing" "1" "$([ "$code_pos" -lt "$writing_pos" ] && echo 1 || echo 0)"

# ═══════════════════════════════════════
#  CONTENT INTEGRITY: generated files are valid markdown
# ═══════════════════════════════════════

echo ""
echo "content integrity: generated files are valid"

target="$(new_target)"
bash "$INSTALL" "$target" architecture code data planning research writing >/dev/null 2>&1
content="$(cat "$target/AGENTS.md")"

null_count="$(tr -cd '\0' < "$target/AGENTS.md" | wc -c | tr -d ' ')"
assert_eq "no null bytes" "0" "$null_count"

has_trailing="$(tail -c 1 "$target/AGENTS.md" | wc -l | tr -d ' ')"
assert_eq "ends with newline" "1" "$has_trailing"

blank_line_count="$(grep -c '^$' "$target/AGENTS.md" || true)"
has_blanks="$([ "$blank_line_count" -ge 1 ] && echo "yes" || echo "no")"
assert_eq "has paragraph spacing" "yes" "$has_blanks"

# ── Content integrity: scatter files match source ──

echo ""
echo "content integrity: scatter files match domain source"

target="$(new_target)"
bash "$INSTALL" --scatter "$target" src:code docs:writing >/dev/null 2>&1

code_source="$(cat "$REPO_DIR/code/AGENTS.md")"
code_installed="$(cat "$target/src/AGENTS.md")"
assert_eq "code file matches source" "$code_source" "$code_installed"

writing_source="$(cat "$REPO_DIR/writing/AGENTS.md")"
writing_installed="$(cat "$target/docs/AGENTS.md")"
assert_eq "writing file matches source" "$writing_source" "$writing_installed"

# ── Content integrity: compose includes full domain content ──

echo ""
echo "content integrity: compose includes full domain content"

target="$(new_target)"
bash "$INSTALL" "$target" code >/dev/null 2>&1
composed="$(cat "$target/AGENTS.md")"
source_content="$(cat "$REPO_DIR/code/AGENTS.md")"

while IFS= read -r line; do
  [ -z "$line" ] && continue
  case "$line" in
    "---") continue ;;
  esac
  first_real_line="$line"
  break
done <<< "$source_content"

assert_contains "composed has first line of source" "$composed" "$first_real_line"

# ═══════════════════════════════════════
#  IDEMPOTENCY: all modes
# ═══════════════════════════════════════

echo ""
echo "idempotency: compose all domains"

target="$(new_target)"
bash "$INSTALL" "$target" architecture code data planning research writing >/dev/null 2>&1
first="$(cat "$target/AGENTS.md")"
bash "$INSTALL" "$target" architecture code data planning research writing >/dev/null 2>&1
second="$(cat "$target/AGENTS.md")"

first_size="${#first}"
second_size="${#second}"
assert_eq "compose is idempotent (size)" "$first_size" "$second_size"

echo ""
echo "idempotency: scatter all domains"

target="$(new_target)"
bash "$INSTALL" --scatter "$target" src:code docs:writing >/dev/null 2>&1
first_src="$(cat "$target/src/AGENTS.md")"
first_docs="$(cat "$target/docs/AGENTS.md")"

bash "$INSTALL" --scatter "$target" src:code docs:writing >/dev/null 2>&1
second_src="$(cat "$target/src/AGENTS.md")"
second_docs="$(cat "$target/docs/AGENTS.md")"

assert_eq "scatter src idempotent" "$first_src" "$second_src"
assert_eq "scatter docs idempotent" "$first_docs" "$second_docs"

# ═══════════════════════════════════════
#  EDGE CASES
# ═══════════════════════════════════════

echo ""
echo "edge case: target with spaces in path"

target="$TMPDIR_BASE/my project folder"
mkdir -p "$target"
bash "$INSTALL" "$target" code >/dev/null 2>&1

assert_file_exists "AGENTS.md in spaced path" "$target/AGENTS.md"
content="$(cat "$target/AGENTS.md")"
assert_contains "content correct in spaced path" "$content" "RED → GREEN → REFACTOR"

echo ""
echo "edge case: scatter with spaces in path"

target="$TMPDIR_BASE/another project"
mkdir -p "$target"
bash "$INSTALL" --scatter "$target" src:code >/dev/null 2>&1

assert_file_exists "root AGENTS.md in spaced path" "$target/AGENTS.md"
assert_file_exists "src AGENTS.md in spaced path" "$target/src/AGENTS.md"

echo ""
echo "edge case: same domain used twice in compose"

target="$(new_target)"
bash "$INSTALL" "$target" code code >/dev/null 2>&1
content="$(cat "$target/AGENTS.md")"

domain_count="$(grep -c "^# Domain: code" "$target/AGENTS.md")"
assert_eq "domain appears twice when specified twice" "2" "$domain_count"

echo ""
echo "edge case: current directory as target"

target="$(new_target)"
pushd "$target" >/dev/null
bash "$INSTALL" . code >/dev/null 2>&1
popd >/dev/null

assert_file_exists "AGENTS.md in current dir" "$target/AGENTS.md"

echo ""
echo "edge case: scatter same domain to multiple subdirs"

target="$(new_target)"
bash "$INSTALL" --scatter "$target" frontend:code backend:code >/dev/null 2>&1

assert_file_exists "frontend AGENTS.md" "$target/frontend/AGENTS.md"
assert_file_exists "backend AGENTS.md" "$target/backend/AGENTS.md"

fe_content="$(cat "$target/frontend/AGENTS.md")"
be_content="$(cat "$target/backend/AGENTS.md")"
assert_eq "same domain same content" "$fe_content" "$be_content"

echo ""
print_results
