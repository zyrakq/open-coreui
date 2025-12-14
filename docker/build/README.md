# Docker Build from Artifacts

This directory contains Dockerfiles for building multi-architecture Docker images from GitHub Actions artifacts.

## Overview

Three types of Docker images are built automatically during the release process:

1. **Backend (Slim)** - `ghcr.io/${OWNER}/open-coreui-backend`
   - Lightweight API-only server (~70% smaller)
   - No embedded frontend
   - License: Apache-2.0

2. **Frontend** - `ghcr.io/${OWNER}/open-coreui-frontend`
   - Static frontend served by Ferron web server
   - License: BSD-3-Clause

3. **Complex (Full)** - `ghcr.io/${OWNER}/open-coreui`
   - Full backend with embedded frontend
   - Licenses: Apache-2.0 (backend) + BSD-3-Clause (frontend)

## Architecture

All images support multi-architecture builds:

- `linux/amd64` (x86_64)
- `linux/arm64` (aarch64)

## Build Process

Images are built automatically by GitHub Actions workflow (`.github/workflows/component-build-docker.yml`) using artifacts from the build process:

1. **Artifacts are downloaded** from the current workflow run
2. **Build context is prepared** with binaries renamed for Docker TARGETARCH
3. **Multi-arch images are built** using Docker Buildx
4. **Images are pushed** to GitHub Container Registry (GHCR)

## Tagging Strategy

### For version releases (e.g., v1.2.3)

- `1.2.3` - full version
- `1.2` - minor version
- `1` - major version

### For latest stable releases

- `latest` - only updated when a stable release is marked as latest

## Usage

### Pull images from GHCR

```bash
# Backend (slim)
docker pull ghcr.io/${OWNER}/open-coreui-backend:latest

# Frontend
docker pull ghcr.io/${OWNER}/open-coreui-frontend:latest

# Complex (full)
docker pull ghcr.io/${OWNER}/open-coreui:latest
```

### Run containers

```bash
# Backend (slim) - API only
docker run -d -p 8168:8168 \
  -v ./data:/app/data \
  -e DATABASE_URL=sqlite:///app/data/database.sqlite3 \
  ghcr.io/${OWNER}/open-coreui-backend:latest

# Frontend - Static files
docker run -d -p 8168:8168 \
  ghcr.io/${OWNER}/open-coreui-frontend:latest

# Complex (full) - All-in-one
docker run -d -p 8168:8168 \
  -v ./data:/app/data \
  -e DATABASE_URL=sqlite:///app/data/database.sqlite3 \
  ghcr.io/${OWNER}/open-coreui:latest
```

### Using Docker Compose

See [`docker-compose.yml`](../docker-compose.yml) for a complete setup with reverse proxy.

## Directory Structure

```sh
docker/build/
├── README.md                 # This file
├── backend/
│   ├── Dockerfile           # Backend (slim) image
│   └── entrypoint.sh        # Initialization script
├── frontend/
│   └── Dockerfile           # Frontend image
└── complex/
    ├── Dockerfile           # Complex (full) image
    └── entrypoint.sh        # Initialization script
```

## Environment Variables

### Backend and Complex images

- `DATABASE_URL` - Database connection string (default: `sqlite:///app/data/database.sqlite3`)
- `PORT` - Application port (default: `8168`)

### Frontend image

- No configuration needed - served as static files

## Health Checks

All images include health checks:

- **Backend/Complex**: Checks if binary responds to `--version` flag
- **Frontend**: HTTP check on `/health` endpoint

## Building Locally

To build images locally for testing:

```bash
# Download artifacts from a GitHub Actions run
gh run download <run-id>

# Prepare build context for backend
mkdir -p docker/build/backend/context
cp artifacts/open-coreui-slim-x86_64-unknown-linux-gnu docker/build/backend/context/open-coreui-slim-amd64
cp docker/build/backend/entrypoint.sh docker/build/backend/context/
cp backend/LICENSE docker/build/backend/context/

# Build backend image
docker build -t test-backend docker/build/backend/context -f docker/build/backend/Dockerfile
```

## Notes

- Images are built from **release artifacts**, not from source code
- This ensures consistency between binaries in releases and Docker images
- Multi-arch support is provided through Docker Buildx
- All images run as non-root user (`opencoreui`, UID 1000)
- Data persistence requires mounting `/app/data` volume
