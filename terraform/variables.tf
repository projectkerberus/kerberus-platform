#### Kubernets ####

variable "path_kubeconfig" {
  description = "path kubeconfig"
  type        = string
}

variable "insecure_kubeconfig" {
  description = "Whether the server should be accessed without verifying the TLS certificate"
  type        = bool
  default     = false
}

#### Crossplane ####

variable "crossplane_namespace" {
  description = "The name of crossplane namespace for the Kerberus dashboard."
  type        = string
  default     = "crossplane-system"
}

variable "crossplane_repository" {
  description = "Repository URL where to locate the crossplane chart"
  type        = string
  default     = "https://charts.crossplane.io/stable"
}

variable "crossplane_chart" {
  description = "crossplane chart name to be installed."
  type        = string
  default     = "crossplane"
}

variable "crossplane_chart_version" {
  description = "Specify the exact crossplane chart version to install. If this is not specified, the latest version is installed."
  type        = string
  default     = "v1.2.2"
}

variable "crossplane_values_path" {
  description = "crossplane helm chart values.yaml path."
  type        = string
  default     = ""
}

variable "crossplane_provider" {
  description = "The list of Provider packages to install together with Crossplane."
  type        = string
  default     = "{crossplane/provider-gcp:v0.15.0,crossplane/provider-helm:v0.5.0}"
}

variable "crossplane_registry" {
  description = "registry for Crossplane packages"
  type        = string
  default     = "ghcr.io/projectkerberus/provider-gcp:v0.17.1"
}

#### Google Cloud Platform ####

variable "gcp_project" {
  description = "GCP project for crossplane resources"
}

variable "gcp_region" {
  description = "GCP resource region"
  default     = "europe-west3"
}

variable "gcp_zone" {
  description = "GCP resource zone"
  default     = "europe-west3-a"
}

variable "gcp_sa_key_path" {
  type        = string
  description = "GCP service account key"
}

variable "gcp_service_account_id" {
  description = "SA id to be created to be used by Crossplane GCP Provider"
  default     = "kerberus-crossplane"
}

variable "gcp_service_account_name" {
  description = "SA name to be created to be used by Crossplane GCP Provider"
  default     = "Kerberus Crossplane Service Account"
}

variable "gcp_services" {
  description = "API Services to activate"
  type        = set(string)
  default     = ["container.googleapis.com", "sqladmin.googleapis.com", "redis.googleapis.com", "compute.googleapis.com", "servicenetworking.googleapis.com"]
}

variable "gcp_roles" {
  description = "GCP Roles to assigne at the created service account"
  type        = set(string)
  default     = ["roles/iam.serviceAccountUser", "roles/cloudsql.admin", "roles/container.admin", "roles/redis.admin", "roles/compute.networkAdmin", "roles/storage.admin"]
}

#### ArgoCD ####
variable "argocd_namespace" {
  description = "The name of ArgoCD namespace for the Kerberus dashboard."
  type        = string
  default     = "argo-system"
}

variable "argocd_repository" {
  description = "Repository URL where to locate the ArgoCD chart"
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "argocd_chart" {
  description = "ArgoCD chart name to be installed."
  type        = string
  default     = "argo-cd"
}

variable "argocd_chart_version" {
  description = "Specify the exact ArgoCD chart version to install. If this is not specified, the latest version is installed."
  type        = string
  default     = "3.6.8"
}

variable "argocd_url" {
  description = "fqdn for ArgoCD gui"
  type        = string
}

variable "argocd_values_path" {
  description = "ArgoCD helm chart values.yaml path."
  type        = string
  default     = ""
}

variable "argocd_kerberus_service_account" {
  description = "The name of the ArgoCD service account for kerberus."
  type        = string
  default     = "kerberus-dashboard"
}

variable "argocd_rbacConfig_policy_default" {
  description = "Argo CD pre-defined roles, it can be role:readonly or role:admin. For more information see: https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/rbac.md"
  type        = string
  default     = "role:admin"
}

variable "argocd_server_extra_args" {
  description = "ArgoCD server extra args"
  type        = list(string)
  default     = ["--insecure"]
}

#### Kerberus Dashboard####

variable "kerberus_k8s_endpoint" {
  description = "kubernetes api endpoint."
  type        = string
}

variable "kerberus_dashboard_namespace" {
  description = "The name of kubernetes namespace for the Kerberus dashboard."
  type        = string
  default     = "kerberus-dashboard-system"
}

variable "kerberus_service_account" {
  description = "The name of the kerberus service account on Kubernetes"
  type        = string
  default     = "kerberus-admin"
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
  default     = "0.2.0"
}

variable "kerberus_dashboard_values_path" {
  description = "kerberus dashboard helm chart values.yaml path"
  type        = string
  default     = ""
}

#### Github ####

variable "github_client_id" {
  description = "Github OAuth Apps client id"
  type        = string
  default     = ""
}

variable "github_client_secrets" {
  description = "Github OAuth Apps client secrets"
  type        = string
  default     = ""
}

variable "github_token" {
  description = "Github personal access token, please see: https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token"
  type        = string
  default     = ""
}

#### Gitlab ####
variable "gitlab_token" {
  description = "GitLab personal access token, please see: https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#create-a-personal-access-token"
  type        = string
  default     = ""
}

variable "github_app_id" {
  description = "GitHub App ID"
  type        = string
  default     = ""
}

variable "github_app_client_id" {
  description = "GitHub App ClientID. GitHub Apps can use OAuth credentials to identify users."
  type        = string
  default     = ""
}

variable "github_app_client_secret" {
  description = "GitHub App Secret. GitHub Apps can use OAuth credentials to identify users."
  type        = string
  default     = ""
}

variable "github_app_webhook_url" {
  description = "GitHub App Webhook URL. Webhooks allow you to build or set up integrations, such as GitHub Apps or OAuth Apps, which subscribe to certain events on GitHub.com."
  type        = string
  default     = ""
}

variable "github_app_webhook_secret" {
  description = "GitHub App Webhook secret. Webhooks allow you to build or set up integrations, such as GitHub Apps or OAuth Apps, which subscribe to certain events on GitHub.com."
  type        = string
  default     = ""
}

variable "github_app_private_key" {
  description = "GitHub App Private key. You need a private key to sign access token requests."
  type        = string
  default     = ""
}
