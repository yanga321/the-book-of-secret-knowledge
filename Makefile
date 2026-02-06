# The Book of Secret Knowledge - Makefile
# Usage: make [target]

.PHONY: help build start stop restart logs status clean dev compose-up compose-down

# Default target
.DEFAULT_GOAL := help

# Configuration
IMAGE_NAME := book-of-secret-knowledge
CONTAINER_NAME := book-of-secret-knowledge
PORT ?= 3000

# Colors
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m

help: ## Show this help message
	@echo "The Book of Secret Knowledge - Build & Deploy"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "Environment variables:"
	@echo "  PORT         Port to expose (default: 3000)"

build: ## Build the Docker image
	@echo "Building Docker image..."
	docker build -t $(IMAGE_NAME):latest .
	@echo "$(GREEN)Build complete!$(NC)"

start: build ## Build and start the container
	@echo "Starting container on port $(PORT)..."
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true
	docker run -d \
		--name $(CONTAINER_NAME) \
		-p $(PORT):8080 \
		--restart unless-stopped \
		$(IMAGE_NAME):latest
	@echo "$(GREEN)Application running at: http://localhost:$(PORT)$(NC)"

stop: ## Stop the container
	@echo "Stopping container..."
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@echo "$(GREEN)Container stopped$(NC)"

restart: stop start ## Restart the container

logs: ## View container logs
	docker logs -f $(CONTAINER_NAME)

status: ## Check container status
	@docker ps --filter "name=$(CONTAINER_NAME)" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "Container not found"

clean: ## Remove containers and images
	@echo "Cleaning up..."
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true
	@docker rmi $(IMAGE_NAME):latest 2>/dev/null || true
	@echo "$(GREEN)Cleanup complete$(NC)"

dev: ## Start in development mode (requires Node.js/npx)
	@echo "Starting development server..."
	@if command -v npx >/dev/null 2>&1; then \
		npx docsify-cli serve . --port $(PORT) --open; \
	else \
		echo "$(YELLOW)npx not found, using Python HTTP server...$(NC)"; \
		python3 -m http.server $(PORT); \
	fi

compose-up: ## Start with Docker Compose
	docker-compose up -d --build
	@echo "$(GREEN)Application running at: http://localhost:3000$(NC)"

compose-down: ## Stop Docker Compose services
	docker-compose down

# Quick deployment target
deploy: compose-up ## Deploy the application (alias for compose-up)

# Development shortcuts
run: start ## Alias for start
up: compose-up ## Alias for compose-up
down: compose-down ## Alias for compose-down
