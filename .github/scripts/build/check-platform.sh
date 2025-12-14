#!/bin/bash
set -e
set -u
set -o pipefail

# Script: check-platform.sh
# Description: Check if a specific platform should be built based on target_platforms input
# Usage: check-platform.sh <target_platforms> <platform_id>
# Example: check-platform.sh "linux-x64,macos-arm64" "linux-x64"

# Validate arguments
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <target_platforms> <platform_id>"
  echo "  target_platforms: Comma-separated list of platforms or 'all'"
  echo "  platform_id: Platform identifier (e.g., linux-x64, macos-arm64)"
  exit 1
fi

TARGET_PLATFORMS="$1"
PLATFORM_ID="$2"

# Check if platform should be built
if [[ "${TARGET_PLATFORMS}" != "all" ]]; then
  if [[ "${TARGET_PLATFORMS}" == *"${PLATFORM_ID}"* ]]; then
    echo "build=true"
  else
    echo "build=false"
  fi
else
  echo "build=true"
fi