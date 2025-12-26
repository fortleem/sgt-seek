# SGT Platform Deployment Guide

## Overview
This guide covers deployment of the Smart Global Trade (SGT) Platform in various environments.

## Deployment Options

### 1. Local Development
```bash
# Clone repository
git clone <repository-url>
cd sgt-seek

# Setup virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate  # Windows

# Install dependencies
pip install -r requirements.txt

# Setup environment
cp .env.example .env
# Edit .env with your configuration

# Initialize database
python scripts/startup.py

# Validate installation
python scripts/validate.py

# Start development server
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
```

### 2. Docker Deployment
```bash
# Build image
docker build -t sgt-platform .

# Run with docker-compose
docker-compose up -d

# Check logs
docker-compose logs -f
```

### 3. Kubernetes Deployment
```bash
# Apply configurations
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Check status
kubectl get pods -n sgt-platform
kubectl logs -f deployment/sgt-platform -n sgt-platform
```

## Environment Configuration

### Required Environment Variables
```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/sgt_db
DATABASE_POOL_SIZE=20
DATABASE_MAX_OVERFLOW=30

# Redis
REDIS_URL=redis://localhost:6379/0
REDIS_PASSWORD=your-redis-password

# Security
SECRET_KEY=your-super-secret-key-here
JWT_SECRET_KEY=your-jwt-secret-key
JWT_ALGORITHM=HS256
JWT_EXPIRE_MINUTES=1440

# Application
ENVIRONMENT=production
DEBUG=false
API_V1_STR=/api/v1
PROJECT_NAME=SGT Platform

# AI Services
AI_MODEL_PATH=/app/models
AI_CACHE_TTL=3600

# External Services
IDENTITY_SERVICE_URL=https://identity.sgt.com
PAYMENT_SERVICE_URL=https://payment.sgt.com
NOTIFICATION_SERVICE_URL=https://notify.sgt.com

# Monitoring
SENTRY_DSN=your-sentry-dsn
LOG_LEVEL=INFO
```

### Optional Environment Variables
```bash
# Performance
WORKERS=4
WORKER_CONNECTIONS=1000
KEEPALIVE_TIMEOUT=65

# Caching
CACHE_TTL=300
CACHE_MAX_SIZE=1000

# Rate Limiting
RATE_LIMIT_REQUESTS=100
RATE_LIMIT_WINDOW=60
```

## Database Setup

### PostgreSQL Configuration
```sql
-- Create database
CREATE DATABASE sgt_db;

-- Create user
CREATE USER sgt_user WITH PASSWORD 'your-password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE sgt_db TO sgt_user;

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
```

### Database Migration
```bash
# Run migrations
alembic upgrade head

# Create initial data
python scripts/startup.py

# Validate database
python scripts/validate.py
```

## Redis Configuration

### Redis Setup
```bash
# Install Redis
sudo apt-get install redis-server  # Ubuntu
brew install redis  # macOS

# Configure Redis
sudo nano /etc/redis/redis.conf

# Start Redis
sudo systemctl start redis
sudo systemctl enable redis
```

### Redis Configuration
```conf
# /etc/redis/redis.conf
bind 127.0.0.1
port 6379
requirepass your-redis-password
maxmemory 2gb
maxmemory-policy allkeys-lru
```

## SSL/TLS Configuration

