variable "application_name" {
  description = "The display name for the application (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
  nullable    = false
  validation {
    condition     = length(var.application_name) > 2
    error_message = "The application name must have 3 or more characters"
  }
}

variable "github_actions_auth_type" {
  type        = string
  description = "Authenticate either with client secret or oidc provider."
  default     = "oidc"
  validation {
    condition     = contains(["oidc", "secret"], var.github_actions_auth_type)
    error_message = "Must be either \"oidc\" or \"secret\"."
  }
}

variable "github_org" {
  type        = string
  description = "github.com user/org ID"
  default     = ""
}

variable "github_repo" {
  type        = string
  description = "Repository name"
  default     = ""
  validation {
    condition     = length(var.github_repo) > 2
    error_message = "A repository name is required."
  }
}

variable "github_identifier" {
  type        = string
  description = "Action identifier"
  default     = "ref:refs/heads/main"
  validation {
    condition     = can(regex("^(ref:.+|environment:.+|pull_request|\\*)$", var.github_identifier))
    error_message = "Invalid github action identifier."
  }
}
