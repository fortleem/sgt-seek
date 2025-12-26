-- SGT Core Schema Initialization

-- 1. Users & Identity
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL, -- TRADER, FINANCIER, LOGISTICS, ADMIN
    kyc_status TEXT DEFAULT 'PENDING',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Trade Requests (Blueprint Phase 1)
CREATE TABLE IF NOT EXISTS trades (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    initiator_id UUID REFERENCES users(id),
    commodity_type TEXT NOT NULL,
    quantity NUMERIC NOT NULL,
    target_price NUMERIC,
    status TEXT DEFAULT 'OPEN', -- OPEN, MATCHED, NEGOTIATING, COMPLETED
    governance_check_id TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Shipments & Tracking (Blueprint Phase 5)
CREATE TABLE IF NOT EXISTS shipments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trade_id UUID REFERENCES trades(id),
    carrier_name TEXT,
    tracking_number TEXT UNIQUE,
    current_location TEXT,
    estimated_arrival TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'PREPARING'
);

-- 4. Audit Logs (Mirror for Rust Audit Service)
CREATE TABLE IF NOT EXISTS system_audit_logs (
    id SERIAL PRIMARY KEY,
    service_name TEXT,
    action TEXT,
    payload JSONB,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
