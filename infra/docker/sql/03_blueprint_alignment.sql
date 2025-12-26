-- SGT Blueprint Role-Specific Execution Gates
ALTER TABLE trades ADD COLUMN IF NOT EXISTS ustn_code VARCHAR(50);
ALTER TABLE trades ADD COLUMN IF NOT EXISTS risk_band_id INTEGER;
ALTER TABLE trades ADD COLUMN IF NOT EXISTS commission_lock_status VARCHAR(20) DEFAULT 'INACTIVE';

CREATE TABLE IF NOT EXISTS commission_locks (
    lock_id SERIAL PRIMARY KEY,
    trade_id INTEGER, 
    financier_id INTEGER,
    amount DECIMAL(18,2),
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS shipment_legs (
    id SERIAL PRIMARY KEY,
    trade_id INTEGER,
    ustn_code VARCHAR(50),
    carrier_id VARCHAR(50),
    status VARCHAR(50),
    qc_verified BOOLEAN DEFAULT FALSE
);
