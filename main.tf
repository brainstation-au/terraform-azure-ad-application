data "azurerm_client_config" "current" {}

resource "azuread_application_registration" "this" {
  display_name = "${var.github_org}/${var.github_repo}"
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application_registration.this.client_id
}

resource "time_rotating" "this" {
  rotation_days = 30
}

resource "azuread_application_password" "this" {
  count          = var.github_actions_auth_type == "secret" ? 1 : 0
  application_id = azuread_application_registration.this.id
  rotate_when_changed = {
    rotation = time_rotating.this.id
  }
}

resource "azuread_application_federated_identity_credential" "this" {
  count          = var.github_actions_auth_type == "oidc" ? 1 : 0
  application_id = azuread_application_registration.this.id
  display_name   = "github-actions"
  description    = "OIDC for github actions"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_org}/${var.github_repo}:${var.github_identifier}"
}

resource "github_actions_secret" "client_secret" {
  count           = var.github_actions_auth_type == "secret" ? 1 : 0
  repository      = var.github_repo
  secret_name     = "AZURE_CLIENT_SECRET"
  plaintext_value = azuread_application_password.this[0].value
}

resource "github_actions_secret" "client_id" {
  repository      = var.github_repo
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = azuread_application_registration.this.client_id
}

resource "github_actions_secret" "tenant_id" {
  repository      = var.github_repo
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azurerm_client_config.current.tenant_id
}
