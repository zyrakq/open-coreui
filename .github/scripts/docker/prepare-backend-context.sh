#!/bin/bash
set -e
set -u
set -o pipefail

# Script: prepare-backend-context.sh
# Description: Prepare build context for backend Docker image
# Usage: prepare-backend-context.sh <artifact_name>
# Example: prepare-backend-context.sh "open-coreui"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <artifact_name>"
  exit 1
fi

ARTIFACT_NAME="$1"

mkdir -p docker/build/backend/context

# Copy binaries and rename for Docker TARGETARCH
cp artifacts/${ARTIFACT_NAME}-slim-x86_64-unknown-linux-gnu docker/build/backend/context/open-coreui-slim-amd64 || true
cp artifacts/${ARTIFACT_NAME}-slim-aarch64-unknown-linux-gnu docker/build/backend/context/open-coreui-slim-arm64 || true

# Copy entrypoint script
cp docker/build/backend/entrypoint.sh docker/build/backend/context/

# Copy LICENSE
cp backend/LICENSE docker/build/backend/context/LICENSE

ls -la docker/build/backend/context/