#!/bin/bash
# SGT Automated Backup Script
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="sgt_prod_$TIMESTAMP.sql"

echo "Starting PostgreSQL Dump..."
# Use Docker to execute pg_dump from the running container
docker exec sgt-postgres pg_dump -U sgt_admin sgt_root > "/Users/tonsy/Documents/sgt-seek/backups/$BACKUP_NAME"

echo "Uploading to SGT-MinIO..."
# Placeholder for mc (MinIO Client) command
# mc cp "/Users/tonsy/Documents/sgt-seek/backups/$BACKUP_NAME" sgt-minio/backups/
echo "Backup saved locally at /Users/tonsy/Documents/sgt-seek/backups/$BACKUP_NAME"
