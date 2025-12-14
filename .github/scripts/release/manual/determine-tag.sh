#!/bin/bash
set -e
set -u
set -o pipefail

# Script: determine-tag.sh
# Description: Determine tag for manual release
# Usage: determine-tag.sh <release_tag>
# Example: determine-tag.sh "v1.2.3-test"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <release_tag>"
  exit 1
fi

RELEASE_TAG="$1"

if [[ -n "$RELEASE_TAG" ]]; then
  echo "tag_name=$RELEASE_TAG" >> $GITHUB_OUTPUT
else
  echo "tag_name=manual-$(git rev-parse --short HEAD)-$(date +%Y%m%d-%H%M%S)" >> $GITHUB_OUTPUT
fi