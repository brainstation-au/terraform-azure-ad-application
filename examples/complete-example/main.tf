module "azure-ad-application" {
  source                      = "../.."
  application_name            = "test-app"
  create_application_password = true
  federated_identities = {
    github-actions-branch-main = {
      description = "On push to main branch only"
      audiences   = ["api://AzureADTokenExchange"]
      issuer      = "https://token.actions.githubusercontent.com"
      subject     = "repo:org-name/repo-name:ref:refs/heads/main"
    }
  }
}
