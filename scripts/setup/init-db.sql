-- Create database extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create additional databases for multi-tenancy if needed
-- CREATE DATABASE sgt_audit;
-- CREATE DATABASE sgt_ai;