### Let's Encrypt Certificate
```bash
# Install certbot
sudo apt-get install certbot python3-certbot-nginx

# Generate certificate
sudo certbot --nginx -d api.sgt.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

### Nginx Configuration
```nginx
server {
    listen 80;
    server_name api.sgt.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.sgt.com;

    ssl_certificate /etc/letsencrypt/live/api.sgt.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.sgt.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Monitoring & Logging

### Application Monitoring
```yaml
# docker-compose.monitoring.yml
version: '3.8'
services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin

  loki:
    image: grafana/loki
    ports:
      - "3100:3100"

  promtail:
    image: grafana/promtail
    volumes:
      - /var/log:/var/log
      - ./monitoring/promtail.yml:/etc/promtail/promtail.yml
```

### Health Checks
```bash
# Application health
curl http://localhost:8000/health

# Database health
curl http://localhost:8000/health/database

# Redis health
curl http://localhost:8000/health/redis

# AI services health
curl http://localhost:8000/health/ai
```

## Security Hardening

### Firewall Configuration
```bash
# UFW setup
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw deny 8000/tcp  # Block direct API access
```

### Security Headers
```python
# src/middleware/security.py
from fastapi import FastAPI
from fastapi.middleware.httpsredirect import HTTPSRedirectMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware

app = FastAPI()

# Security middleware
app.add_middleware(HTTPSRedirectMiddleware)
app.add_middleware(TrustedHostMiddleware, allowed_hosts=["api.sgt.com"])
```

## Performance Optimization

### Database Optimization
```sql
-- Create indexes
CREATE INDEX idx_trade_requests_user_id ON trade_requests(user_id);
CREATE INDEX idx_trade_requests_status ON trade_requests(status);
CREATE INDEX idx_ai_inferences_entity_id ON ai_inference_records(entity_id);
CREATE INDEX idx_commission_locks_transaction_id ON commission_locks(transaction_id);

-- Database configuration
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
```

### Application Optimization
```python
# Connection pooling
DATABASE_URL = "postgresql://user:pass@localhost/db?pool_size=20&max_overflow=30"

# Caching configuration
CACHE_CONFIG = {
    "default": {
        "backend": "django_redis.cache.RedisCache",
        "LOCATION": "redis://127.0.0.1:6379/1",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
            "COMPRESSOR": "django_redis.compressors.zlib.ZlibCompressor",
        }
    }
}
```

## Backup & Recovery

### Database Backup
```bash
#!/bin/bash
# backup.sh
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups"
DB_NAME="sgt_db"

# Create backup
pg_dump -h localhost -U sgt_user $DB_NAME > $BACKUP_DIR/sgt_db_$DATE.sql

# Compress backup
gzip $BACKUP_DIR/sgt_db_$DATE.sql

# Remove old backups (keep 7 days)
find $BACKUP_DIR -name "sgt_db_*.sql.gz" -mtime +7 -delete
```

### Automated Backup
```bash
# Add to crontab
0 2 * * * /path/to/backup.sh
```

## Scaling

### Horizontal Scaling
```yaml
# docker-compose.scale.yml
version: '3.8'
services:
  api:
    image: sgt-platform:latest
    deploy:
      replicas: 3
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/sgt_db
    depends_on:
      - db
      - redis

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - api
```

### Load Balancing
```nginx
# nginx.conf
upstream sgt_api {
    server api_1:8000;
    server api_2:8000;
    server api_3:8000;
}

server {
    listen 80;
    location / {
        proxy_pass http://sgt_api;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Troubleshooting

### Common Issues
1. **Database Connection Failed**
   - Check DATABASE_URL format
   - Verify database is running
   - Check network connectivity

2. **AI Models Not Loading**
   - Verify model files exist
   - Check file permissions
   - Validate model paths

3. **High Memory Usage**
   - Monitor connection pool size
   - Check for memory leaks
   - Optimize query performance

### Debug Commands
```bash
# Check application logs
docker-compose logs -f api

# Database connections
psql -h localhost -U sgt_user -d sgt_db -c "SELECT count(*) FROM pg_stat_activity;"

# Redis status
redis-cli info memory

# System resources
htop
df -h
free -h
```

## Rollback Procedures

### Application Rollback
```bash
# Previous version
docker-compose down
docker pull sgt-platform:previous-tag
docker-compose up -d

# Database rollback
alembic downgrade -1
```

### Emergency Procedures
```bash
# Stop all services
docker-compose down

# Restore database
psql -h localhost -U sgt_user -d sgt_db < backup.sql

# Start services
docker-compose up -d
```

## Support Contacts

### Technical Support
- Email: support@sgt.com
- Phone: +1-555-SGT-HELP
- Documentation: https://docs.sgt.com

### Emergency Contacts
- On-call Engineer: +1-555-EMERGENCY
- System Administrator: admin@sgt.com
