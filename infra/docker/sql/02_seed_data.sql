-- SGT Bootstrap Seed Data

-- 1. Insert System Roles / Users
INSERT INTO users (email, role, kyc_status) VALUES
('trader_alpha@sgt.com', 'TRADER', 'VERIFIED'),
('trader_beta@sgt.com', 'TRADER', 'VERIFIED'),
('financier_prime@sgt.com', 'FINANCIER', 'VERIFIED'),
('logistics_global@sgt.com', 'LOGISTICS', 'VERIFIED'),
('admin@sgt.com', 'ADMIN', 'VERIFIED')
ON CONFLICT (email) DO NOTHING;

-- 2. Insert Sample Trades (Phase 1)
INSERT INTO trades (initiator_id, commodity_type, quantity, target_price, status) 
SELECT id, 'CRUDE_OIL', 50000, 75.50, 'OPEN' 
FROM users WHERE email = 'trader_alpha@sgt.com'
LIMIT 1;

INSERT INTO trades (initiator_id, commodity_type, quantity, target_price, status) 
SELECT id, 'WHEAT_HARD_RED', 1200, 310.00, 'MATCHED' 
FROM users WHERE email = 'trader_beta@sgt.com'
LIMIT 1;

-- 3. Insert Sample Audit Log entry
INSERT INTO system_audit_logs (service_name, action, payload) 
VALUES ('system-bootstrap', 'INITIAL_SEED', '{"status": "success", "version": "2.0"}');
