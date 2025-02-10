-- Ensure passwords are stored using scram-sha-256 (for enhanced security)
ALTER SYSTEM SET password_encryption = 'scram-sha-256';
SELECT pg_reload_conf();

-- Set password for postgres user
ALTER USER postgres WITH PASSWORD 'C@RD@N0123';

-- Create the cip60 database if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'cip60') THEN
        CREATE DATABASE cip60;
    END IF;
END $$;

-- Connect to the cip60 database
\connect cip60;

-- Ensure schema exists
CREATE SCHEMA IF NOT EXISTS cip60 AUTHORIZATION postgres;

-- Ensure all objects in the schema are owned by postgres
ALTER SCHEMA cip60 OWNER TO postgres;

-- Truncate indexer_state table if it exists
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'cip60' AND table_name = 'indexer_state') THEN
        TRUNCATE TABLE cip60.indexer_state RESTART IDENTITY;
    END IF;
END $$;

-- Create indexer_state table
CREATE TABLE IF NOT EXISTS cip60.indexer_state (
    id SERIAL PRIMARY KEY,
    last_slot BIGINT NOT NULL,
    last_block_hash VARCHAR(64) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexer_state index
CREATE INDEX IF NOT EXISTS idx_indexer_state_updated_at ON cip60.indexer_state (updated_at);

-- Create assets table
CREATE TABLE IF NOT EXISTS cip60.assets (
    id SERIAL PRIMARY KEY,
    policy_id VARCHAR(56) NOT NULL,
    asset_name TEXT NOT NULL,
    metadata_json JSONB NOT NULL,
    metadata_version VARCHAR(10) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_policy_asset UNIQUE (policy_id, asset_name)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_assets_policy_id ON cip60.assets (policy_id);
CREATE INDEX IF NOT EXISTS idx_assets_metadata ON cip60.assets USING GIN (metadata_json);

-- Create function for automatic updated_at changes
CREATE OR REPLACE FUNCTION cip60.update_updated_at_column()
RETURNS TRIGGER AS $$ 
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to update updated_at column on update
CREATE TRIGGER update_assets_updated_at
    BEFORE UPDATE ON cip60.assets
    FOR EACH ROW
    EXECUTE FUNCTION cip60.update_updated_at_column();

-- Grant privileges to postgres user
GRANT ALL PRIVILEGES ON SCHEMA cip60 TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cip60 TO postgres;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA cip60 TO postgres;

-- Ensure privileges are granted for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA cip60 GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES IN SCHEMA cip60 GRANT USAGE, SELECT ON SEQUENCES TO postgres;
