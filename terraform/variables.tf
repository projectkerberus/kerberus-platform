# GCP vars

variable "GCP_PROJECT" {
  description = "GCP project for crossplane resources"
}

variable "GCP_REGION" {
  description = "GCP resource region"
  default     = "europe-west3"
}

variable "GCP_ZONE" {
  description = "GCP resource zone"
  default     = "europe-west3-a"
}

variable "GCP_SA" {
  description = "SA to be used by Crossplane GCP Provider"
  default     = "crossplane"
}

variable "GCP_SERVICES" {
  description = "API Services to activate"
  type        = list(string)
  default     = ["container.googleapis.com", "sqladmin.googleapis.com", "redis.googleapis.com", "compute.googleapis.com", "servicenetworking.googleapis.com"]
}

variable "GCP_ROLES" {
  description = "GCP Roles"
  type        = list(string)
  default     = ["roles/iam.serviceAccountUser", "roles/cloudsql.admin", "roles/container.admin", "roles/redis.admin", "roles/compute.networkAdmin", "roles/storage.admin"]
}

# Kubernetes vars

variable "PATH_KUBECONFIG" {
  description = "path kubeconfig"
}

variable "INSECURE_KUBECONFIG" {
  description = "Whether the server should be accessed without verifying the TLS certificate"
  type        = bool
  default     = false
}

variable "KERBERUS_K8S_ENDPOINT" {
  description = "Kubernetes API endpoint for Kerberus"
}

# Crossplane vars

variable "CROSSPLANE_NAMESPACE" {
  description = "namespace for Crossplane installation"
  default     = "crossplane-system"
}

variable "CROSSPLANE_VERSION" {
  description = "The desired crossplane version"
  type        = string
  default     = "v1.1.1"
}

variable "CROSSPLANE_REGISTRY" {
  description = "registry for Crossplane packages"
}

# Argo vars

variable "ARGOCD_NAMESPACE" {
  description = "namespace for Argo installation"
  default     = "argo-system"
}

variable "ARGOCD_URL" {
  description = "FQDN for Argo CD GUI"
}

variable "ARGOCD_VALUES_PATH" {
  description = "Argo CD helm chart values.yaml path"
  default     = ""
}

# Dashboard vars

variable "DASHBOARD_NAMESPACE" {
  description = "namespace for dashboard installation"
  default     = "kerberus-dashboard-system"
}

variable "IMAGE_CREDENTIALS_USERNAME" {
  description = ""
  default     = ""
}

variable "IMAGE_CREDENTIALS_PASSWORD" {
  description = ""
  default     = ""
}

variable "IMAGE_CREDENTIALS_EMAIL" {
  description = ""
  default     = ""
}

variable "GITHUB_CLIENT_ID" {
  description = "Github client id"
}

variable "GITHUB_CLIENT_SECRETS" {
  description = "Github client secrets"
}

variable "GITHUB_TOKEN" {
  description = "Github personal access token, please see: https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token"
}
variable "GITLAB_TOKEN" {
  description = "GitLab personal access token, please see: https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#create-a-personal-access-token"
}

variable "CLIENT_ID_FILE" {
  type        = string
  description = ""
}

variable "KERBERUS_DASHBOARD_URL" {
  description = "FQDN for Kerberus Dashboard GUI"
}

variable "kerberus_dashboard_repository" {
  description = "Repository URL where to locate the Kerberus chart"
  type        = string
  default     = "https://projectkerberus.github.io/kerberus-dashboard/"
}

variable "kerberus_dashboard_chart" {
  description = "Kerberus chart name to be installed."
  type        = string
  default     = "kerberus-dashboard"
}

variable "kerberus_dashboard_chart_version" {
  description = "Specify the exact Kerberus chart version to install. If this is not specified, the latest version is installed."
  type        = string
  default     = null
}

variable "KERBERUS_DASHBOARD_VALUES_PATH" {
  description = "Kerberus Dashboard helm chart values.yaml path"
  default     = ""
}
