#!/bin/bash
# SGT MinIO Bucket Setup
# Ensure MinIO is up before running
echo "Setting up SGT MinIO Buckets..."
# alias mc if installed locally or use docker alias
# mc alias set sgt-local http://localhost:9000 sgt_minio_admin sgt_minio_password
# mc mb sgt-local/backups
# mc mb sgt-local/trade-documents
echo "Bucket configuration definitions prepared."
