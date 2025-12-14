#!/bin/bash
set -e
set -u
set -o pipefail

# Script: organize-assets.sh
# Description: Organize and rename release assets from artifacts directory
# Usage: organize-assets.sh <version> <artifact_name> [allow_missing]
# Example: organize-assets.sh "0.9.7" "open-coreui" "false"

# Validate arguments
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <version> <artifact_name> [allow_missing]"
  echo "  version: Version string (e.g., 0.9.7)"
  echo "  artifact_name: Artifact name prefix (e.g., open-coreui)"
  echo "  allow_missing: Optional, 'true' to allow missing files (default: false)"
  exit 1
fi

VERSION="$1"
ARTIFACT_NAME="$2"
ALLOW_MISSING="${3:-false}"

echo "Organizing release assets..."
echo "Version: ${VERSION}"
echo "Artifact name: ${ARTIFACT_NAME}"
echo "Allow missing files: ${ALLOW_MISSING}"

mkdir -p release-assets

# Set error handling based on allow_missing flag
if [[ "${ALLOW_MISSING}" == "true" ]]; then
  FIND_SUFFIX="2>/dev/null || true"
else
  FIND_SUFFIX=""
fi

# Copy desktop app packages and rename (replace spaces with dots)
echo "Copying desktop packages..."
find artifacts -name "*.deb" -type f | while read -r file; do
  filename=$(basename "$file")
  newname="${filename// /.}"
  cp "$file" "release-assets/$newname" 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
done

find artifacts -name "*.rpm" -type f | while read -r file; do
  filename=$(basename "$file")
  newname="${filename// /.}"
  cp "$file" "release-assets/$newname" 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
done

find artifacts -name "*.dmg" -type f | while read -r file; do
  filename=$(basename "$file")
  newname="${filename// /.}"
  cp "$file" "release-assets/$newname" 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
done

find artifacts -name "*.msi" -type f | while read -r file; do
  filename=$(basename "$file")
  newname="${filename// /.}"
  cp "$file" "release-assets/$newname" 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
done

find artifacts -name "*-setup.exe" -type f | while read -r file; do
  filename=$(basename "$file")
  newname="${filename// /.}"
  cp "$file" "release-assets/$newname" 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
done

find artifacts -name "*.app.tar.gz" -type f | while read -r file; do
  filename=$(basename "$file")
  newname="${filename// /.}"
  cp "$file" "release-assets/$newname" 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
done

find artifacts -name "*.AppImage" -type f | while read -r file; do
  filename=$(basename "$file")
  newname="${filename// /.}"
  cp "$file" "release-assets/$newname" 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
done

# Copy and rename backend binaries with version
echo "Copying and renaming backend full binaries..."
find artifacts -name "${ARTIFACT_NAME}-x86_64-unknown-linux-gnu" -type f -exec cp {} release-assets/${ARTIFACT_NAME}-${VERSION}-x86_64-unknown-linux-gnu \; 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
find artifacts -name "${ARTIFACT_NAME}-aarch64-unknown-linux-gnu" -type f -exec cp {} release-assets/${ARTIFACT_NAME}-${VERSION}-aarch64-unknown-linux-gnu \; 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
find artifacts -name "${ARTIFACT_NAME}-x86_64-apple-darwin" -type f -exec cp {} release-assets/${ARTIFACT_NAME}-${VERSION}-x86_64-apple-darwin \; 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
find artifacts -name "${ARTIFACT_NAME}-aarch64-apple-darwin" -type f -exec cp {} release-assets/${ARTIFACT_NAME}-${VERSION}-aarch64-apple-darwin \; 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
find artifacts -name "${ARTIFACT_NAME}-x86_64-pc-windows-msvc.exe" -type f -exec cp {} release-assets/${ARTIFACT_NAME}-${VERSION}-x86_64-pc-windows-msvc.exe \; 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
find artifacts -name "${ARTIFACT_NAME}-aarch64-pc-windows-msvc.exe" -type f -exec cp {} release-assets/${ARTIFACT_NAME}-${VERSION}-aarch64-pc-windows-msvc.exe \; 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]

# Copy and rename slim backend binaries with version
echo "Copying and renaming backend slim binaries..."
find artifacts -name "${ARTIFACT_NAME}-slim-x86_64-unknown-linux-gnu" -type f -exec cp {} release-assets/${ARTIFACT_NAME}-slim-${VERSION}-x86_64-unknown-linux-gnu \; 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
find artifacts -name "${ARTIFACT_NAME}-slim-aarch64-unknown-linux-gnu" -type f -exec cp {} release-assets/${ARTIFACT_NAME}-slim-${VERSION}-aarch64-unknown-linux-gnu \; 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
find artifacts -name "${ARTIFACT_NAME}-slim-x86_64-apple-darwin" -type f -exec cp {} release-assets/${ARTIFACT_NAME}-slim-${VERSION}-x86_64-apple-darwin \; 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
find artifacts -name "${ARTIFACT_NAME}-slim-aarch64-apple-darwin" -type f -exec cp {} release-assets/${ARTIFACT_NAME}-slim-${VERSION}-aarch64-apple-darwin \; 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
find artifacts -name "${ARTIFACT_NAME}-slim-x86_64-pc-windows-msvc.exe" -type f -exec cp {} release-assets/${ARTIFACT_NAME}-slim-${VERSION}-x86_64-pc-windows-msvc.exe \; 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
find artifacts -name "${ARTIFACT_NAME}-slim-aarch64-pc-windows-msvc.exe" -type f -exec cp {} release-assets/${ARTIFACT_NAME}-slim-${VERSION}-aarch64-pc-windows-msvc.exe \; 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]

# Create frontend archive if available
if [ -d "artifacts/frontend-build" ] && [ -n "$(ls -A artifacts/frontend-build 2>/dev/null)" ]; then
  echo "Creating frontend archive..."
  cd artifacts/frontend-build
  tar -czf ../../release-assets/${ARTIFACT_NAME}-frontend-${VERSION}.tar.gz . 2>/dev/null || [[ "${ALLOW_MISSING}" == "true" ]]
  cd ../..
  echo "Frontend archive created: ${ARTIFACT_NAME}-frontend-${VERSION}.tar.gz"
else
  echo "No frontend artifacts found, skipping frontend archive creation"
fi

echo "Release assets prepared:"
ls -lh release-assets/ || echo "No release assets found"