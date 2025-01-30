.DEFAULT_GOAL: help

help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} \
		/^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

start: ## Start all containers (web, sidekiq, db, redis) in the background
	docker compose up -d --remove-orphans

shell: ## Open a bash shell inside the web container
	docker compose exec web bash

console: ## Open a Rails console
	docker compose exec web bash -c "./bin/rails c"

stop: ## Stop and remove all containers
	docker compose down

clean: ## Remove containers, local images, and orphan containers
	docker compose down --rmi local --remove-orphans

tests: ## Run the test suite in the test container
	docker compose run --rm test

logs: ## Follow the logs for all running containers
	docker compose logs -f