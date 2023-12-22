terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.10.0"
    }
  }

  required_version = ">= 1.6.5"
}

provider "azuread" {}

provider "time" {}
