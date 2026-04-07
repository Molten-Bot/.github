#!/usr/bin/env bash
set -euo pipefail

for required_ignore_pattern in .codex .task-logs/ AGENTS.md ".moltenhub-agents-*.md"; do
  if ! grep -Fqx "$required_ignore_pattern" .gitignore; then
    echo "error: .gitignore is missing '$required_ignore_pattern'"
    exit 1
  fi
done

for required_file in README.md profile/README.md; do
  if [[ ! -f "$required_file" ]]; then
    echo "error: missing required file '$required_file'"
    exit 1
  fi
done

if ! grep -Fq "## Task Routing" README.md; then
  echo "error: README.md must include the 'Task Routing' section"
  exit 1
fi

while IFS= read -r markdown_file; do
  if grep -nE "[[:blank:]]$" "$markdown_file" >/dev/null; then
    echo "error: trailing whitespace found in $markdown_file"
    grep -nE "[[:blank:]]$" "$markdown_file"
    exit 1
  fi
done < <(git ls-files "*.md")

echo "repository validation passed"
