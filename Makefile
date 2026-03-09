.PHONY: help up down prune recreate-volumes

help:
	@echo Usage:
	@echo   make up               - Pull if new image exists and start all services
	@echo   make down             - Stop and remove all services and volumes
	@echo   make prune            - Stop and remove all services, volumes, and images
	@echo   make recreate-volumes - Remove and recreate all named volumes \(WARNING: destroys all data\)
	@echo   make help             - Show this help message

pull-backend:
	podman pull ghcr.io/uit-buddy/backend:latest

up: pull-backend
	@echo ">> Pulling auxiliary images Postgres, Redis..."
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env pull postgres redis
	@echo ">> Starting all infrastructure..."
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env up -d

down:
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env down -v

prune:
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env down -v --rmi all
	podman system prune -f

recreate-volumes:
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env down
	podman volume rm -f uit-buddy-backend_postgres_data uit-buddy-backend_redis_data || true
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env up -d
	@echo ">> Done. Volumes recreated fresh."