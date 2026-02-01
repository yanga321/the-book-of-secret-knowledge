# The Book of Secret Knowledge - Documentation Site
# Multi-stage build for optimized image

FROM nginx:alpine

# Add labels for better container management
LABEL maintainer="The Book of Secret Knowledge"
LABEL description="A collection of inspiring lists, manuals, cheatsheets, blogs, hacks, one-liners, cli/web tools, and more."
LABEL version="1.0"

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the documentation files
COPY index.html /usr/share/nginx/html/
COPY README.md /usr/share/nginx/html/
COPY LICENSE.md /usr/share/nginx/html/
COPY static/ /usr/share/nginx/html/static/
COPY .github/ /usr/share/nginx/html/.github/

# Create a non-root user for security
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup && \
    chown -R appuser:appgroup /usr/share/nginx/html && \
    chown -R appuser:appgroup /var/cache/nginx && \
    chown -R appuser:appgroup /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R appuser:appgroup /var/run/nginx.pid

# Expose port 8080 (non-privileged)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1

# Run as non-root user
USER appuser

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
