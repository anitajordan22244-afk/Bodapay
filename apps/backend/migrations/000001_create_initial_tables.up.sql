CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    stellar_address VARCHAR(56) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    country VARCHAR(2),
    kyc_status VARCHAR(20) DEFAULT 'pending',
    kyc_verified_at TIMESTAMPTZ,
    is_active BOOLEAN DEFAULT TRUE,
    default_currency VARCHAR(10) DEFAULT 'USD'
);
CREATE INDEX IF NOT EXISTS idx_users_deleted_at ON users(deleted_at);

CREATE TABLE IF NOT EXISTS payments (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    sender_id BIGINT NOT NULL,
    sender_account VARCHAR(56),
    recipient_id BIGINT NOT NULL,
    recipient_account VARCHAR(56),
    amount DECIMAL NOT NULL,
    currency VARCHAR(10) NOT NULL,
    target_currency VARCHAR(10),
    converted_amount DECIMAL,
    status VARCHAR(20) DEFAULT 'pending',
    tx_hash VARCHAR(255),
    contract_id VARCHAR(255),
    escrow_id VARCHAR(255),
    fee DECIMAL DEFAULT 0,
    conditions TEXT,
    notes TEXT
);
CREATE INDEX IF NOT EXISTS idx_payments_deleted_at ON payments(deleted_at);

CREATE TABLE IF NOT EXISTS invoices (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    payment_id BIGINT NOT NULL,
    invoice_no VARCHAR(50) UNIQUE NOT NULL,
    issuer_id BIGINT NOT NULL,
    recipient_id BIGINT NOT NULL,
    amount DECIMAL NOT NULL,
    currency VARCHAR(10) NOT NULL,
    due_date TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'unpaid',
    description TEXT,
    pdf_url VARCHAR(500)
);
CREATE INDEX IF NOT EXISTS idx_invoices_deleted_at ON invoices(deleted_at);
