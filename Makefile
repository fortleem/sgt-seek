.PHONY: help setup build start stop restart logs clean test migrate lint

help:
	@echo "SGT-SEEK Platform Commands:"
	@echo "  make setup      - Install dependencies and setup environment"
	@echo "  make build      - Build all Docker containers"
	@echo "  make start      - Start all services"
	@echo "  make stop       - Stop all services"
	@echo "  make restart    - Restart all services"
	@echo "  make logs       - View logs from all services"
	@echo "  make clean      - Remove all containers and volumes"
	@echo "  make test       - Run tests"
	@echo "  make migrate    - Run database migrations"
	@echo "  make lint       - Run linting"

setup:
	@echo "Setting up environment..."
	cp .env.example .env
	@echo "Please update .env file with your credentials"
	python3 -m pip install -r requirements.txt
	cd apps/frontend && npm install
	cd apps/admin-portal && npm install

build:
	docker-compose build

start:
	docker-compose up -d

stop:
	docker-compose down

restart: stop start

logs:
	docker-compose logs -f

clean:
	docker-compose down -v
	docker system prune -f

test:
	docker-compose exec backend pytest

migrate:
	docker-compose exec backend alembic upgrade head

lint:
	docker-compose exec backend black --check src tests
	docker-compose exec backend isort --check-only src tests
	cd apps/frontend && npm run lint
	cd apps/admin-portal && npm run lint

deploy-local:
	@echo "Deploying to local Kubernetes..."
	kubectl apply -f infrastructure/kubernetes/

check-health:
	@echo "Checking service health..."
	@curl -f http://localhost:8000/health || echo "Backend is down"
	@curl -f http://localhost:3000 || echo "Frontend is down"
	@curl -f http://localhost:3001 || echo "Admin portal is down"
