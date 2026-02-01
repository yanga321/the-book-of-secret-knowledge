# The Book of Secret Knowledge - Documentation Site
# Optimized for Railway deployment

FROM nginx:alpine

# Add labels for better container management
LABEL maintainer="The Book of Secret Knowledge"
LABEL description="A collection of inspiring lists, manuals, cheatsheets, blogs, hacks, one-liners, cli/web tools, and more."
LABEL version="1.0"

# Install envsubst (gettext) for dynamic port configuration
RUN apk add --no-cache gettext

# Copy nginx configuration template
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the documentation files
COPY index.html /usr/share/nginx/html/
COPY README.md /usr/share/nginx/html/
COPY LICENSE.md /usr/share/nginx/html/
COPY static/ /usr/share/nginx/html/static/
COPY .github/ /usr/share/nginx/html/.github/

# Create startup script for dynamic port configuration
RUN echo '#!/bin/sh' > /docker-entrypoint.sh && \
    echo 'set -e' >> /docker-entrypoint.sh && \
    echo 'export PORT=${PORT:-8080}' >> /docker-entrypoint.sh && \
    echo 'envsubst "\$PORT" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf' >> /docker-entrypoint.sh && \
    echo 'exec nginx -g "daemon off;"' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# Set default port (Railway will override this)
ENV PORT=8080

# Expose the port (Railway uses PORT env var)
EXPOSE ${PORT}

# Health check using the PORT variable
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/health || exit 1

# Start nginx with dynamic port configuration
CMD ["/docker-entrypoint.sh"]
