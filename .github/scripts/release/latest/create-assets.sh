#!/bin/bash
set -euo pipefail

# Script: create-assets.sh
# Description: Creates release assets with 'latest' suffix for the latest release
# Usage: create-assets.sh <version> <artifact_name>

VERSION="${1:?Version is required}"
ARTIFACT_NAME="${2:?Artifact name is required}"

echo "Creating artifacts with 'latest' suffix for latest release..."

# Create output directory
mkdir -p release-assets-latest

# Copy and rename desktop packages with 'latest' in filename
# Windows x64
find release-assets -name "Open.CoreUI.Desktop_${VERSION}_x64-setup.exe" -type f -exec cp {} release-assets-latest/Open.CoreUI.Desktop_latest_x64-setup.exe \; 2>/dev/null || true
find release-assets -name "Open.CoreUI.Desktop_${VERSION}_x64_en-US.msi" -type f -exec cp {} release-assets-latest/Open.CoreUI.Desktop_latest_x64_en-US.msi \; 2>/dev/null || true

# Windows ARM64
find release-assets -name "Open.CoreUI.Desktop_${VERSION}_arm64-setup.exe" -type f -exec cp {} release-assets-latest/Open.CoreUI.Desktop_latest_arm64-setup.exe \; 2>/dev/null || true
find release-assets -name "Open.CoreUI.Desktop_${VERSION}_arm64_en-US.msi" -type f -exec cp {} release-assets-latest/Open.CoreUI.Desktop_latest_arm64_en-US.msi \; 2>/dev/null || true

# macOS
find release-assets -name "Open.CoreUI.Desktop_${VERSION}_x64.dmg" -type f -exec cp {} release-assets-latest/Open.CoreUI.Desktop_latest_x64.dmg \; 2>/dev/null || true
find release-assets -name "Open.CoreUI.Desktop_${VERSION}_aarch64.dmg" -type f -exec cp {} release-assets-latest/Open.CoreUI.Desktop_latest_aarch64.dmg \; 2>/dev/null || true

# Linux
find release-assets -name "Open.CoreUI.Desktop_${VERSION}_amd64.deb" -type f -exec cp {} release-assets-latest/Open.CoreUI.Desktop_latest_amd64.deb \; 2>/dev/null || true
find release-assets -name "Open.CoreUI.Desktop_${VERSION}_arm64.deb" -type f -exec cp {} release-assets-latest/Open.CoreUI.Desktop_latest_arm64.deb \; 2>/dev/null || true
find release-assets -name "Open.CoreUI.Desktop-${VERSION}-1.x86_64.rpm" -type f -exec cp {} release-assets-latest/Open.CoreUI.Desktop-latest-1.x86_64.rpm \; 2>/dev/null || true
find release-assets -name "Open.CoreUI.Desktop-${VERSION}-1.aarch64.rpm" -type f -exec cp {} release-assets-latest/Open.CoreUI.Desktop-latest-1.aarch64.rpm \; 2>/dev/null || true

# AppImage and app.tar.gz
find release-assets -name "*.AppImage" -type f -exec bash -c 'cp "$1" "release-assets-latest/$(basename "$1" | sed "s/_${VERSION}_/_latest_/")"' _ {} \; 2>/dev/null || true
find release-assets -name "*.app.tar.gz" -type f -exec bash -c 'cp "$1" "release-assets-latest/$(basename "$1" | sed "s/_${VERSION}_/_latest_/")"' _ {} \; 2>/dev/null || true

# Backend Full binaries - copy and rename with 'latest' suffix
for file in release-assets/${ARTIFACT_NAME}-${VERSION}-*; do
  [ -f "$file" ] || continue
  [[ "$file" == *"slim"* ]] && continue
  filename=$(basename "$file")
  new_filename=$(echo "$filename" | sed "s/-${VERSION}-/-latest-/")
  cp "$file" "release-assets-latest/$new_filename"
  echo "Created: $new_filename"
done

# Backend Slim binaries - copy and rename with 'latest' suffix
for file in release-assets/${ARTIFACT_NAME}-slim-${VERSION}-*; do
  [ -f "$file" ] || continue
  filename=$(basename "$file")
  new_filename=$(echo "$filename" | sed "s/-${VERSION}-/-latest-/")
  cp "$file" "release-assets-latest/$new_filename"
  echo "Created: $new_filename"
done

# Frontend archive with 'latest' suffix
if [ -f "release-assets/${ARTIFACT_NAME}-frontend-${VERSION}.tar.gz" ]; then
  cp "release-assets/${ARTIFACT_NAME}-frontend-${VERSION}.tar.gz" \
     "release-assets-latest/${ARTIFACT_NAME}-frontend-latest.tar.gz"
  echo "Created: ${ARTIFACT_NAME}-frontend-latest.tar.gz"
fi

echo "✅ Created artifacts with 'latest' suffix"
ls -lh release-assets-latest/