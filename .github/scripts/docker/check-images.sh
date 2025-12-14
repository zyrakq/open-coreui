#!/bin/bash
set -e
set -u
set -o pipefail

# Script: check-images.sh
# Description: Determine which Docker images to build
# Usage: check-images.sh <image_types> <docker_platforms> <repository_owner>
# Example: check-images.sh "all" "all" "owner"

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <image_types> <docker_platforms> <repository_owner>"
  exit 1
fi

IMAGE_TYPES="$1"
DOCKER_PLATFORMS="$2"
REPOSITORY_OWNER="$3"

# Determine which images to build
BUILT_TYPES=""
if [[ "$IMAGE_TYPES" == "all" ]]; then
  echo "build_backend=true" >> $GITHUB_OUTPUT
  echo "build_frontend=true" >> $GITHUB_OUTPUT
  echo "build_complex=true" >> $GITHUB_OUTPUT
  BUILT_TYPES="backend,frontend,complex"
else
  if [[ "$IMAGE_TYPES" == *"backend"* ]]; then
    echo "build_backend=true" >> $GITHUB_OUTPUT
    BUILT_TYPES="${BUILT_TYPES}backend,"
  else
    echo "build_backend=false" >> $GITHUB_OUTPUT
  fi
  
  if [[ "$IMAGE_TYPES" == *"frontend"* ]]; then
    echo "build_frontend=true" >> $GITHUB_OUTPUT
    BUILT_TYPES="${BUILT_TYPES}frontend,"
  else
    echo "build_frontend=false" >> $GITHUB_OUTPUT
  fi
  
  if [[ "$IMAGE_TYPES" == *"complex"* ]]; then
    echo "build_complex=true" >> $GITHUB_OUTPUT
    BUILT_TYPES="${BUILT_TYPES}complex,"
  else
    echo "build_complex=false" >> $GITHUB_OUTPUT
  fi
  
  BUILT_TYPES="${BUILT_TYPES%,}"  # Remove trailing comma
fi

echo "image_types_built=$BUILT_TYPES" >> $GITHUB_OUTPUT

# Determine platforms
if [[ "$DOCKER_PLATFORMS" == "all" ]]; then
  echo "platforms=linux/amd64,linux/arm64" >> $GITHUB_OUTPUT
else
  PLATFORMS=""
  [[ "$DOCKER_PLATFORMS" == *"linux-x64"* ]] && PLATFORMS="${PLATFORMS}linux/amd64,"
  [[ "$DOCKER_PLATFORMS" == *"linux-arm64"* ]] && PLATFORMS="${PLATFORMS}linux/arm64,"
  PLATFORMS="${PLATFORMS%,}"  # Remove trailing comma
  echo "platforms=$PLATFORMS" >> $GITHUB_OUTPUT
fi

# Convert repository owner to lowercase for GHCR
OWNER_LOWER=$(echo "$REPOSITORY_OWNER" | tr '[:upper:]' '[:lower:]')
echo "owner_lower=$OWNER_LOWER" >> $GITHUB_OUTPUT

echo "Building images: backend=$(grep 'build_backend=' $GITHUB_OUTPUT | cut -d= -f2), frontend=$(grep 'build_frontend=' $GITHUB_OUTPUT | cut -d= -f2), complex=$(grep 'build_complex=' $GITHUB_OUTPUT | cut -d= -f2)"
echo "Platforms: $(grep 'platforms=' $GITHUB_OUTPUT | cut -d= -f2)"
echo "Owner: $OWNER_LOWER"