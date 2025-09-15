#!/usr/bin/env bash
set -euo pipefail
PROJECT=$(grep -E '^COMPOSE_PROJECT_NAME=' docker/.env | cut -d= -f2)
RPC="-regtest -rpcuser=bitcoin -rpcpassword=bitcoin"

echo "🔑 Ensure Alice and Bob wallets exist & are unlocked (run lncli create/unlock interactively)."

echo "💸 Funding Alice with 1 BTC..."
ALICE_ADDR=$(docker exec ${PROJECT}-lnd-alice lncli --network=regtest newaddress p2wkh | jq -r .address)
ADDR=$(docker exec ${PROJECT}-bitcoind bitcoin-cli $RPC getnewaddress)
docker exec ${PROJECT}-bitcoind bitcoin-cli $RPC sendtoaddress "$ALICE_ADDR" 1 >/dev/null
docker exec ${PROJECT}-bitcoind bitcoin-cli $RPC generatetoaddress 6 "$ADDR" >/dev/null
echo "✓ Funded Alice and mined confirmations."
