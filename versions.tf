terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
    }
  }
  required_version = ">= 1"
}
