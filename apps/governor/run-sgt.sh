#!/bin/bash
cd /Users/tonsy/Documents/sgt-seek/apps/governor

echo "=========================================="
echo "🚀 SMART GLOBAL TRADE - GOVERNOR SERVICE"
echo "=========================================="

echo "⚙️  Configuration:"
echo "   Version:     v0.2.0 (Blueprint Compliant)"
echo "   Stack:       Rust + Axum + GraphQL"
echo "   Database:    PostgreSQL (optional)"
echo "   Port:        8080"

echo ""
echo "🛑 Stopping any existing services..."
pkill sgt-governor 2>/dev/null
sleep 2

echo ""
echo "🔧 Starting SGT Governor..."
echo ""
echo "🌐 ACCESS POINTS:"
echo "   GraphQL Playground:  http://localhost:8080/graphql"
echo "   Health Check:        http://localhost:8080/health"
echo "   API (Blueprint):     http://localhost:8080/v1/decide"
echo "   Gate Check:          http://localhost:8080/v1/gates/check"
echo ""
echo "📋 SAMPLE QUERIES:"
echo '   # Health check'
echo '   curl http://localhost:8080/health'
echo ''
echo '   # GraphQL - Get trade requests'
echo '   curl -X POST http://localhost:8080/graphql \'
echo '     -H "Content-Type: application/json" \'
echo '     -d '\''{"query": "{ tradeRequests { id productCategory status } }"}'\'
echo ''
echo '   # GraphQL - Create trade request'
echo '   curl -X POST http://localhost:8080/graphql \'
echo '     -H "Content-Type: application/json" \'
echo '     -d '\''{"query": "mutation { createTradeRequest(productCategory: \"ELECTRONICS\", specifications: {}, quantity: \"100\", unit: \"units\") { id status } }"}'\'
echo ''
echo '   # Blueprint API - Settlement eligibility'
echo '   curl -X POST http://localhost:8080/v1/decide \'
echo '     -H "Content-Type: application/json" \'
echo '     -d '\''{"decision_type": "SETTLEMENT_ELIGIBILITY", "context": {"origin_country": "EG", "destination_country": "DE"}}'\'
echo "=========================================="

# Start the service
./target/release/sgt-governor
