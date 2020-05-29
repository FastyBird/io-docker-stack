DOCKER_COMPOSE_DIR=./

DEFAULT_GOAL := help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-27s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ [Docker] Build / Infrastructure
.docker/.env:
	cp $(DOCKER_COMPOSE_DIR)/.env.example $(DOCKER_COMPOSE_DIR)/.env

.PHONY: docker-clean
docker-clean: ## Remove the .env file for docker
	rm -f $(DOCKER_COMPOSE_DIR)/.env

.PHONY: docker-init
docker-init: .docker/.env ## Make sure the .env file exists for docker

## Build all docker images from scratch, without cache etc.
## Build a specific image by providing the service name via: make docker-build-from-scratch CONTAINER=<service>
.PHONY: docker-build-from-scratch
docker-build-from-scratch: docker-init
	docker-compose rm -fs $(CONTAINER) && \
	docker-compose build --pull --no-cache --parallel $(CONTAINER) && \
	docker-compose up -d --force-recreate $(CONTAINER)

## Run the infrastructure tests for the docker setup
.PHONY: docker-test
docker-test: docker-init docker-up
	sh $(DOCKER_COMPOSE_DIR)/docker-test.sh

## Build all docker images.
## Build a specific image by providing the service name via: make docker-build CONTAINER=<service>
.PHONY: docker-build
docker-build: docker-init
	docker-compose build --parallel $(CONTAINER) && \
	docker-compose up -d --force-recreate $(CONTAINER)

## Remove unused docker resources via 'docker system prune -a -f --volumes'
.PHONY: docker-prune
docker-prune:
	docker system prune -a -f --volumes

## Start all docker containers.
## To only start one container, use CONTAINER=<service>
.PHONY: docker-up
docker-up: docker-init
	docker-compose up -d $(CONTAINER)

## Stop all docker containers.
## To only stop one container, use CONTAINER=<service>
.PHONY: docker-down
docker-down: docker-init
	docker-compose down $(CONTAINER)
