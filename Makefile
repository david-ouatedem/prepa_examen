.PHONY: help up down build restart logs console bash db-migrate db-seed db-reset clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

up: ## Start all services (database + Rails app)
	docker compose up

up-d: ## Start all services in detached mode
	docker compose up -d

down: ## Stop all services
	docker compose down

down-v: ## Stop all services and remove volumes (fresh start)
	docker compose down -v

build: ## Build or rebuild services
	docker compose build

rebuild: ## Rebuild services without cache
	docker compose build --no-cache

restart: ## Restart all services
	docker compose restart

logs: ## View logs for all services
	docker compose logs -f

logs-web: ## View logs for web service only
	docker compose logs -f web

logs-db: ## View logs for database service only
	docker compose logs -f db

console: ## Open Rails console
	docker compose exec web bin/rails console

bash: ## Open bash shell in web container
	docker compose exec web bash

db-create: ## Create database
	docker compose exec web bin/rails db:create

db-migrate: ## Run database migrations
	docker compose exec web bin/rails db:migrate

db-rollback: ## Rollback last migration
	docker compose exec web bin/rails db:rollback

db-seed: ## Seed database
	docker compose exec web bin/rails db:seed

db-reset: ## Reset database (drop, create, migrate, seed)
	docker compose exec web bin/rails db:reset

db-setup: ## Setup database (create, load schema, seed)
	docker compose exec web bin/rails db:setup

db-console: ## Open PostgreSQL console
	docker compose exec db psql -U postgres -d prepa_examen_development

test: ## Run tests
	docker compose exec web bin/rails test

routes: ## Show all routes
	docker compose exec web bin/rails routes

clean: ## Remove stopped containers and unused images
	docker compose down
	docker system prune -f

ps: ## Show running containers
	docker compose ps

exec: ## Execute command in web container (usage: make exec CMD="rails routes")
	docker compose exec web $(CMD)
