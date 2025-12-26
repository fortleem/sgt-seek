#!/bin/bash
# Root: /Users/tonsy/Documents/sgt-seek
TIMESTAMP=$(date +"%Y-%m-%d")
# Report Generation
docker exec -i sgt-postgres psql -U tonsy -d sgt_root -c "COPY (SELECT * FROM risk_audit) TO STDOUT WITH CSV HEADER;" > "/Users/tonsy/Documents/sgt-seek/reports/daily_audit_$TIMESTAMP.csv"
# DB Pruning (Keep 30 Days)
docker exec -i sgt-postgres psql -U tonsy -d sgt_root -c "DELETE FROM risk_audit WHERE analyzed_at < NOW() - INTERVAL '30 days';"
echo "✅ Sentry Maintenance Complete: $(date)" >> "/Users/tonsy/Documents/sgt-seek/reports/sentry.log"
