#!/bin/bash
echo "--- SGT Health Watcher Active ---"
while true; do
    # Check if Postgres is alive
    if ! docker ps | grep -q sgt-postgres; then
        echo "⚠️ Postgres Down! Restarting..."
        docker start sgt-postgres
    fi
    # Check if Nginx is listening
    if ! lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null ; then
        echo "🚀 Gateway Down! Restarting..."
        sudo nginx -c /Users/tonsy/Documents/sgt-seek/infra/gateway/nginx.conf
    fi
    sleep 60
done
