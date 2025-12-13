FROM alpine:latest AS unpacker

WORKDIR /tmp

# Установка wget для загрузки архива
RUN apk add --no-cache wget

ARG VERSION=latest
ARG GITHUB_REPO=xxnuo/open-coreui

# Загрузка архива фронтенда из релиза
RUN if [ "$VERSION" = "latest" ]; then \
      DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/releases/latest/download/open-coreui-frontend.tar.gz"; \
    else \
      DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/releases/download/v${VERSION}/open-coreui-frontend-${VERSION}.tar.gz"; \
    fi && \
    echo "Downloading from: $DOWNLOAD_URL" && \
    wget -O frontend.tar.gz "$DOWNLOAD_URL" && \
    mkdir -p /var/www/html && \
    tar -xzf frontend.tar.gz -C /var/www/html && \
    rm frontend.tar.gz

RUN echo '* {\n\
    default_http_port 8168\n\
    timeout 300000\n\
    root "/var/www/html"\n\
    \n\
    location "/health" {\n\
        response 200 "healthy\\n" type="text/plain"\n\
    }\n\
}' > /tmp/ferron.kdl

FROM ferronserver/ferron:2

COPY --from=unpacker /var/www/html /var/www/html
COPY --from=unpacker /tmp/ferron.kdl /etc/ferron.kdl

EXPOSE 8168

CMD ["/usr/sbin/ferron", "--config-adapter", "docker-auto"]