#!/bin/bash
set -e
set -u
set -o pipefail

# Script: determine-type.sh
# Description: Determine release type (release/prerelease)
# Usage: determine-type.sh <tag_name>
# Example: determine-type.sh "v1.2.3-beta"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <tag_name>"
  exit 1
fi

TAG_NAME="$1"

# Determine if this is a prerelease
if [[ "$TAG_NAME" == *"-"* ]]; then
  echo "is_prerelease=true" >> $GITHUB_OUTPUT
  echo "Release type: prerelease"
else
  echo "is_prerelease=false" >> $GITHUB_OUTPUT
  echo "Release type: stable release"
fi