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
#  CODING LANGUAGES: project structures
# ═══════════════════════════════════════

echo "coding languages: Python project"

target="$(new_target)"
mkdir -p "$target/src/myapp" "$target/tests"
echo "def main(): pass" > "$target/src/myapp/__init__.py"
echo "import pytest" > "$target/tests/test_app.py"
echo "[tool.poetry]" > "$target/pyproject.toml"
echo "requirements.txt" > "$target/requirements.txt"

bash "$INSTALL" "$target" code >/dev/null 2>&1
assert_file_exists "Python: AGENTS.md created" "$target/AGENTS.md"
assert_file_exists "Python: source preserved" "$target/src/myapp/__init__.py"
assert_file_exists "Python: tests preserved" "$target/tests/test_app.py"

echo ""
echo "coding languages: Rust project"

target="$(new_target)"
mkdir -p "$target/src"
echo "fn main() {}" > "$target/src/main.rs"
echo "[package]" > "$target/Cargo.toml"
echo "target/" > "$target/.gitignore"

bash "$INSTALL" --scatter "$target" src:code >/dev/null 2>&1
assert_file_exists "Rust: root AGENTS.md" "$target/AGENTS.md"
assert_file_exists "Rust: src AGENTS.md" "$target/src/AGENTS.md"
assert_file_exists "Rust: main.rs preserved" "$target/src/main.rs"

echo ""
echo "coding languages: Go project"

target="$(new_target)"
mkdir -p "$target/cmd/server" "$target/internal/handler" "$target/pkg/util"
echo "package main" > "$target/cmd/server/main.go"
echo "package handler" > "$target/internal/handler/handler.go"
echo "module example.com/app" > "$target/go.mod"

bash "$INSTALL" --scatter "$target" cmd/server:code internal/handler:code >/dev/null 2>&1
assert_file_exists "Go: cmd AGENTS.md" "$target/cmd/server/AGENTS.md"
assert_file_exists "Go: handler AGENTS.md" "$target/internal/handler/AGENTS.md"
assert_file_exists "Go: main.go preserved" "$target/cmd/server/main.go"

echo ""
echo "coding languages: C project"

target="$(new_target)"
mkdir -p "$target/src" "$target/include" "$target/tests"
echo "#include <stdio.h>" > "$target/src/main.c"
echo "#ifndef APP_H" > "$target/include/app.h"
echo "CC=gcc" > "$target/Makefile"

bash "$INSTALL" "$target" code >/dev/null 2>&1
assert_file_exists "C: AGENTS.md created" "$target/AGENTS.md"
assert_file_exists "C: source preserved" "$target/src/main.c"
assert_file_exists "C: header preserved" "$target/include/app.h"
assert_file_exists "C: Makefile preserved" "$target/Makefile"

echo ""
echo "coding languages: Java/Kotlin project"

target="$(new_target)"
mkdir -p "$target/src/main/java/com/app" "$target/src/main/kotlin" "$target/src/test/java"
echo "package com.app;" > "$target/src/main/java/com/app/App.java"
echo "fun main() {}" > "$target/src/main/kotlin/Main.kt"
echo "<project>" > "$target/pom.xml"

bash "$INSTALL" --scatter "$target" src/main:code src/test:code >/dev/null 2>&1
assert_file_exists "Java: main AGENTS.md" "$target/src/main/AGENTS.md"
assert_file_exists "Java: test AGENTS.md" "$target/src/test/AGENTS.md"
assert_file_exists "Java: source preserved" "$target/src/main/java/com/app/App.java"

echo ""
echo "coding languages: Ruby project"

target="$(new_target)"
mkdir -p "$target/lib" "$target/spec"
echo "class App; end" > "$target/lib/app.rb"
echo "source 'https://rubygems.org'" > "$target/Gemfile"

bash "$INSTALL" "$target" code >/dev/null 2>&1
assert_file_exists "Ruby: AGENTS.md created" "$target/AGENTS.md"
assert_file_exists "Ruby: source preserved" "$target/lib/app.rb"

echo ""
echo "coding languages: Haskell project"

target="$(new_target)"
mkdir -p "$target/src" "$target/test"
echo "module Main where" > "$target/src/Main.hs"
echo "name: myapp" > "$target/package.yaml"

bash "$INSTALL" "$target" code >/dev/null 2>&1
assert_file_exists "Haskell: AGENTS.md created" "$target/AGENTS.md"
assert_file_exists "Haskell: source preserved" "$target/src/Main.hs"

echo ""
echo "coding languages: Swift project"

