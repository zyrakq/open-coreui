#!/bin/bash
set -e
set -u
set -o pipefail

# Script: generate-checksums.sh
# Description: Generate SHA256 checksums for release assets
# Usage: generate-checksums.sh
# Example: generate-checksums.sh

cd release-assets
if [ -n "$(ls -A 2>/dev/null)" ]; then
  sha256sum * > SHA256SUMS 2>/dev/null || true
  cat SHA256SUMS
else
  echo "No files to generate checksums for"
fi