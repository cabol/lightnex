#!/usr/bin/env bash
set -euo pipefail
PROJECT=$(grep -E '^COMPOSE_PROJECT_NAME=' docker/.env | cut -d= -f2)
RPC="-regtest -rpcuser=bitcoin -rpcpassword=bitcoin"

echo "🔗 Connecting Alice -> Bob and opening a channel..."
BOB_PUB=$(docker exec ${PROJECT}-lnd-bob lncli --network=regtest getinfo | jq -r .identity_pubkey)
docker exec ${PROJECT}-lnd-alice lncli --network=regtest connect "$BOB_PUB@${PROJECT}-lnd-bob:9735" || true
docker exec ${PROJECT}-lnd-alice lncli --network=regtest openchannel --node_key="$BOB_PUB" --local_amt=100000
ADDR=$(docker exec ${PROJECT}-bitcoind bitcoin-cli $RPC getnewaddress)
docker exec ${PROJECT}-bitcoind bitcoin-cli $RPC generatetoaddress 6 "$ADDR" >/dev/null
echo "✓ Channel opened and confirmed."
