#!/bin/bash
set -e

# Script to rename desktop artifacts to match release version
# Usage: rename-desktop-artifacts.sh <tauri_version> <target_version> <bundle_dir> <target>

TAURI_VERSION="$1"
TARGET_VERSION="$2"
BUNDLE_DIR="$3"
TARGET="$4"

if [[ -z "$TAURI_VERSION" ]] || [[ -z "$TARGET_VERSION" ]] || [[ -z "$BUNDLE_DIR" ]] || [[ -z "$TARGET" ]]; then
  echo "Usage: $0 <tauri_version> <target_version> <bundle_dir> <target>"
  exit 1
fi

if [[ "$TAURI_VERSION" == "$TARGET_VERSION" ]]; then
  echo "::notice::Versions match ($TAURI_VERSION), no renaming needed"
  exit 0
fi

echo "::notice::Renaming desktop artifacts from $TAURI_VERSION to $TARGET_VERSION"

if [[ ! -d "$BUNDLE_DIR" ]]; then
  echo "::warning::Bundle directory not found: $BUNDLE_DIR"
  exit 0
fi

# Rename files
find "$BUNDLE_DIR" -type f -name "*${TAURI_VERSION}*" | while read -r file; do
  new_file=$(echo "$file" | sed "s/${TAURI_VERSION}/${TARGET_VERSION}/g")
  if [[ "$file" != "$new_file" ]] && [[ -f "$file" ]]; then
    echo "Renaming: $(basename "$file") -> $(basename "$new_file")"
    mv "$file" "$new_file"
  fi
done

# Rename directories
find "$BUNDLE_DIR" -depth -type d -name "*${TAURI_VERSION}*" | while read -r dir; do
  new_dir=$(echo "$dir" | sed "s/${TAURI_VERSION}/${TARGET_VERSION}/g")
  if [[ "$dir" != "$new_dir" ]] && [[ -d "$dir" ]]; then
    echo "Renaming directory: $(basename "$dir") -> $(basename "$new_dir")"
    mv "$dir" "$new_dir"
  fi
done

echo "::notice::✅ Renamed successfully"