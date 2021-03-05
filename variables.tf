# GCP vars

variable "GCP_PROJECT" {
  description = "GCP project for crossplane resources"
}

variable "GCP_REGION" {
  description = "GCP resource region"
  default = "europe-west3"
}

variable "GCP_ZONE" {
  description = "GCP resource zone"
  default = "europe-west3-a"
}

variable "GCP_SA" {
  description = "SA to be used by Crossplane GCP Provider"
  default = "crossplane"
}

variable "GCP_SERVICES" {
  description = "API Services to activate"
  type        = list(string)
  default     = ["container.googleapis.com", "sqladmin.googleapis.com", "redis.googleapis.com", "compute.googleapis.com","servicenetworking.googleapis.com"]
}

variable "GCP_ROLES" {
  description = "GCP Roles"
  type        = list(string)
  default     = ["roles/iam.serviceAccountUser", "roles/cloudsql.admin", "roles/container.admin", "roles/redis.admin","roles/compute.networkAdmin", "roles/storage.admin"]
}

# Crossplane vars

variable "CROSSPLANE_NAMESPACE" {
  description = "namespace for Crossplane installation"
  default = "crossplane-system"
}

variable "PATH_KUBECONFIG" {
  description = "path kubeconfig"
}

variable "CROSSPLANE_REGISTRY" {
  description = "registry for Crossplane packages"
}

# Argo vars

variable "ARGOCD_NAMESPACE" {
  description = "namespace for Argo installation"
  default = "argo"
}

variable "ARGOCD_HOSTNAME" {
  description = "FQDN for Argo web server"
}

# Dashboard vars

variable "DASHBOARD_NAMESPACE" {
  description = "namespace for dashboard installation"
  default = "kerberus-dashboard-ns"
}
