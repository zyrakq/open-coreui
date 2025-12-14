#!/bin/bash
set -e
set -u
set -o pipefail

# Script: prepare-complex-context.sh
# Description: Prepare build context for complex Docker image
# Usage: prepare-complex-context.sh <artifact_name>
# Example: prepare-complex-context.sh "open-coreui"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <artifact_name>"
  exit 1
fi

ARTIFACT_NAME="$1"

mkdir -p docker/build/complex/context

# Copy binaries and rename for Docker TARGETARCH
cp artifacts/${ARTIFACT_NAME}-x86_64-unknown-linux-gnu docker/build/complex/context/open-coreui-amd64 || true
cp artifacts/${ARTIFACT_NAME}-aarch64-unknown-linux-gnu docker/build/complex/context/open-coreui-arm64 || true

# Copy entrypoint script
cp docker/build/complex/entrypoint.sh docker/build/complex/context/

# Copy LICENSE files
cp backend/LICENSE docker/build/complex/context/LICENSE-BACKEND
cp frontend/src/LICENSE docker/build/complex/context/LICENSE-FRONTEND

ls -la docker/build/complex/context/