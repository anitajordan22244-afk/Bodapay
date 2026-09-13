#!/bin/bash

set -e

echo " Setting up Bodapay..."

# Check prerequisites
echo "Checking prerequisites..."

if ! command -v cargo &> /dev/null; then
    echo " Rust/Cargo not found. Please install from https://rustup.rs/"
    exit 1
fi

if ! command -v go &> /dev/null; then
    echo " Go not found. Please install Go 1.21+"
    exit 1
fi

if ! command -v node &> /dev/null; then
    echo " Node.js not found. Please install Node.js 18+"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo " Docker not found. Please install Docker"
    exit 1
fi

echo " All prerequisites found"

# Setup Rust contracts
echo " Setting up Soroban contracts..."
cd contracts
rustup target add wasm32-unknown-unknown
cargo build --target wasm32-unknown-unknown --release
cd ..

# Setup Go backend
echo " Setting up Go backend..."
cd apps/backend
go mod download
go mod tidy
cd ../..

# Setup React frontend
echo " Setting up React frontend..."
cd apps/frontend
npm install
cd ../..

# Create .env files
echo " Creating environment files..."

if [ ! -f apps/backend/.env ]; then
    cat > apps/backend/.env << EOF
PORT=8080
DATABASE_URL=postgres://bodapay:bodapay_password@localhost:5432/bodapay?sslmode=disable
STELLAR_NETWORK=testnet
HORIZON_URL=https://horizon-testnet.stellar.org
NETWORK_PASSPHRASE=Test SDF Network ; September 2015
CONTRACT_ID=
ESCROW_CONTRACT_ID=
EOF
    echo " Created apps/backend/.env"
fi

if [ ! -f apps/frontend/.env ]; then
    cp apps/frontend/.env.example apps/frontend/.env
    echo " Created apps/frontend/.env"
fi

echo " Setup complete!"
echo ""
echo "Next steps:"
echo "1. Start services: docker compose -f infra/docker-compose.yml up -d"
echo "2. Deploy contracts: ./scripts/deploy_contracts.sh"
echo "3. Update CONTRACT_ID in apps/backend/.env"
echo "4. Start backend: cd apps/backend && go run main.go"
echo "5. Start frontend: cd apps/frontend && npm start"
