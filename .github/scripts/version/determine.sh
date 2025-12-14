#!/bin/bash
set -e
set -u
set -o pipefail

# Script: determine.sh
# Description: Determine version from various sources (tag, input, tauri.conf.json)
# Usage: determine.sh <release_tag> <github_ref>
# Example: determine.sh "v1.2.3" "refs/tags/v1.2.3"

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <release_tag> <github_ref>"
  exit 1
fi

RELEASE_TAG="$1"
GITHUB_REF="$2"

# Get Tauri version from config
TAURI_VERSION=$(cat src-tauri/tauri.conf.json | grep '"version"' | head -1 | sed 's/.*"version": "\(.*\)".*/\1/')
echo "tauri_version=${TAURI_VERSION}" >> $GITHUB_OUTPUT
echo "Tauri version: ${TAURI_VERSION}"

# Determine release version
if [[ -n "$RELEASE_TAG" ]] && [[ "$RELEASE_TAG" == v* ]]; then
  VERSION="${RELEASE_TAG}"
  VERSION="${VERSION#v}"
  echo "Using version from input tag: ${VERSION}"
elif [[ "$GITHUB_REF" == refs/tags/v* ]]; then
  VERSION="${GITHUB_REF#refs/tags/v}"
  echo "Using version from git tag: ${VERSION}"
else
  VERSION="${TAURI_VERSION}"
  echo "Using Tauri version: ${VERSION}"
fi

echo "version=${VERSION}" >> $GITHUB_OUTPUT
echo "Final version: ${VERSION}"