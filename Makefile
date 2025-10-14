# Makefile for Lightnex (LND client) local testing

PROJECT_NAME=lightnex
DOCKER_COMPOSE=UID=$(id -u) GID=$(id -g) docker-compose -f docker/docker-compose.yml

SHELL := /bin/bash
.SILENT:

BITCOIND ?= lightnex-bitcoind
RPC := -regtest -rpcuser=bitcoin -rpcpassword=bitcoin

.PHONY: all build up down logs ps shell prime lint test protos clean

all: build

# ------------------------------------------------------------------------------
# Docker
# ------------------------------------------------------------------------------

build:
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up -d --wait

down:
	$(DOCKER_COMPOSE) down

logs:
	$(DOCKER_COMPOSE) logs -f

ps:
	$(DOCKER_COMPOSE) ps

shell:
	$(DOCKER_COMPOSE) run --rm app sh

prime:
	echo "⛓️  Generating initial regtest blocks for spendable coins..."
	@docker exec $(BITCOIND) bitcoin-cli $(RPC) -rpcwallet=miner getwalletinfo >/dev/null 2>&1 || \
	  docker exec $(BITCOIND) bitcoin-cli $(RPC) loadwallet miner >/dev/null 2>&1 || \
	  docker exec $(BITCOIND) bitcoin-cli $(RPC) createwallet miner false false "" true >/dev/null 2>&1
	@ADDR=$$(docker exec $(BITCOIND) bitcoin-cli $(RPC) -rpcwallet=miner getnewaddress); \
	docker exec $(BITCOIND) bitcoin-cli $(RPC) generatetoaddress 101 $$ADDR >/dev/null
	echo "✓ Chain primed."

# ------------------------------------------------------------------------------
# Elixir
# ------------------------------------------------------------------------------

lint:
	docker compose run --rm app mix format --check-formatted

test:
	docker compose run --rm app mix test

protos:
	docker compose run --rm app mix lightnex.protos.fetch
	docker compose run --rm app mix lightnex.protos.generate

# ------------------------------------------------------------------------------
# Cleanup
# ------------------------------------------------------------------------------

clean:
	$(DOCKER_COMPOSE) down -v --remove-orphans
