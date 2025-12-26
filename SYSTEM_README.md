# 🛡️ SGT SEEK - CLOUD HYBRID RISK ENGINE
**Status:** Operational | **Platform:** macOS 15.6 x64

## 🚀 Core Architecture
- **API Gateway:** Nginx Port 8080
- **AI Orchestrator:** FastAPI + HuggingFace Cloud
- **Persistence:** PostgreSQL (Docker)
- **Monitoring:** Live Dashboard (Chart.js)

## 🛠️ Automated Maintenance (Cloud Sentry)
- **Schedule:** 00:00 UTC Daily
- **Provider:** GitHub Actions
- **Task:** Daily CSV Export & 30-Day DB Pruning
- **Trigger Script:** `/Users/tonsy/Documents/sgt-seek/scripts/sentry_maint.sh`

## 🔐 Security & Access
- **Target IP:** 102.187.63.229
- **SSH Protocol:** Public Key Authentication ONLY (Password Disabled)
- **Emergency Kill Token:** `da9199f8dc2e26077e53f990f04dd29b`
- **Emergency Script:** `/Users/tonsy/Documents/sgt-seek/scripts/kill_switch.sh`

## 📂 File Structure
- `/apps/ai-orchestrator/`: AI Logic & FastAPI
- `/infra/docker/`: Container Orchestration
- `/reports/`: Risk Audits & Sentry Logs
- `/scripts/`: Sentry & Kill-switch binaries

## 📡 Endpoints
- **GET /trades**: Fetch last 10 analyzed trades
- **POST /analyze**: Submit new trade for risk scoring
- **POST /emergency-stop?token=...**: Instant System Shutdown

---
*Generated Automatically on Fri Dec 26 22:41:22 EET 2025*
