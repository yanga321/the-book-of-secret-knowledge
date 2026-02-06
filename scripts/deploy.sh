#!/bin/bash
#
# Deployment script for The Book of Secret Knowledge
# Usage: ./scripts/deploy.sh [command]
#
# Commands:
#   build    - Build the Docker image
#   start    - Start the container
#   stop     - Stop the container
#   restart  - Restart the container
#   logs     - View container logs
#   status   - Check container status
#   clean    - Remove containers and images
#   dev      - Start in development mode (with live reload)
#

set -e

# Configuration
IMAGE_NAME="book-of-secret-knowledge"
CONTAINER_NAME="book-of-secret-knowledge"
PORT="${PORT:-3000}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Build the Docker image
build() {
    log_info "Building Docker image: ${IMAGE_NAME}..."
    docker build -t "${IMAGE_NAME}:latest" .
    log_success "Docker image built successfully!"
}

# Start the container
start() {
    log_info "Starting container on port ${PORT}..."

    # Check if container already exists
    if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        log_warning "Container already exists. Stopping and removing..."
        docker stop "${CONTAINER_NAME}" 2>/dev/null || true
        docker rm "${CONTAINER_NAME}" 2>/dev/null || true
    fi

    docker run -d \
        --name "${CONTAINER_NAME}" \
        -p "${PORT}:8080" \
        --restart unless-stopped \
        "${IMAGE_NAME}:latest"

    log_success "Container started successfully!"
    log_info "Application available at: http://localhost:${PORT}"
}

# Stop the container
stop() {
    log_info "Stopping container..."
    docker stop "${CONTAINER_NAME}" 2>/dev/null || log_warning "Container not running"
    log_success "Container stopped!"
}

# Restart the container
restart() {
    log_info "Restarting container..."
    stop
    start
}

# View container logs
logs() {
    log_info "Showing container logs (Ctrl+C to exit)..."
    docker logs -f "${CONTAINER_NAME}"
}

# Check container status
status() {
    log_info "Container status:"
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        echo -e "${GREEN}Running${NC}"
        docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    else
        echo -e "${RED}Not running${NC}"
    fi
}

# Clean up containers and images
clean() {
    log_info "Cleaning up..."
    docker stop "${CONTAINER_NAME}" 2>/dev/null || true
    docker rm "${CONTAINER_NAME}" 2>/dev/null || true
    docker rmi "${IMAGE_NAME}:latest" 2>/dev/null || true
    log_success "Cleanup complete!"
}

# Development mode with live reload
dev() {
    log_info "Starting in development mode..."

    # Check if npx is available
    if command -v npx &> /dev/null; then
        log_info "Using docsify-cli for live reload..."
        npx docsify-cli serve . --port "${PORT}" --open
    else
        log_warning "npx not found. Starting with Docker instead..."
        build
        start
    fi
}

# Docker Compose operations
compose_up() {
    log_info "Starting with Docker Compose..."
    docker-compose up -d --build
    log_success "Application started with Docker Compose!"
    log_info "Application available at: http://localhost:3000"
}

compose_down() {
    log_info "Stopping Docker Compose services..."
    docker-compose down
    log_success "Services stopped!"
}

# Show usage
usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  build       Build the Docker image"
    echo "  start       Start the container"
    echo "  stop        Stop the container"
    echo "  restart     Restart the container"
    echo "  logs        View container logs"
    echo "  status      Check container status"
    echo "  clean       Remove containers and images"
    echo "  dev         Start in development mode"
    echo "  compose-up  Start with Docker Compose"
    echo "  compose-down Stop Docker Compose services"
    echo ""
    echo "Environment variables:"
    echo "  PORT        Port to expose (default: 3000)"
}

# Main
case "${1:-}" in
    build)
        build
        ;;
    start)
        build
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    logs)
        logs
        ;;
    status)
        status
        ;;
    clean)
        clean
        ;;
    dev)
        dev
        ;;
    compose-up)
        compose_up
        ;;
    compose-down)
        compose_down
        ;;
    *)
        usage
        exit 1
        ;;
esac
