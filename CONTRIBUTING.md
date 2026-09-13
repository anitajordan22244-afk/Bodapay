# Contributing to Bodapay

Thanks for your interest in contributing! This guide covers how the repo is
laid out, how to get a local environment running, and what we expect from a
pull request.

## Project layout

This is a monorepo:

```
apps/backend/     Go API server (Gin, GORM, Stellar Go SDK)
apps/frontend/    React web interface
contracts/        Soroban smart contracts (Rust)
packages/sdk-js/  Official JavaScript SDK (@bodapay/sdk)
infra/            Kubernetes manifests, monitoring config, docker-compose
docs/             Architecture and API documentation
scripts/          Setup and deployment scripts
```

## Getting started

```bash
git clone https://github.com/anitajordan22244-afk/Bodapay.git
cd Bodapay
chmod +x scripts/setup.sh
./scripts/setup.sh
docker compose -f infra/docker-compose.yml up -d
```

See the [README](README.md) for prerequisites and more detail on running
each component individually.

## Making changes

1. **Find or open an issue** before starting non-trivial work, so effort
   isn't duplicated and the approach can be agreed on up front. Issues are
   labeled by area (`backend`, `frontend`, `contracts`, `docs`, `infra`) and
   size, so pick one that matches the time you have.
2. **Branch off `main`** with a descriptive name, e.g. `fix/deposit-overflow`
   or `feat/recurring-webhooks`.
3. **Keep PRs scoped.** One logical change per PR is easier to review and
   easier to revert if something's wrong.
4. **Write a clear PR description**: what changed, why, and how you verified
   it (test output, screenshots for UI changes, etc.).

## Testing

Run the tests for whatever you touched before opening a PR:

```bash
# Smart contracts
cd contracts && cargo test

# Backend
cd apps/backend && go vet ./... && go build ./... && go test ./...

# Frontend
cd apps/frontend && npm test
```

Contract changes that touch fees, escrow, or remittance logic should also
run the property-based and fuzz suites:

```bash
cd contracts
cargo test --features prop --test prop_conditions
cargo test --test fuzz_escrow --test fuzz_fees --test fuzz_remittance
```

These generate a large number of ephemeral per-case snapshot files under
`contracts/test_snapshots/` — please don't commit those; only commit
snapshot changes that come from the regular `cargo test --lib` run, and only
when they reflect a real behavior change.

## Code style

- **Go**: `go vet` and `gofmt` must be clean; there's no separate linter
  config beyond the standard toolchain.
- **Rust**: keep `cargo build` and `cargo clippy` warning-free where
  practical; new warnings introduced by a PR should be resolved, not
  suppressed.
- **JS/TS**: `npm run lint` (ESLint) must pass in `apps/frontend`.
- Match the existing naming and comment density in the file you're editing
  rather than introducing a new style.

## Commit messages

Write commit messages that explain *why*, not just *what* — the diff already
shows what changed. A short summary line, then a body if the reasoning isn't
obvious from the code alone.

## Reporting bugs

Open an issue with: what you expected, what happened instead, and steps to
reproduce. For contract bugs, a minimal failing test (even a rough one) is
extremely helpful.

## Reporting security issues

Please do **not** open a public issue for security vulnerabilities — see
[SECURITY.md](SECURITY.md) for how to report those privately.

## Questions

If anything in this guide is unclear or out of date, open an issue — that's
itself a useful contribution.
