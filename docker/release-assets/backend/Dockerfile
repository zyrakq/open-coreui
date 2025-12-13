# Stage 1: Download the binary
FROM debian:bookworm-slim AS downloader

# Install wget for downloading
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ARG TARGETARCH
ARG VERSION=latest
ARG GITHUB_REPO=xxnuo/open-coreui

# Determine architecture and download the binary
RUN case ${TARGETARCH} in \
      amd64) ARCH="x86_64" ;; \
      arm64) ARCH="aarch64" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    echo "Downloading for architecture: ${ARCH}" && \
    wget -O /tmp/open-coreui \
    "https://github.com/${GITHUB_REPO}/releases/download/v${VERSION}/open-coreui-slim-${VERSION}-${ARCH}-unknown-linux-gnu" && \
    chmod +x /tmp/open-coreui

# Stage 2: Runtime image
FROM debian:bookworm-slim

# Install minimal runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy the binary and entrypoint script
COPY --from=downloader /tmp/open-coreui /usr/local/bin/open-coreui
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Set executable permissions and create non-root user
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    useradd -m -u 1000 opencoreui

# Create data directory with proper permissions
RUN mkdir -p /app/data && \
    chown -R opencoreui:opencoreui /app

# Switch to non-root user
USER opencoreui

# Set working directory
WORKDIR /app

# Expose the application port
EXPOSE 8168

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]