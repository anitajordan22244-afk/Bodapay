# Security Policy

Bodapay handles cross-border payments, escrow, and compliance data, so we
take security reports seriously and will respond promptly.

## Supported versions

Bodapay is under active development on `main`. There are no released
versions yet — security fixes land on `main` and are not backported to
older commits.

| Version | Supported |
| ------- | --------- |
| `main`  | ✅        |

## Reporting a vulnerability

**Please do not open a public GitHub issue for security vulnerabilities.**

Use GitHub's private vulnerability reporting instead:

1. Go to the [Security tab](https://github.com/anitajordan22244-afk/Bodapay/security) of this repository.
2. Click **"Report a vulnerability"**.
3. Describe the issue: affected component (contracts, backend, frontend, or
   SDK), impact, and steps to reproduce. A minimal proof of concept is
   extremely helpful, especially for smart contract issues.

This opens a private advisory visible only to maintainers and you, so the
issue can be discussed and fixed before it's public.

If you're unable to use GitHub's reporting flow, contact the maintainer
listed on the repository directly.

## Scope

In scope:

- `contracts/` — the Soroban smart contracts (escrow, remittance hub, fees,
  disputes, upgrades)
- `apps/backend/` — the Go API server, including auth, webhooks, and
  compliance/KYC handling
- `apps/frontend/` — the React web client
- `packages/sdk-js/` — the official JavaScript SDK

Out of scope:

- Third-party dependencies (report upstream) unless the vulnerability is in
  how Bodapay uses them
- Issues requiring physical access to a user's device
- Denial-of-service reports based purely on volume (rate limiting is a known
  work area — see open issues)

## What to expect

- **Acknowledgement**: within 3 business days.
- **Triage**: we'll confirm whether the report is in scope and its severity
  within a week of acknowledgement.
- **Fix and disclosure**: timeline depends on severity and complexity; we'll
  keep you updated and credit you in the advisory (unless you'd prefer to
  stay anonymous) once a fix ships.

## Known security-relevant design notes

For contract-level security mechanisms already documented (e.g. the
reentrancy guard used in `PaymentEscrowContract`), see
[docs/security.md](docs/security.md).
