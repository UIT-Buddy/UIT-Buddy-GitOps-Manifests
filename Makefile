.PHONY: help up down prune

help:
	@echo Usage:
	@echo   make up    - Pull (if new image exists) and start all services
	@echo   make down  - Stop and remove all services and volumes
	@echo   make prune - Stop and remove all services, volumes, and images
	@echo   make help  - Show this help message

pull-backend:
	powershell -Command "Set-Content -Path 'dummy-auth.json' -Value '{}'; podman pull --authfile dummy-auth.json ghcr.io/uit-buddy/backend:latest; Remove-Item -Path 'dummy-auth.json' -ErrorAction SilentlyContinue"

up: pull-backend
	@echo ">> Pulling auxiliary images (Postgres, Redis)..."
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env pull postgres redis
	@echo ">> Starting all infrastructure..."
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env up -d

down:
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env down -v

prune:
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env down -v --rmi all
	podman system prune -f