# Build stage - Build the SvelteKit frontend with Bun
FROM oven/bun:1 AS frontend-builder
# Install git for cloning
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*
# Git repository arguments
ARG GIT_REPO=https://github.com/xxnuo/open-coreui
ARG GIT_BRANCH=main
WORKDIR /app
# Clone repository with sparse checkout (only frontend directory)
RUN git clone --depth 1 --filter=blob:none --sparse ${GIT_REPO} -b ${GIT_BRANCH} repo && \
    cd repo && \
    git sparse-checkout set frontend && \
    cd .. && \
    mv repo/frontend/* . && \
    mv repo/frontend/.* . 2>/dev/null || true && \
    rm -rf repo
# Install dependencies with Bun
RUN bun install --frozen-lockfile
# Build the frontend (creates static files in /app/build)
RUN bun run build

# Create ferron configuration for SPA with backend proxy
RUN echo '* {\n\
    default_http_port 8168\n\
    timeout 300000\n\
    root "/var/www/html"\n\
    \n\
    location "/health" {\n\
        response 200 "healthy\\n" type="text/plain"\n\
    }\n\
}' > /etc/ferron.kdl

FROM ferronserver/ferron:2

# Copy built static files from builder
COPY --from=frontend-builder /app/build /var/www/html

COPY --from=frontend-builder /etc/ferron.kdl /etc/ferron.kdl

# Expose port 8168
EXPOSE 8168

# Start ferron
CMD ["/usr/sbin/ferron", "--config-adapter", "docker-auto"]