#!/bin/bash
set -e
set -u
set -o pipefail

# Script: scan-artifacts.sh
# Description: Scan available artifacts for manual release
# Usage: scan-artifacts.sh <artifact_name>
# Example: scan-artifacts.sh "open-coreui"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <artifact_name>"
  exit 1
fi

ARTIFACT_NAME="$1"

echo "Scanning available artifacts..."

# Check for desktop artifacts
HAS_DESKTOP=false
if find artifacts -name "*.deb" -o -name "*.rpm" -o -name "*.dmg" -o -name "*.msi" -o -name "*-setup.exe" 2>/dev/null | grep -q .; then
  HAS_DESKTOP=true
fi
echo "has_desktop=$HAS_DESKTOP" >> $GITHUB_OUTPUT

# Check for backend full artifacts
HAS_BACKEND=false
if find artifacts -name "${ARTIFACT_NAME}-*" ! -name "*slim*" 2>/dev/null | grep -q .; then
  HAS_BACKEND=true
fi
echo "has_backend=$HAS_BACKEND" >> $GITHUB_OUTPUT

# Check for backend slim artifacts
HAS_BACKEND_SLIM=false
if find artifacts -name "${ARTIFACT_NAME}-slim-*" 2>/dev/null | grep -q .; then
  HAS_BACKEND_SLIM=true
fi
echo "has_backend_slim=$HAS_BACKEND_SLIM" >> $GITHUB_OUTPUT

# Check for frontend artifacts
HAS_FRONTEND=false
if [ -d "artifacts/frontend-build" ] && [ -n "$(ls -A artifacts/frontend-build 2>/dev/null)" ]; then
  HAS_FRONTEND=true
fi
echo "has_frontend=$HAS_FRONTEND" >> $GITHUB_OUTPUT

# List all available platforms
echo "Available artifacts:"
ls -R artifacts/ || echo "No artifacts found"