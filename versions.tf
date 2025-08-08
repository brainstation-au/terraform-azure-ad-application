terraform {
  required_version = ">= 1.6"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.4.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.6.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.13.1"
    }
  }
}
