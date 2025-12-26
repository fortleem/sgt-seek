#!/bin/bash
cd "$(dirname "$0")"
echo "🚀 Starting SGT Governor Service (Rust)"
echo "Port: 8080"
echo "API: http://localhost:8080"
echo "Health: http://localhost:8080/health"
echo ""
exec ./target/release/sgt-governor
