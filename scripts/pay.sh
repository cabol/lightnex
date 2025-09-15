#!/usr/bin/env bash
set -euo pipefail
PROJECT=$(grep -E '^COMPOSE_PROJECT_NAME=' docker/.env | cut -d= -f2)

echo "💳 Creating invoice on Bob and paying from Alice..."
INVOICE=$(docker exec ${PROJECT}-lnd-bob lncli --network=regtest addinvoice --amt=1000 | jq -r .payment_request)
docker exec ${PROJECT}-lnd-alice lncli --network=regtest payinvoice -f "$INVOICE"
echo "✓ Payment attempted."
