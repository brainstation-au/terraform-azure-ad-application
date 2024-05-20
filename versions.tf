terraform {
  required_version = ">= 1.6"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.2.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.11.1"
    }
  }
}
