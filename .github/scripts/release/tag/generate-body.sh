#!/bin/bash
set -e
set -u
set -o pipefail

# Script: generate-body.sh
# Description: Generate release body for tag releases
# Usage: generate-body.sh <tag> <repo> <version> <artifact_name> <is_release>
# Example: generate-body.sh "v0.9.7" "owner/repo" "0.9.7" "open-coreui" "true"

# Validate arguments
if [[ $# -lt 5 ]]; then
  echo "Usage: $0 <tag> <repo> <version> <artifact_name> <is_release>"
  echo "  tag: Release tag (e.g., v0.9.7)"
  echo "  repo: Repository name (e.g., owner/repo)"
  echo "  version: Version number (e.g., 0.9.7)"
  echo "  artifact_name: Artifact name prefix (e.g., open-coreui)"
  echo "  is_release: 'true' for release, 'false' for dev build"
  exit 1
fi

TAG="$1"
REPO="$2"
VERSION="$3"
ARTIFACT_NAME="$4"
IS_RELEASE="$5"

REPO_LOWER=$(echo "${REPO}" | tr '[:upper:]' '[:lower:]')

if [ "$IS_RELEASE" == "true" ]; then
  WARNING=""
else
  WARNING="**⚠️ Development build - may be unstable**"$'\n\n'
fi

cat > release_body.md << EOF
${WARNING}## Desktop Application

| Platform | Architecture | Download |
|----------|-------------|----------|
| Windows | x64 | [Open.CoreUI.Desktop_${VERSION}_x64-setup.exe](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop_${VERSION}_x64-setup.exe) / [.msi](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop_${VERSION}_x64_en-US.msi) |
| Windows | ARM64 | [Open.CoreUI.Desktop_${VERSION}_arm64-setup.exe](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop_${VERSION}_arm64-setup.exe) / [.msi](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop_${VERSION}_arm64_en-US.msi) |
| macOS | Intel | [Open.CoreUI.Desktop_${VERSION}_x64.dmg](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop_${VERSION}_x64.dmg) |
| macOS | Apple Silicon | [Open.CoreUI.Desktop_${VERSION}_aarch64.dmg](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop_${VERSION}_aarch64.dmg) |
| Linux | x64 | [Open.CoreUI.Desktop_${VERSION}_amd64.deb](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop_${VERSION}_amd64.deb) / [.rpm](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop-${VERSION}-1.x86_64.rpm) |
| Linux | ARM64 | [Open.CoreUI.Desktop_${VERSION}_arm64.deb](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop_${VERSION}_arm64.deb) / [.rpm](https://github.com/${REPO}/releases/download/${TAG}/Open.CoreUI.Desktop-${VERSION}-1.aarch64.rpm) |

> **macOS Users**: If you see "app is damaged" error, run this command in Terminal App:
> 
> \`\`\`bash
> sudo xattr -d com.apple.quarantine "/Applications/Open CoreUI Desktop.app"
> \`\`\`

## Backend Server (Full - With Embedded Frontend)

| Platform | Architecture | Binary |
|----------|-------------|--------|
| Linux | x64 | [${ARTIFACT_NAME}-${VERSION}-x86_64-unknown-linux-gnu](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-${VERSION}-x86_64-unknown-linux-gnu) |
| Linux | ARM64 | [${ARTIFACT_NAME}-${VERSION}-aarch64-unknown-linux-gnu](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-${VERSION}-aarch64-unknown-linux-gnu) |
| macOS | Intel | [${ARTIFACT_NAME}-${VERSION}-x86_64-apple-darwin](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-${VERSION}-x86_64-apple-darwin) |
| macOS | Apple Silicon | [${ARTIFACT_NAME}-${VERSION}-aarch64-apple-darwin](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-${VERSION}-aarch64-apple-darwin) |
| Windows | x64 | [${ARTIFACT_NAME}-${VERSION}-x86_64-pc-windows-msvc.exe](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-${VERSION}-x86_64-pc-windows-msvc.exe) |
| Windows | ARM64 | [${ARTIFACT_NAME}-${VERSION}-aarch64-pc-windows-msvc.exe](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-${VERSION}-aarch64-pc-windows-msvc.exe) |

## Backend Server (Slim - No Frontend)

**Lightweight API-only binaries (~70% smaller). Use when running frontend separately.**

| Platform | Architecture | Binary |
|----------|-------------|--------|
| Linux | x64 | [${ARTIFACT_NAME}-slim-${VERSION}-x86_64-unknown-linux-gnu](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-slim-${VERSION}-x86_64-unknown-linux-gnu) |
| Linux | ARM64 | [${ARTIFACT_NAME}-slim-${VERSION}-aarch64-unknown-linux-gnu](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-slim-${VERSION}-aarch64-unknown-linux-gnu) |
| macOS | Intel | [${ARTIFACT_NAME}-slim-${VERSION}-x86_64-apple-darwin](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-slim-${VERSION}-x86_64-apple-darwin) |
| macOS | Apple Silicon | [${ARTIFACT_NAME}-slim-${VERSION}-aarch64-apple-darwin](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-slim-${VERSION}-aarch64-apple-darwin) |
| Windows | x64 | [${ARTIFACT_NAME}-slim-${VERSION}-x86_64-pc-windows-msvc.exe](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-slim-${VERSION}-x86_64-pc-windows-msvc.exe) |
| Windows | ARM64 | [${ARTIFACT_NAME}-slim-${VERSION}-aarch64-pc-windows-msvc.exe](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-slim-${VERSION}-aarch64-pc-windows-msvc.exe) |

## Frontend (Static Build)

**Standalone frontend build for custom deployments with Nginx, Apache, Ferron, or other web servers.**

| Format | Download |
|--------|----------|
| tar.gz | [${ARTIFACT_NAME}-frontend-${VERSION}.tar.gz](https://github.com/${REPO}/releases/download/${TAG}/${ARTIFACT_NAME}-frontend-${VERSION}.tar.gz) |

📖 [Deployment Instructions](https://github.com/${REPO}/blob/main/docs/FRONTEND_DEPLOYMENT.md)

## Docker Images

**Multi-architecture container images (amd64/arm64) available on GitHub Container Registry:**

| Image | Description | Pull Command |
|-------|-------------|--------------|
| Backend (Slim) | Lightweight API-only server | \`docker pull ghcr.io/${REPO_LOWER}/open-coreui-backend:${VERSION}\` |
| Frontend | Static frontend with Ferron | \`docker pull ghcr.io/${REPO_LOWER}/open-coreui-frontend:${VERSION}\` |
| Complex (Full) | All-in-one with embedded frontend | \`docker pull ghcr.io/${REPO_LOWER}/open-coreui:${VERSION}\` |

🐳 [Docker Deployment Guide](https://github.com/${REPO}/blob/main/docker/build/README.md)

**Quick Start:**
\`\`\`bash
# Run all-in-one container
docker run -d -p 8168:8168 -v ./data:/app/data ghcr.io/${REPO_LOWER}/open-coreui:${VERSION}
\`\`\`
EOF

echo "✅ Release body generated successfully"