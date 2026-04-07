#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

error_count=0

report_error() {
  echo "error: $1" >&2
  error_count=$((error_count + 1))
}

required_files=(
  ".gitignore"
  "README.md"
  "profile/README.md"
  "scripts/validate-repo.sh"
  ".github/workflows/ci.yml"
)

for required_file in "${required_files[@]}"; do
  if [[ ! -f "$required_file" ]]; then
    report_error "missing required file '$required_file'"
  fi
done

required_ignore_patterns=(
  ".codex"
  ".task-logs/"
  ".moltenhub-agents-*.md"
)

if [[ -f ".gitignore" ]]; then
  for required_ignore_pattern in "${required_ignore_patterns[@]}"; do
    if ! grep -Fxq "$required_ignore_pattern" .gitignore; then
      report_error ".gitignore is missing '$required_ignore_pattern'"
    fi
  done
fi

if git ls-files --error-unmatch .codex >/dev/null 2>&1; then
  report_error ".codex is tracked but should be ignored"
fi

if git ls-files | grep -Eq '^\.task-logs/'; then
  report_error "files under .task-logs/ are tracked but should be ignored"
fi

if git ls-files | grep -Eq '^\.moltenhub-agents-[0-9]+\.md$'; then
  report_error ".moltenhub-agents-*.md files are tracked but should be ignored"
fi

if [[ -f "README.md" ]] && ! grep -Eq '^[[:space:]]*##[[:space:]]+Task Routing[[:space:]]*$' README.md; then
  report_error "README.md must include the 'Task Routing' section"
fi

while IFS= read -r markdown_file; do
  if grep -Eq '[[:blank:]]+$' "$markdown_file"; then
    report_error "trailing whitespace found in $markdown_file"
  fi
done < <(git ls-files '*.md')

if (( error_count > 0 )); then
  echo "validation failed with $error_count error(s)" >&2
  exit 1
fi

echo "validation passed"
