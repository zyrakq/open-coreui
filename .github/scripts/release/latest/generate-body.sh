#!/bin/bash
set -e
set -u
set -o pipefail

# Script: generate-body.sh
# Description: Generate release body for latest release
# Usage: generate-body.sh <source_tag> <repo> <version> <artifact_name> <is_manual>
# Example: generate-body.sh "v0.9.7" "owner/repo" "0.9.7" "open-coreui" "false"

# Validate arguments
if [[ $# -lt 5 ]]; then
  echo "Usage: $0 <source_tag> <repo> <version> <artifact_name> <is_manual>"
  echo "  source_tag: Source release tag (e.g., v0.9.7)"
  echo "  repo: Repository name (e.g., owner/repo)"
  echo "  version: Version number (e.g., 0.9.7)"
  echo "  artifact_name: Artifact name prefix (e.g., open-coreui)"
  echo "  is_manual: 'true' for manual release, 'false' for automatic"
  exit 1
fi

TAG="$1"
REPO="$2"
VERSION="$3"
ARTIFACT_NAME="$4"
IS_MANUAL="$5"

REPO_LOWER=$(echo "${REPO}" | tr '[:upper:]' '[:lower:]')

if [[ "$IS_MANUAL" == "true" ]]; then
  HEADER="# Latest Release (Manual)"
  WARNING="⚠️ **Note:** This is a manually designated \"latest\" release and may not represent the most recent stable version."
else
  HEADER="# Latest Stable Release"
  WARNING="This release is automatically updated to always point to the latest stable version."
fi

cat > release_body_latest.md << EOF
${HEADER}

${WARNING}

**Current Version:** [${TAG}](https://github.com/${REPO}/releases/tag/${TAG})

---

## Desktop Application

| Platform | Architecture | Download |
|----------|-------------|----------|
| Windows | x64 | [Open.CoreUI.Desktop_latest_x64-setup.exe](https://github.com/${REPO}/releases/download/latest/Open.CoreUI.Desktop_latest_x64-setup.exe) / [.msi](https://github.com/${REPO}/releases/download/latest/Open.CoreUI.Desktop_latest_x64_en-US.msi) |
| Windows | ARM64 | [Open.CoreUI.Desktop_latest_arm64-setup.exe](https://github.com/${REPO}/releases/download/latest/Open.CoreUI.Desktop_latest_arm64-setup.exe) / [.msi](https://github.com/${REPO}/releases/download/latest/Open.CoreUI.Desktop_latest_arm64_en-US.msi) |
| macOS | Intel | [Open.CoreUI.Desktop_latest_x64.dmg](https://github.com/${REPO}/releases/download/latest/Open.CoreUI.Desktop_latest_x64.dmg) |
| macOS | Apple Silicon | [Open.CoreUI.Desktop_latest_aarch64.dmg](https://github.com/${REPO}/releases/download/latest/Open.CoreUI.Desktop_latest_aarch64.dmg) |
| Linux | x64 | [Open.CoreUI.Desktop_latest_amd64.deb](https://github.com/${REPO}/releases/download/latest/Open.CoreUI.Desktop_latest_amd64.deb) / [.rpm](https://github.com/${REPO}/releases/download/latest/Open.CoreUI.Desktop-latest-1.x86_64.rpm) |
| Linux | ARM64 | [Open.CoreUI.Desktop_latest_arm64.deb](https://github.com/${REPO}/releases/download/latest/Open.CoreUI.Desktop_latest_arm64.deb) / [.rpm](https://github.com/${REPO}/releases/download/latest/Open.CoreUI.Desktop-latest-1.aarch64.rpm) |

> **macOS Users**: If you see "app is damaged" error, run this command in Terminal App:
> 
> \`\`\`bash
> sudo xattr -d com.apple.quarantine "/Applications/Open CoreUI Desktop.app"
> \`\`\`

## Backend Server (Full - With Embedded Frontend)

| Platform | Architecture | Binary |
|----------|-------------|--------|
| Linux | x64 | [${ARTIFACT_NAME}-latest-x86_64-unknown-linux-gnu](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-latest-x86_64-unknown-linux-gnu) |
| Linux | ARM64 | [${ARTIFACT_NAME}-latest-aarch64-unknown-linux-gnu](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-latest-aarch64-unknown-linux-gnu) |
| macOS | Intel | [${ARTIFACT_NAME}-latest-x86_64-apple-darwin](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-latest-x86_64-apple-darwin) |
| macOS | Apple Silicon | [${ARTIFACT_NAME}-latest-aarch64-apple-darwin](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-latest-aarch64-apple-darwin) |
| Windows | x64 | [${ARTIFACT_NAME}-latest-x86_64-pc-windows-msvc.exe](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-latest-x86_64-pc-windows-msvc.exe) |
| Windows | ARM64 | [${ARTIFACT_NAME}-latest-aarch64-pc-windows-msvc.exe](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-latest-aarch64-pc-windows-msvc.exe) |

## Backend Server (Slim - No Frontend)

**Lightweight API-only binaries (~70% smaller). Use when running frontend separately.**

| Platform | Architecture | Binary |
|----------|-------------|--------|
| Linux | x64 | [${ARTIFACT_NAME}-slim-latest-x86_64-unknown-linux-gnu](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-slim-latest-x86_64-unknown-linux-gnu) |
| Linux | ARM64 | [${ARTIFACT_NAME}-slim-latest-aarch64-unknown-linux-gnu](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-slim-latest-aarch64-unknown-linux-gnu) |
| macOS | Intel | [${ARTIFACT_NAME}-slim-latest-x86_64-apple-darwin](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-slim-latest-x86_64-apple-darwin) |
| macOS | Apple Silicon | [${ARTIFACT_NAME}-slim-latest-aarch64-apple-darwin](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-slim-latest-aarch64-apple-darwin) |
| Windows | x64 | [${ARTIFACT_NAME}-slim-latest-x86_64-pc-windows-msvc.exe](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-slim-latest-x86_64-pc-windows-msvc.exe) |
| Windows | ARM64 | [${ARTIFACT_NAME}-slim-latest-aarch64-pc-windows-msvc.exe](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-slim-latest-aarch64-pc-windows-msvc.exe) |

## Frontend (Static Build)

**Standalone frontend build for custom deployments with Nginx, Apache, Ferron, or other web servers.**

| Format | Download |
|--------|----------|
| tar.gz | [${ARTIFACT_NAME}-frontend-latest.tar.gz](https://github.com/${REPO}/releases/download/latest/${ARTIFACT_NAME}-frontend-latest.tar.gz) |

📖 [Deployment Instructions](https://github.com/${REPO}/blob/main/docs/FRONTEND_DEPLOYMENT.md)

## Docker Images

**Multi-architecture container images (amd64/arm64) available on GitHub Container Registry:**

| Image | Description | Pull Command |
|-------|-------------|--------------|
| Backend (Slim) | Lightweight API-only server | \`docker pull ghcr.io/${REPO_LOWER}/open-coreui-backend:latest\` |
| Frontend | Static frontend with Ferron | \`docker pull ghcr.io/${REPO_LOWER}/open-coreui-frontend:latest\` |
| Complex (Full) | All-in-one with embedded frontend | \`docker pull ghcr.io/${REPO_LOWER}/open-coreui:latest\` |

🐳 [Docker Deployment Guide](https://github.com/${REPO}/blob/main/docker/build/README.md)

**Quick Start:**
\`\`\`bash
# Run all-in-one container
docker run -d -p 8168:8168 -v ./data:/app/data ghcr.io/${REPO_LOWER}/open-coreui:latest
\`\`\`

---

For version-specific releases and detailed changelog, see: [${TAG}](https://github.com/${REPO}/releases/tag/${TAG})
EOF

echo "✅ Latest release body generated successfully"