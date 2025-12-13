ARG RUST_PROJECT_NAME=open-webui-rust

# Build stage
FROM rust:1.92-slim AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Git repository arguments
ARG GIT_REPO=https://github.com/xxnuo/open-coreui
ARG GIT_BRANCH=main
ARG RUST_PROJECT_NAME
ENV RUST_PROJECT_NAME=${RUST_PROJECT_NAME}

WORKDIR /app

# Clone repository with sparse checkout (only backend directory)
RUN git clone --depth 1 --filter=blob:none --sparse ${GIT_REPO} -b ${GIT_BRANCH} repo && \
    cd repo && \
    git sparse-checkout set backend && \
    cd .. && \
    cp -r repo/backend/. . && \
    rm -rf repo

# Create migrations directory if it doesn't exist
RUN mkdir -p migrations

# Save source code before creating dummy project
RUN cp -r src /tmp/src && \
    cp -r migrations /tmp/migrations && \
    cp -r examples /tmp/examples 2>/dev/null || true

ENV SAFE_PROJECT_NAME="${RUST_PROJECT_NAME//-/_}"
# Create dummy main to cache dependencies
RUN rm -rf src && \
    mkdir -p src && \
    echo "fn main() {}" > src/main.rs && \
    cargo build --release --no-default-features && \
    rm -rf src target/release/.fingerprint/${RUST_PROJECT_NAME}-* target/release/${RUST_PROJECT_NAME}* target/release/deps/${SAFE_PROJECT_NAME}-*

# Restore source code
RUN mv /tmp/src src && \
    mv /tmp/migrations migrations && \
    mv /tmp/examples examples 2>/dev/null || true

# Build application without embed-frontend feature
RUN cargo build --release --no-default-features

# Runtime stage
FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl3 \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ARG RUST_PROJECT_NAME
ENV RUST_PROJECT_NAME=${RUST_PROJECT_NAME}

# Copy binary from builder
COPY --from=builder /app/target/release/${RUST_PROJECT_NAME} /app/${RUST_PROJECT_NAME}

# Copy migrations
COPY --from=builder /app/migrations /app/migrations

# Create data directory
RUN mkdir -p /app/data/uploads

# Create a wrapper script to ensure errors are visible
RUN echo '#!/bin/sh\n\
    set -e\n\
    echo "Starting Open WebUI Rust Backend..."\n\
    echo "DATABASE_URL: $DATABASE_URL"\n\
    echo "ENABLE_REDIS: $ENABLE_REDIS"\n\
    echo "REDIS_URL: $REDIS_URL"\n\
    echo "RUST_LOG: $RUST_LOG"\n\
    # Disable output buffering\n\
    export RUST_BACKTRACE=1\n\
    export RUST_LOG=${RUST_LOG:-info}\n\
    echo "Executing binary..."\n\
    /app/$RUST_PROJECT_NAME 2>&1 || { echo "Binary exited with code $?"; exit $?; }' > /app/start.sh \
    && chmod +x /app/start.sh

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Set executable permissions and create non-root user
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    useradd -m -u 1000 opencoreui

# Create data directory with proper permissions
RUN mkdir -p /app/data && \
    chown -R opencoreui:opencoreui /app

# Switch to non-root user
USER opencoreui

# Expose port
EXPOSE 8168

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Run the wrapper script
CMD ["/app/start.sh"]