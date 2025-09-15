#!/usr/bin/env bash
set -euo pipefail

PROJECT=$(grep -E '^COMPOSE_PROJECT_NAME=' docker/.env | cut -d= -f2)
RPC="-regtest -rpcuser=bitcoin -rpcpassword=bitcoin"
echo "⛓️  Generating initial regtest blocks for spendable coins..."
ADDR=$(docker exec ${PROJECT}-bitcoind bitcoin-cli $RPC getnewaddress)
docker exec ${PROJECT}-bitcoind bitcoin-cli $RPC generatetoaddress 101 "$ADDR" >/dev/null
echo "✓ Chain primed."
