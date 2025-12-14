#!/bin/bash
set -e
set -u
set -o pipefail

# Script: update-git-tag.sh
# Description: Update git tag 'latest' to point to current release
# Usage: update-git-tag.sh <source_tag> <is_manual>
# Example: update-git-tag.sh "v1.2.3" "false"

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <source_tag> <is_manual>"
  exit 1
fi

SOURCE_TAG="$1"
IS_MANUAL="$2"

git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

# Delete existing latest tag (locally and remotely)
git tag -d latest 2>/dev/null || true
git push origin :refs/tags/latest 2>/dev/null || true

# Create new latest tag pointing to current commit
if [[ "$IS_MANUAL" == "true" ]]; then
  git tag -a latest -m "Latest release (manual): $SOURCE_TAG"
else
  git tag -a latest -m "Latest stable release: $SOURCE_TAG"
fi
git push origin latest

echo "✅ Updated 'latest' git tag to point to $SOURCE_TAG"