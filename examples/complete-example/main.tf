module "azure-ad-application" {
  source                   = "../.."
  github_actions_auth_type = "secret"
  github_org               = "example"
  github_repo              = "example"
}
