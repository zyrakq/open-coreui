#!/bin/bash
set -e

# Script to generate release body for manual releases
# Usage: generate-release-body.sh <tag> <repo> <version> <artifact_name> <has_desktop> <has_backend> <has_backend_slim> <has_frontend> [docker_images]

TAG="$1"
REPO="$2"
VERSION="$3"
ARTIFACT_NAME="$4"
HAS_DESKTOP="$5"
HAS_BACKEND="$6"
HAS_BACKEND_SLIM="$7"
HAS_FRONTEND="$8"
DOCKER_IMAGES="${9:-}"  # Optional: comma-separated list of built Docker images

REPO_LOWER=$(echo "$REPO" | tr '[:upper:]' '[:lower:]')

echo "**⚠️ Manual Release**" > release_body.md
echo "" >> release_body.md
echo "This is a development/test release created manually. It may be unstable." >> release_body.md
echo "" >> release_body.md

# Add Desktop section if available
if [ "$HAS_DESKTOP" == "true" ]; then
  echo "## Desktop Application" >> release_body.md
  echo "" >> release_body.md
  echo "| Platform | Architecture | Download |" >> release_body.md
  echo "|----------|-------------|----------|" >> release_body.md
  
  # Check each platform and add row if file exists
  for file in release-assets/Open.CoreUI.Desktop_*; do
    [ -f "$file" ] || continue
    filename=$(basename "$file")
    case "$filename" in
      *_x64-setup.exe)
        echo "| Windows | x64 | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) / [.msi](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop_${VERSION}_x64_en-US.msi) |" >> release_body.md
        ;;
      *_arm64-setup.exe)
        echo "| Windows | ARM64 | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) / [.msi](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop_${VERSION}_arm64_en-US.msi) |" >> release_body.md
        ;;
      *_x64.dmg)
        echo "| macOS | Intel | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
      *_aarch64.dmg)
        echo "| macOS | Apple Silicon | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
      *_amd64.deb)
        echo "| Linux | x64 | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) / [.rpm](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop-${VERSION}-1.x86_64.rpm) |" >> release_body.md
        ;;
      *_arm64.deb)
        echo "| Linux | ARM64 | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) / [.rpm](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop-${VERSION}-1.aarch64.rpm) |" >> release_body.md
        ;;
    esac
  done
  
  echo "" >> release_body.md
fi

# Add Backend Full section if available
if [ "$HAS_BACKEND" == "true" ]; then
  echo "## Backend Server (Full - With Embedded Frontend)" >> release_body.md
  echo "" >> release_body.md
  echo "| Platform | Architecture | Binary |" >> release_body.md
  echo "|----------|-------------|--------|" >> release_body.md

  for file in release-assets/${ARTIFACT_NAME}-${VERSION}-*; do
    [ -f "$file" ] || continue
    [[ "$file" == *"slim"* ]] && continue
    filename=$(basename "$file")
    case "$filename" in
      *x86_64-unknown-linux-gnu)
        echo "| Linux | x64 | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
      *aarch64-unknown-linux-gnu)
        echo "| Linux | ARM64 | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
      *x86_64-apple-darwin)
        echo "| macOS | Intel | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
      *aarch64-apple-darwin)
        echo "| macOS | Apple Silicon | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
      *x86_64-pc-windows-msvc.exe)
        echo "| Windows | x64 | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
      *aarch64-pc-windows-msvc.exe)
        echo "| Windows | ARM64 | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
    esac
  done
  
  echo "" >> release_body.md
fi

# Add Backend Slim section if available
if [ "$HAS_BACKEND_SLIM" == "true" ]; then
  echo "## Backend Server (Slim - No Frontend)" >> release_body.md
  echo "" >> release_body.md
  echo "**Lightweight API-only binaries (~70% smaller). Use when running frontend separately.**" >> release_body.md
  echo "" >> release_body.md
  echo "| Platform | Architecture | Binary |" >> release_body.md
  echo "|----------|-------------|--------|" >> release_body.md

  for file in release-assets/${ARTIFACT_NAME}-slim-${VERSION}-*; do
    [ -f "$file" ] || continue
    filename=$(basename "$file")
    case "$filename" in
      *x86_64-unknown-linux-gnu)
        echo "| Linux | x64 | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
      *aarch64-unknown-linux-gnu)
        echo "| Linux | ARM64 | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
      *x86_64-apple-darwin)
        echo "| macOS | Intel | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
      *aarch64-apple-darwin)
        echo "| macOS | Apple Silicon | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
      *x86_64-pc-windows-msvc.exe)
        echo "| Windows | x64 | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
      *aarch64-pc-windows-msvc.exe)
        echo "| Windows | ARM64 | [${filename}](https://github.com/${REPO}/releases/download/${TAG}/${filename}) |" >> release_body.md
        ;;
    esac
  done
fi

# Add Frontend section if available
if [ "$HAS_FRONTEND" == "true" ]; then
  echo "## Frontend (Static Build)" >> release_body.md
  echo "" >> release_body.md
  echo "**Standalone frontend build for custom deployments.**" >> release_body.md
  echo "" >> release_body.md
  echo "| Format | Download |" >> release_body.md
  echo "|--------|----------|" >> release_body.md
  echo "| tar.gz | [${ARTIFACT_NAME}-frontend-${VERSION}.tar.gz](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-frontend-${VERSION}.tar.gz) |" >> release_body.md
  echo "" >> release_body.md
  echo "📖 [Deployment Instructions](https://github.com/${REPO}/blob/main/docs/FRONTEND_DEPLOYMENT.md)" >> release_body.md
  echo "" >> release_body.md
fi

# Add Docker Images section if provided
if [ -n "$DOCKER_IMAGES" ]; then
  echo "## Docker Images" >> release_body.md
  echo "" >> release_body.md
  echo "**Multi-architecture container images (amd64/arm64) available on GitHub Container Registry:**" >> release_body.md
  echo "" >> release_body.md
  echo "| Image | Description | Pull Command |" >> release_body.md
  echo "|-------|-------------|--------------|" >> release_body.md
  
  # Add images based on what was built
  if [[ "$DOCKER_IMAGES" == *"backend"* ]]; then
    echo "| Backend (Slim) | Lightweight API-only server | \`docker pull ghcr.io/${REPO_LOWER}/open-coreui-backend:${VERSION}\` |" >> release_body.md
  fi
  
  if [[ "$DOCKER_IMAGES" == *"frontend"* ]]; then
    echo "| Frontend | Static frontend with Ferron | \`docker pull ghcr.io/${REPO_LOWER}/open-coreui-frontend:${VERSION}\` |" >> release_body.md
  fi
  
  if [[ "$DOCKER_IMAGES" == *"complex"* ]]; then
    echo "| Complex (Full) | All-in-one with embedded frontend | \`docker pull ghcr.io/${REPO_LOWER}/open-coreui:${VERSION}\` |" >> release_body.md
  fi
  
  echo "" >> release_body.md
  echo "🐳 [Docker Deployment Guide](https://github.com/${REPO}/blob/main/docker/build/README.md)" >> release_body.md
  echo "" >> release_body.md
  echo "**Quick Start:**" >> release_body.md
  echo "\`\`\`bash" >> release_body.md
  echo "# Run all-in-one container" >> release_body.md
  echo "docker run -d -p 8168:8168 -v ./data:/app/data ghcr.io/${REPO_LOWER}/open-coreui:${VERSION}" >> release_body.md
  echo "\`\`\`" >> release_body.md
fi

echo "Generated release body:"
cat release_body.md