#!/bin/bash
echo "=========================================="
echo "SGT PLATFORM DATABASE SETUP"
echo "=========================================="

# Check if PostgreSQL is running
if ! pg_isready -h localhost -p 5432 > /dev/null 2>&1; then
    echo "❌ PostgreSQL is not running on localhost:5432"
    echo ""
    echo "Please start PostgreSQL with one of these commands:"
    echo "  brew services start postgresql  # If using Homebrew"
    echo "  OR"
    echo "  pg_ctl -D /usr/local/var/postgres start"
    echo ""
    echo "If PostgreSQL is not installed:"
    echo "  brew install postgresql"
    echo "  brew services start postgresql"
    exit 1
fi

echo "✅ PostgreSQL is running"

# Create database if it doesn't exist
echo "Creating database 'sgt_platform'..."
psql -U tonsy -h localhost -c "CREATE DATABASE sgt_platform;" 2>/dev/null && echo "✅ Database created" || echo "⚠️  Database already exists or connection issue"

# Setup schema
echo "Setting up database schema..."
PGPASSWORD="Mk98iuiu." psql -U tonsy -h localhost -d sgt_platform << 'SQL'
-- ============================================
-- SGT PLATFORM DATABASE SCHEMA
-- Blueprint Pages 24-30: Comprehensive Data Model
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- CORE ENTITIES (Blueprint Page 24-25)
-- ============================================

-- User Entity (Blueprint Page 24)
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('IMPORTER', 'EXPORTER', 'LOGISTICS', 'QC', 'FINANCIER', 'ADMIN')),
    kyc_status VARCHAR(20) DEFAULT 'PENDING',
    jurisdiction VARCHAR(10),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Trade Request Entity (Blueprint Page 25-26)
CREATE TABLE IF NOT EXISTS trade_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    importer_id UUID REFERENCES users(id),
    product_category VARCHAR(100) NOT NULL,
    specifications JSONB NOT NULL,
    quantity DECIMAL(15, 4),
    unit VARCHAR(50),
    destination_country VARCHAR(2),
    incoterm VARCHAR(3) CHECK (incoterm IN ('CIF', 'FOB', 'EXW')),
    status VARCHAR(50) DEFAULT 'DRAFT',
    assigned_exporters UUID[],
    jurisdiction VARCHAR(10),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Exporter Quote Entity (Blueprint Page 26-27)
CREATE TABLE IF NOT EXISTS exporter_quotes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID REFERENCES trade_requests(id),
    exporter_id UUID REFERENCES users(id),
    total_price DECIMAL(15, 2),
    currency VARCHAR(3),
    validity_period TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'DRAFT',
    ai_confidence_score DECIMAL(3, 2),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Contract Entity (Blueprint Page 27-28)
CREATE TABLE IF NOT EXISTS contracts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID REFERENCES trade_requests(id),
    clauses JSONB NOT NULL,
    payment_terms JSONB,
    jurisdiction VARCHAR(10),
    status VARCHAR(20) DEFAULT 'DRAFT',
    ai_clause_risk_score DECIMAL(3, 2),
    signed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Shipment Entity (Blueprint Page 29)
CREATE TABLE IF NOT EXISTS shipments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID REFERENCES trade_requests(id),
    ustn VARCHAR(50) UNIQUE NOT NULL,
    origin VARCHAR(100),
    destination VARCHAR(100),
    status VARCHAR(50) DEFAULT 'PRE_TRANSIT',
    ai_predicted_delay TIMESTAMPTZ,
    expected_delivery TIMESTAMPTZ,
    actual_delivery TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Commission Lock Entity (Blueprint Page 30)
CREATE TABLE IF NOT EXISTS commission_locks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL,
    commission_type VARCHAR(20) CHECK (commission_type IN ('TRADE', 'FINANCING', 'MARKETPLACE')),
    amount DECIMAL(15, 2),
    currency VARCHAR(3),
    settlement_path VARCHAR(20) CHECK (settlement_path IN ('BANK', 'CUSTODIAL', 'SMART_CONTRACT')),
    lock_status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    released_at TIMESTAMPTZ
);

-- AI Inference Record (Blueprint Page 30-31)
CREATE TABLE IF NOT EXISTS ai_inference_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    model_name VARCHAR(100),
    model_version VARCHAR(50),
    input_features JSONB,
    output_result JSONB,
    confidence_score DECIMAL(3, 2),
    linked_entity_id UUID,
    linked_entity_type VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX IF NOT EXISTS idx_trade_requests_status ON trade_requests(status);
CREATE INDEX IF NOT EXISTS idx_trade_requests_importer ON trade_requests(importer_id);
CREATE INDEX IF NOT EXISTS idx_shipments_ustn ON shipments(ustn);
CREATE INDEX IF NOT EXISTS idx_commission_locks_status ON commission_locks(lock_status);
CREATE INDEX IF NOT EXISTS idx_ai_records_entity ON ai_inference_records(linked_entity_id, linked_entity_type);

-- ============================================
-- SAMPLE DATA FOR TESTING
-- ============================================

-- Insert test users
INSERT INTO users (id, email, name, role, kyc_status, jurisdiction) VALUES
    (uuid_generate_v4(), 'importer@test.com', 'Test Importer', 'IMPORTER', 'APPROVED', 'US'),
    (uuid_generate_v4(), 'exporter@test.com', 'Test Exporter', 'EXPORTER', 'APPROVED', 'DE'),
    (uuid_generate_v4(), 'logistics@test.com', 'Test Logistics', 'LOGISTICS', 'APPROVED', 'GB')
ON CONFLICT (email) DO NOTHING;

-- Insert test commission lock
INSERT INTO commission_locks (id, transaction_id, commission_type, amount, currency, settlement_path, lock_status) VALUES
    (uuid_generate_v4(), uuid_generate_v4(), 'TRADE', 1500.00, 'USD', 'BANK', 'ACTIVE')
ON CONFLICT DO NOTHING;

-- Insert test trade request
INSERT INTO trade_requests (id, importer_id, product_category, specifications, status) VALUES
    (uuid_generate_v4(), (SELECT id FROM users WHERE email = 'importer@test.com'), 'ELECTRONICS', '{"category": "electronics", "specs": "high-quality"}', 'DRAFT')
ON CONFLICT DO NOTHING;

-- ============================================
-- VERIFICATION
-- ============================================
SELECT '✅ SGT Platform Database Schema Created Successfully' as message;
SELECT COUNT(*) as users_count FROM users;
SELECT COUNT(*) as trade_requests_count FROM trade_requests;
SELECT COUNT(*) as commission_locks_count FROM commission_locks;
SQL

echo ""
echo "=========================================="
echo "DATABASE SETUP COMPLETE"
echo "=========================================="
echo "✅ Database: sgt_platform"
echo "✅ Tables: 7 blueprint entities created"
echo "✅ Sample data inserted"
echo "✅ Indexes created for performance"
echo ""
echo "Connect to database:"
echo "  psql -U tonsy -d sgt_platform"
echo ""
echo "Password: Mk98iuiu."
echo "=========================================="
