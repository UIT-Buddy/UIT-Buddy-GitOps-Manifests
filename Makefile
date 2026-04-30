.PHONY: help backend-up n8n-up buddyai-up 

# Default to latest if running manually, but accept pipeline variables
IMAGE_TAG ?= latest
IMAGE_NAME = ghcr.io/uit-buddy/backend:$(IMAGE_TAG)

help:
	@echo Usage:
	@echo   make up               - Pull if new image exists and start all services
	@echo   make down             - Stop and remove all services and volumes
	@echo   make prune            - Stop and remove all services, volumes, and images
	@echo   make recreate-volumes - Remove and recreate all named volumes \(WARNING: destroys all data\)
	@echo   make help             - Show this help message

pull-backend:
	@echo ">> Pulling backend image: $(IMAGE_NAME)"
	podman pull $(IMAGE_NAME)

backend-up: pull-backend
	@echo ">> Pulling auxiliary images Postgres, Redis..."
	podman-compose -f docker-compose.backend.prod.yaml --env-file backend.env pull postgres redis
	@echo ">> Starting infrastructure with backend image tag: $(IMAGE_TAG)..."
	IMAGE_TAG=$(IMAGE_TAG) podman-compose -f docker-compose.backend.prod.yaml --env-file backend.env up -d --force-recreate

n8n-up:
	@echo ">> Starting n8n..."
	podman-compose -f docker-compose.n8n.prod.yaml --env-file n8n.env up -d


