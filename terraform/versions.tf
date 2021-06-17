terraform {
  required_version = ">= 1.0.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.3.2"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "3.71.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.path_kubeconfig
  insecure    = var.insecure_kubeconfig
}

provider "helm" {
  kubernetes {
    config_path = var.path_kubeconfig
  }
}

provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
  credentials = file(var.gcp_sa_key_path)
}
