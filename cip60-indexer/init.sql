ALTER SYSTEM SET password_encryption = 'scram-sha-256';
SELECT pg_reload_conf();

ALTER USER postgres WITH PASSWORD 'C@RD@N0123';

DROP DATABASE IF EXISTS cip60;
CREATE DATABASE cip60;

\c cip60;

CREATE SCHEMA IF NOT EXISTS cip60;
ALTER SCHEMA cip60 OWNER TO postgres;

DROP TABLE IF EXISTS cip60.indexer_state CASCADE;
DROP TABLE IF EXISTS cip60.assets CASCADE;

CREATE TABLE cip60.indexer_state (
    id serial PRIMARY KEY,
    last_slot bigint NOT NULL,
    last_block_hash character varying(64) NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_indexer_state_updated_at ON cip60.indexer_state (updated_at DESC);

CREATE TABLE cip60.assets (
    id SERIAL PRIMARY KEY,
    policy_id VARCHAR(56) NOT NULL,
    asset_name TEXT NOT NULL,
    metadata_json JSONB NOT NULL,
    metadata_version VARCHAR(10) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_policy_asset UNIQUE (policy_id, asset_name)
);

CREATE INDEX idx_assets_policy_id ON cip60.assets (policy_id);
CREATE INDEX idx_assets_metadata ON cip60.assets USING GIN (metadata_json);

CREATE OR REPLACE FUNCTION cip60.update_updated_at_column()
RETURNS TRIGGER AS $$ 
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_assets_updated_at
    BEFORE UPDATE ON cip60.assets
    FOR EACH ROW
    EXECUTE FUNCTION cip60.update_updated_at_column();

GRANT ALL PRIVILEGES ON SCHEMA cip60 TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cip60 TO postgres;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA cip60 TO postgres;

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS idx_metadata_json_gin ON cip60.assets USING GIN (metadata_json);
CREATE INDEX IF NOT EXISTS idx_metadata_json_text ON cip60.assets USING GIN ((metadata_json::text) gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_assets_metadata_json ON cip60.assets USING GIN(metadata_json jsonb_path_ops);

ALTER DEFAULT PRIVILEGES IN SCHEMA cip60 GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES IN SCHEMA cip60 GRANT USAGE, SELECT ON SEQUENCES TO postgres;
