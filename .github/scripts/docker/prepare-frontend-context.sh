#!/bin/bash
set -e
set -u
set -o pipefail

# Script: prepare-frontend-context.sh
# Description: Prepare build context for frontend Docker image
# Usage: prepare-frontend-context.sh
# Example: prepare-frontend-context.sh

mkdir -p docker/build/frontend/context

# Create frontend archive
cd artifacts/frontend-build
tar -czf ../../docker/build/frontend/context/frontend-build.tar.gz .
cd ../..

# Copy LICENSE
cp frontend/src/LICENSE docker/build/frontend/context/LICENSE

ls -la docker/build/frontend/context/