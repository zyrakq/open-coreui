# Backend (Slim) - Lightweight API-only server
# Built from release artifacts for multi-arch support

FROM debian:bookworm-slim

# Install minimal runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy binary from build context (prepared by workflow)
# TARGETARCH is automatically set by buildx (amd64 or arm64)
ARG TARGETARCH
COPY open-coreui-slim-${TARGETARCH} /usr/local/bin/open-coreui
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY LICENSE /usr/share/doc/open-coreui/LICENSE

# Set executable permissions and create non-root user
RUN chmod +x /usr/local/bin/open-coreui /usr/local/bin/entrypoint.sh && \
    useradd -m -u 1000 opencoreui && \
    mkdir -p /app/data && \
    chown -R opencoreui:opencoreui /app

# Switch to non-root user for security
USER opencoreui

# Set working directory
WORKDIR /app

# Expose application port
EXPOSE 8168

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["/usr/local/bin/open-coreui", "--version"] || exit 1

# Use entrypoint script for initialization
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]