target="$(new_target)"
mkdir -p "$target/Sources/App" "$target/Tests"
echo "import Foundation" > "$target/Sources/App/main.swift"
echo "// swift-tools-version:5.5" > "$target/Package.swift"

bash "$INSTALL" --scatter "$target" Sources:code Tests:code >/dev/null 2>&1
assert_file_exists "Swift: Sources AGENTS.md" "$target/Sources/AGENTS.md"
assert_file_exists "Swift: Tests AGENTS.md" "$target/Tests/AGENTS.md"

echo ""
echo "coding languages: Elixir project"

target="$(new_target)"
mkdir -p "$target/lib" "$target/test"
echo "defmodule App do; end" > "$target/lib/app.ex"
echo "defp deps do [] end" > "$target/mix.exs"

bash "$INSTALL" "$target" code >/dev/null 2>&1
assert_file_exists "Elixir: AGENTS.md created" "$target/AGENTS.md"
assert_file_exists "Elixir: source preserved" "$target/lib/app.ex"

echo ""
echo "coding languages: PHP project"

target="$(new_target)"
mkdir -p "$target/src" "$target/vendor"
echo "<?php namespace App;" > "$target/src/App.php"
echo "{}" > "$target/composer.json"

bash "$INSTALL" "$target" code >/dev/null 2>&1
assert_file_exists "PHP: AGENTS.md created" "$target/AGENTS.md"
assert_file_exists "PHP: source preserved" "$target/src/App.php"

# ═══════════════════════════════════════
#  CODING LANGUAGES: code/AGENTS.md is language-agnostic
# ═══════════════════════════════════════

echo ""
echo "coding languages: code/AGENTS.md language-agnosticism"

code_content="$(cat "$REPO_DIR/code/AGENTS.md")"

assert_contains "mentions functions" "$code_content" "Functions"
assert_contains "mentions methods" "$code_content" "methods"
assert_contains "mentions modules" "$code_content" "Modules"
assert_not_contains "no JavaScript-specific terms" "$code_content" "npm"
assert_not_contains "no Python-specific terms" "$code_content" "pip install"
assert_not_contains "no Java-specific terms" "$code_content" "Spring"
assert_not_contains "no framework coupling" "$code_content" "React"

# ═══════════════════════════════════════
#  CODING LANGUAGES: Unicode in file paths
# ═══════════════════════════════════════

echo ""
echo "coding languages: Unicode directory names"

target="$(new_target)"
mkdir -p "$target/src"
echo "code" > "$target/src/app.py"

bash "$INSTALL" "$target" code >/dev/null 2>&1
assert_file_exists "Unicode path: AGENTS.md" "$target/AGENTS.md"

# ═══════════════════════════════════════
#  SPOKEN LANGUAGES: Unicode project paths
# ═══════════════════════════════════════

echo ""
echo "spoken languages: CJK directory names"

target="$TMPDIR_BASE/项目"
mkdir -p "$target/src"
echo "code" > "$target/src/main.py"
bash "$INSTALL" "$target" code >/dev/null 2>&1
assert_file_exists "Chinese path: AGENTS.md" "$target/AGENTS.md"
content="$(cat "$target/AGENTS.md")"
assert_contains "Chinese path: has root content" "$content" "Hierarchy & Inheritance"

echo ""
echo "spoken languages: Japanese directory names"

target="$TMPDIR_BASE/プロジェクト"
mkdir -p "$target/docs"
bash "$INSTALL" --scatter "$target" docs:writing >/dev/null 2>&1
assert_file_exists "Japanese path: root AGENTS.md" "$target/AGENTS.md"
assert_file_exists "Japanese path: docs AGENTS.md" "$target/docs/AGENTS.md"

echo ""
echo "spoken languages: Korean directory names"

target="$TMPDIR_BASE/프로젝트"
mkdir -p "$target"
bash "$INSTALL" "$target" research >/dev/null 2>&1
assert_file_exists "Korean path: AGENTS.md" "$target/AGENTS.md"

echo ""
echo "spoken languages: Arabic directory names"

target="$TMPDIR_BASE/مشروع"
mkdir -p "$target"
bash "$INSTALL" "$target" writing >/dev/null 2>&1
assert_file_exists "Arabic path: AGENTS.md" "$target/AGENTS.md"

echo ""
echo "spoken languages: Cyrillic directory names"

target="$TMPDIR_BASE/проект"
mkdir -p "$target/документы"
bash "$INSTALL" --scatter "$target" "документы:writing" >/dev/null 2>&1
assert_file_exists "Cyrillic path: root AGENTS.md" "$target/AGENTS.md"
assert_file_exists "Cyrillic subdir: AGENTS.md" "$target/документы/AGENTS.md"

