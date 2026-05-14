# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This is a reusable Terraform module that creates Azure AD (Entra ID) application registrations and configures them for GitHub Actions authentication. It supports two auth modes: OIDC (default, using federated identity credentials) and client secret.

## Commands

```bash
# Format Terraform code
./auto/format

# Check formatting (used in CI)
./auto/lint

# Validate Terraform configuration
./auto/validate

# Run Terraform via Docker (consistent CLI version)
./auto/terraform <command>
```

CI runs `terraform fmt -recursive -check` on push to main.

## Architecture

**Single flat module** — no internal sub-modules. All resources are in `main.tf`.

### Auth modes (controlled by `github_actions_auth_type`)

- **`oidc`** (default): Creates `azuread_application_federated_identity_credential`; no secret stored. GitHub Actions uses OIDC tokens. The `github_identifier` variable controls the allowed subject (e.g. `ref:refs/heads/main`, environment, or PR).
- **`secret`**: Creates `azuread_application_password` with 30-day rotation via `time_rotating`. Stores secret in GitHub Actions secrets.

### What the module provisions

1. `azuread_application_registration` → `azuread_service_principal`
2. GitHub Actions **secrets**: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, and (if secret mode) `AZURE_CLIENT_SECRET`
3. GitHub Actions **variables**: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`

### Provider requirements (versions.tf)

- Terraform >= 1.6
- `hashicorp/azuread` ~> 3.4.0
- `integrations/github` ~> 6.6.0
- `hashicorp/time` ~> 0.13.1

### Conditional resource creation

Resources for OIDC and secret modes use `count = var.github_actions_auth_type == "oidc" ? 1 : 0` (and inverse). The `client_secret` output is only populated in secret mode.

## Examples

`examples/complete-example/` shows secret-based auth. The example uses slightly older provider versions for broader compatibility — this is intentional.
