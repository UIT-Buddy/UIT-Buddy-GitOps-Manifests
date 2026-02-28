.PHONY: help up down prune

help:
	@echo Usage:
	@echo   make up    - Pull (if new image exists) and start all services
	@echo   make down  - Stop and remove all services and volumes
	@echo   make prune - Stop and remove all services, volumes, and images
	@echo   make help  - Show this help message

up:
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env up -d --pull always

down:
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env down -v

prune:
	podman compose -f docker-compose.backend.prod.yaml --env-file backend.env down -v --rmi all
	podman system prune -f