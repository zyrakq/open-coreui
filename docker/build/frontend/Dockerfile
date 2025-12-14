# Frontend - Static build served by Ferron web server
# Built from release artifacts for multi-arch support

FROM alpine:latest AS unpacker

WORKDIR /tmp

# Copy frontend build archive from build context (prepared by workflow)
COPY frontend-build.tar.gz /tmp/

# Extract frontend files
RUN mkdir -p /var/www/html && \
    tar -xzf frontend-build.tar.gz -C /var/www/html && \
    rm frontend-build.tar.gz && \
    ls -la /var/www/html

# Create Ferron configuration for serving static files
RUN echo '* {\n\
    default_http_port 8168\n\
    timeout 300000\n\
    root "/var/www/html"\n\
    \n\
    location "/health" {\n\
        response 200 "healthy\\n" type="text/plain"\n\
    }\n\
}' > /tmp/ferron.kdl

# Copy LICENSE file
COPY LICENSE /tmp/LICENSE

# Final stage - Ferron web server
FROM ferronserver/ferron:2

# Copy frontend files and configuration
COPY --from=unpacker /var/www/html /var/www/html
COPY --from=unpacker /tmp/ferron.kdl /etc/ferron.kdl
COPY --from=unpacker /tmp/LICENSE /usr/share/doc/open-coreui-frontend/LICENSE

# Expose application port
EXPOSE 8168

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8168/health || exit 1

# Start Ferron server
CMD ["/usr/sbin/ferron", "--config-adapter", "docker-auto"]