#!/bin/bash
set -e
set -u
set -o pipefail

# Script: compute-flags.sh
# Description: Compute effective build flags based on dependencies
# Usage: compute-flags.sh <event_name> <build_frontend> <build_backend> <build_backend_slim> <build_desktop>
# Example: compute-flags.sh "workflow_dispatch" "true" "true" "true" "false"

if [[ $# -lt 5 ]]; then
  echo "Usage: $0 <event_name> <build_frontend> <build_backend> <build_backend_slim> <build_desktop>"
  exit 1
fi

EVENT_NAME="$1"
BUILD_FRONTEND="$2"
BUILD_BACKEND="$3"
BUILD_BACKEND_SLIM="$4"
BUILD_DESKTOP="$5"

# For push events, build everything
if [[ "$EVENT_NAME" == "push" ]]; then
  echo "build_frontend=true" >> $GITHUB_OUTPUT
  echo "build_backend=true" >> $GITHUB_OUTPUT
  echo "build_backend_slim=true" >> $GITHUB_OUTPUT
  echo "build_desktop=true" >> $GITHUB_OUTPUT
else
  # For manual dispatch, compute dependencies
  
  # If backend is selected, frontend must be built
  if [[ "$BUILD_BACKEND" == "true" ]]; then
    echo "::notice::Backend selected - automatically enabling Frontend"
    BUILD_FRONTEND="true"
  fi
  
  # If desktop is selected, backend must be built (backend includes frontend)
  if [[ "$BUILD_DESKTOP" == "true" ]]; then
    echo "::notice::Desktop selected - automatically enabling Frontend and Backend"
    BUILD_FRONTEND="true"
    BUILD_BACKEND="true"
  fi
  
  echo "build_frontend=$BUILD_FRONTEND" >> $GITHUB_OUTPUT
  echo "build_backend=$BUILD_BACKEND" >> $GITHUB_OUTPUT
  echo "build_backend_slim=$BUILD_BACKEND_SLIM" >> $GITHUB_OUTPUT
  echo "build_desktop=$BUILD_DESKTOP" >> $GITHUB_OUTPUT
  
  # Log final build configuration
  echo "::notice::Build configuration: Frontend=$BUILD_FRONTEND, Backend=$BUILD_BACKEND, Backend-Slim=$BUILD_BACKEND_SLIM, Desktop=$BUILD_DESKTOP"
fi