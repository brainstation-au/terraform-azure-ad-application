resource "azuread_application_registration" "this" {
  display_name = var.application_name
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application_registration.this.client_id
}

resource "time_rotating" "application_password" {
  rotation_days = 30
}

resource "azuread_application_password" "this" {
  count          = var.create_application_password ? 1 : 0
  application_id = azuread_application_registration.this.id
  rotate_when_changed = {
    rotation = time_rotating.application_password.id
  }
}

resource "azuread_application_federated_identity_credential" "github-actions-branch-main" {
  for_each       = var.federated_identities
  application_id = azuread_application_registration.this.id
  display_name   = each.key
  description    = each.value.description
  audiences      = each.value.audiences
  issuer         = each.value.issuer
  subject        = each.value.subject
}

