ARG GIT_REPO=https://github.com/xxnuo/open-coreui
ARG GIT_BRANCH=main

FROM oven/bun:1 AS frontend-builder

RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

ARG GIT_REPO
ARG GIT_BRANCH

WORKDIR /app
RUN git clone --depth 1 --filter=blob:none --sparse ${GIT_REPO} -b ${GIT_BRANCH} repo && \
    cd repo && \
    git sparse-checkout set frontend && \
    cd .. && \
    mv repo/frontend/* . && \
    mv repo/frontend/.* . 2>/dev/null || true && \
    rm -rf repo

RUN bun install --frozen-lockfile

RUN bun run build

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

COPY --from=frontend-builder /app/build /var/www/html

COPY --from=frontend-builder /etc/ferron.kdl /etc/ferron.kdl

EXPOSE 8168

CMD ["/usr/sbin/ferron", "--config-adapter", "docker-auto"]