echo ""
echo "spoken languages: Hindi directory names"

target="$TMPDIR_BASE/परियोजना"
mkdir -p "$target"
bash "$INSTALL" "$target" planning >/dev/null 2>&1
assert_file_exists "Hindi path: AGENTS.md" "$target/AGENTS.md"

echo ""
echo "spoken languages: emoji in directory names"

target="$TMPDIR_BASE/🚀-project"
mkdir -p "$target/📁-docs"
bash "$INSTALL" --scatter "$target" "📁-docs:writing" >/dev/null 2>&1
assert_file_exists "Emoji path: root AGENTS.md" "$target/AGENTS.md"
assert_file_exists "Emoji subdir: AGENTS.md" "$target/📁-docs/AGENTS.md"

echo ""
echo "spoken languages: accented Latin characters"

target="$TMPDIR_BASE/café-résumé"
mkdir -p "$target/código"
bash "$INSTALL" --scatter "$target" "código:code" >/dev/null 2>&1
assert_file_exists "Accented path: root AGENTS.md" "$target/AGENTS.md"
assert_file_exists "Accented subdir: AGENTS.md" "$target/código/AGENTS.md"

# ═══════════════════════════════════════
#  SPOKEN LANGUAGES: content is language-aware
# ═══════════════════════════════════════

echo ""
echo "spoken languages: writing/AGENTS.md acknowledges non-English"

writing_content="$(cat "$REPO_DIR/writing/AGENTS.md")"
assert_contains "writing has voice rules" "$writing_content" "Voice"
assert_contains "writing has audience rules" "$writing_content" "Audience"

echo ""
echo "spoken languages: root AGENTS.md is domain-neutral"

root_content="$(cat "$REPO_DIR/AGENTS.md")"
assert_not_contains "root has no English-only assumption" "$root_content" "English"
assert_contains "root works cross-domain" "$root_content" "all work"

# ═══════════════════════════════════════
#  MULTI-LANGUAGE PROJECTS: mixed stacks
# ═══════════════════════════════════════

echo ""
echo "multi-language: polyglot monorepo"

target="$(new_target)"
mkdir -p "$target/services/api-go/cmd"
mkdir -p "$target/services/web-ts/src"
mkdir -p "$target/services/ml-python/src"
mkdir -p "$target/docs/architecture"
mkdir -p "$target/docs/user-guide"
mkdir -p "$target/data/pipelines"
mkdir -p "$target/research/spikes"

echo "package main" > "$target/services/api-go/cmd/main.go"
echo "export default {}" > "$target/services/web-ts/src/app.ts"
echo "import torch" > "$target/services/ml-python/src/model.py"

bash "$INSTALL" --scatter "$target" \
  services/api-go:code \
  services/web-ts:code \
  services/ml-python:code \
  docs/architecture:architecture \
  docs/user-guide:writing \
  data/pipelines:data \
  research/spikes:research >/dev/null 2>&1

assert_file_exists "polyglot: root AGENTS.md" "$target/AGENTS.md"
assert_file_exists "polyglot: Go AGENTS.md" "$target/services/api-go/AGENTS.md"
assert_file_exists "polyglot: TS AGENTS.md" "$target/services/web-ts/AGENTS.md"
assert_file_exists "polyglot: Python AGENTS.md" "$target/services/ml-python/AGENTS.md"
assert_file_exists "polyglot: arch AGENTS.md" "$target/docs/architecture/AGENTS.md"
assert_file_exists "polyglot: guide AGENTS.md" "$target/docs/user-guide/AGENTS.md"
assert_file_exists "polyglot: data AGENTS.md" "$target/data/pipelines/AGENTS.md"
assert_file_exists "polyglot: research AGENTS.md" "$target/research/spikes/AGENTS.md"

assert_file_exists "polyglot: Go source preserved" "$target/services/api-go/cmd/main.go"
assert_file_exists "polyglot: TS source preserved" "$target/services/web-ts/src/app.ts"
assert_file_exists "polyglot: Python source preserved" "$target/services/ml-python/src/model.py"

go_rules="$(cat "$target/services/api-go/AGENTS.md")"
ts_rules="$(cat "$target/services/web-ts/AGENTS.md")"
py_rules="$(cat "$target/services/ml-python/AGENTS.md")"

assert_eq "same code rules for Go and TS" "$go_rules" "$ts_rules"
assert_eq "same code rules for TS and Python" "$ts_rules" "$py_rules"

echo ""
print_results
