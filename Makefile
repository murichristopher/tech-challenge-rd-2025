.DEFAULT_GOAL: help

help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

start: ## Start app and workers in background
	docker compose up -d --remove-orphans

restart: ## Restart the app
	docker compose down && docker compose up --remove-orphans

console: ## Open Rails console
	docker compose exec web bash -c "./bin/rails c"

stop: ## Stop app
	docker compose down

clean: ## Clean containers
	docker compose down --rmi local --remove-orphans

tests: ## Run tests
	docker compose run --rm test

logs: ## Show logs
	docker compose logs -f