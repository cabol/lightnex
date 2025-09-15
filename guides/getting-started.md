# Lightnex Local Stack (regtest)

A reproducible regtest environment for developing and testing the Lightnex Elixir client.

## Layout
- `docker/docker-compose.yml` – bitcoind + two LND nodes (alice/bob)
- `docker/.env` – tweak versions/ports/network
- `docker/lnd/*.conf` – example node configs
- `scripts/*.sh` – helper scripts (prime chain, fund, connect, pay, reset)
- `Makefile` – handy targets to orchestrate the stack

## Usage
```bash
# Start services
make up

# Prime chain for spendable coins
make prime

# (one-time per node) Create + unlock wallets interactively:
docker exec -it lightnex-lnd-alice lncli --network=regtest create
docker exec -it lightnex-lnd-alice lncli --network=regtest unlock
docker exec -it lightnex-lnd-bob   lncli --network=regtest create
docker exec -it lightnex-lnd-bob   lncli --network=regtest unlock

# Fund Alice, open a channel to Bob, and pay an invoice
make fund
make connect
make pay
```

### gRPC endpoints
- Alice: `localhost:${ALICE_GRPC}` (macaroons/TLS under `docker/data/lnd-alice`)
- Bob:   `localhost:${BOB_GRPC}` (macaroons/TLS under `docker/data/lnd-bob`)

> Change versions or ports in `docker/.env`. To use a single-node setup, comment out the `lnd-bob` service.
