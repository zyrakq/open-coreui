#!/bin/bash
set -e
set -u
set -o pipefail

# Script: generate-frontend-cache-key.sh
# Description: Generate hash for frontend caching
# Usage: generate-frontend-cache-key.sh
# Example: generate-frontend-cache-key.sh

HASH=$(find frontend/src frontend/static frontend/package.json frontend/bun.lock frontend/vite.config.ts frontend/svelte.config.js frontend/tailwind.config.js -type f | sort | xargs sha256sum | sha256sum | cut -d' ' -f1)
echo "hash=$HASH" >> $GITHUB_OUTPUT