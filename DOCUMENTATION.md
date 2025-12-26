# SGT Platform Documentation

## Overview
The Smart Global Trade (SGT) Platform is a comprehensive trade execution platform built with FastAPI, SQLAlchemy, and AI services. It implements a complete workflow from trade request initiation through settlement.

## Architecture

### Core Components
- **FastAPI Backend**: RESTful API with comprehensive endpoints
- **SQLAlchemy ORM**: Database models and relationships
- **AI Services**: Contract analysis, risk assessment, shipment intelligence
- **Workflow Orchestrator**: Phase-based workflow management
- **Governor Service**: Policy enforcement and compliance

### Workflow Phases
1. **Phase 1**: Trade Request Initiation (User Service)
2. **Phase 2**: Quote Generation (AI Matching + Quote Service)
3. **Phase 3**: Contract Negotiation (Contract Analyzer + Governor)
4. **Phase 4**: Financing (Risk Engine + Financing Service)
5. **Phase 5**: Shipment (Shipment Intelligence + Logistics)
6. **Phase 6**: Settlement (Hybrid Settlement + Commission)

## Services

### Core Services
- **User Service**: RBAC, KYC/KYB workflows, user management
- **Trade Service**: Trade request lifecycle management
- **Governor Service**: Policy decisions, execution gates, compliance
- **Settlement Service**: Hybrid settlement orchestration
- **Commission Service**: Non-custodial commission enforcement

### AI Services
- **Trade Matching**: Collaborative filtering for exporter-importer matching
- **Contract Analyzer**: Risk assessment, compliance checking, terms analysis
- **Risk Engine**: Entity risk scoring, portfolio risk, default probability
- **Shipment Intelligence**: Route optimization, anomaly detection, ETA prediction

### Workflow Services
- **Workflow Orchestrator**: Phase coordination and state management
- **Phase Services**: Individual phase implementations (2-6)

## API Endpoints

### Authentication & Users
- `POST /auth/login` - User authentication
- `GET /users/me` - Current user profile
- `POST /users/register` - User registration

### Trade Management
- `POST /trade/requests` - Create trade request
- `GET /trade/requests` - List trade requests
- `GET /trade/requests/{id}` - Get trade request details
- `POST /trade/requests/{id}/match` - Find matching exporters

### Workflow Management
- `POST /workflow/start` - Start trade workflow
- `POST /workflow/{workflow_id}/advance` - Advance to next phase
- `GET /workflow/{workflow_id}/status` - Get workflow status
- `POST /workflow/{workflow_id}/complete/{phase}` - Complete phase

### Governance
- `POST /governor/decisions` - Make policy decision
- `POST /governor/gates/check` - Check execution gate
- `GET /governor/rules` - List policy rules

### Settlement & Commission
- `POST /settlement/create` - Create settlement
- `GET /settlement/{id}/status` - Get settlement status
- `POST /commission/locks` - Create commission lock
- `POST /commission/locks/{id}/gates/{type}/pass` - Pass execution gate

## Data Models

### Core Entities
- **User**: Importers, Exporters, Financiers, Logistics Providers
- **TradeRequest**: Trade specifications, requirements, budget
- **Contract**: Legal agreements, clauses, digital signatures
- **FinancingRequest**: Funding requests, offers, terms
- **Shipment**: Logistics, tracking, transport legs
- **Settlement**: Hybrid settlement paths, execution status

### Governance Entities
- **CommissionLock**: Non-custodial commission enforcement
- **ExecutionGate**: Policy enforcement checkpoints
- **AIInferenceRecord**: AI decision audit trail
- **AIRiskScore**: Risk assessment records

## AI Governance

### Decision Envelopes
- Human-in-the-loop oversight for critical decisions
- Confidence thresholds and explainability requirements
- Audit trail for all AI inferences

### Risk Management
- Real-time risk scoring and monitoring
- Portfolio risk aggregation
- Geographic and market risk assessments

## Settlement Architecture

### Hybrid Paths
- **Bank Split**: Traditional banking with escrow
- **Custodial**: Third-party custodian services
- **Smart Contract**: Blockchain-based execution

### Execution Gates
- Commission lock enforcement
- Compliance validation
- Risk threshold checks

## Deployment

### Prerequisites
- Python 3.9+
- PostgreSQL database
- Redis for caching
- Docker (optional)

### Setup
```bash
# Install dependencies
pip install -r requirements.txt

# Initialize database
python scripts/startup.py

# Validate installation
python scripts/validate.py

# Start API server
uvicorn src.main:app --host 0.0.0.0 --port 8000
```

### Environment Variables
```bash
DATABASE_URL=postgresql://user:pass@localhost/sgt_db
REDIS_URL=redis://localhost:6379
SECRET_KEY=your-secret-key
ENVIRONMENT=development
```

## Security

### Authentication
- JWT-based authentication
- Role-based access control (RBAC)
- Multi-factor authentication support

### Compliance
- KYC/KYB workflows
- Jurisdiction-aware compliance
- Audit trail for all transactions

### Data Protection
- Encryption at rest and in transit
- PII protection and masking
- GDPR and data privacy compliance

## Monitoring & Observability

### Telemetry
- OpenTelemetry tracing
- Performance metrics
- Error tracking and alerting

### Logging
- Structured logging with correlation IDs
- Audit logging for compliance
- Log aggregation and search

## Testing

### Unit Tests
```bash
pytest tests/unit/
```

### Integration Tests
```bash
pytest tests/integration/
```

### End-to-End Tests
```bash
pytest tests/e2e/
```

## API Documentation

### Swagger UI
- Available at `http://localhost:8000/docs`
- Interactive API documentation
- Request/response examples

### OpenAPI Spec
- Available at `http://localhost:8000/openapi.json`
- Machine-readable API specification

## Support

### Troubleshooting
- Check logs for error messages
- Validate configuration settings
- Run health checks: `GET /health`

### Common Issues
- Database connection failures
- AI model loading errors
- Permission denied errors

## License

Copyright 2025 Smart Global Trade Platform. All rights reserved.
