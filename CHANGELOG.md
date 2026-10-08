# Changelog

All notable changes to this project are documented here. Format loosely
follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## Unreleased

### Fixed
- `contracts`: pinned `ed25519-dalek` to `2.2.0` and committed `Cargo.lock`,
  fixing a dependency-resolution break that had made the full test suite
  (`cargo test`) uncompilable.
- `contracts`: fixed `EventData::InvoiceCreated` argument/field count
  mismatch between its definition and call site.
- `contracts`: fixed four tests that had never actually run due to the
  above build break and turned out to be wrong once they did (a fuzz test
  calling the wrong function signature; three tests misreading
  `set_compliance_fee` as a flat fee instead of a percentage).
- `contracts`: removed dead code (`check_delegated_permission`) and
  cleared the remaining compiler warnings; `cargo build` is now
  warning-free.

### Added
- `CONTRIBUTING.md` and `SECURITY.md`, with GitHub private vulnerability
  reporting enabled for the repo.
- `.github/ISSUE_TEMPLATE/` (bug report, feature request) and a pull
  request template.
- `CHANGELOG.md` (this file).

### Changed
- Renamed the project and restructured into a monorepo layout:
  `backend/` → `apps/backend/`, `frontend/` → `apps/frontend/`,
  `sdks/javascript/` → `packages/sdk-js/`, `k8s/`/`monitoring/`/
  `docker-compose.yml` → `infra/`.
- Updated `.gitignore` for the new layout and to stop tracking
  `coverage/`, `docker-compose.override.yml`, and real (non-example)
  Kubernetes secrets.
