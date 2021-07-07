locals {
  crossplane_providers = merge({}, { "gcp-provider" : module.configure_crossplane.provider })
  crossplane_secrets   = merge({}, { "gcp-creds" : module.configure_crossplane.secret })
}

module "configure_crossplane" {
  source  = "projectkerberus/crossplane/kerberus//modules/gcp-crossplane"
  version = "0.2.0"

  gcp_service_account_id   = var.gcp_service_account_id
  gcp_service_account_name = var.gcp_service_account_name
  gcp_services             = var.gcp_services
  gcp_roles                = var.gcp_roles

  crossplane_registry = var.crossplane_registry
}

module "crossplane" {
  source  = "projectkerberus/crossplane/kerberus"
  version = "0.2.0"

  depends_on = [
    module.configure_crossplane
  ]

  crossplane_namespace     = var.crossplane_namespace
  crossplane_repository    = var.crossplane_repository
  crossplane_chart         = var.crossplane_chart
  crossplane_chart_version = var.crossplane_chart_version
  crossplane_values_path   = var.crossplane_values_path
  crossplane_providers     = local.crossplane_providers
  crossplane_secrets       = local.crossplane_secrets

  path_kubeconfig = var.path_kubeconfig
}

module "argocd" {
  source  = "projectkerberus/argocd/kerberus"
  version = "0.2.2"

  argocd_namespace                 = var.argocd_namespace
  argocd_repository                = var.argocd_repository
  argocd_chart                     = var.argocd_chart
  argocd_chart_version             = var.argocd_chart_version
  argocd_url                       = var.argocd_url
  argocd_values_path               = var.argocd_values_path
  argocd_kerberus_service_account  = var.argocd_kerberus_service_account
  argocd_rbacConfig_policy_default = var.argocd_rbacConfig_policy_default
  argocd_server_extra_args         = var.argocd_server_extra_args


  path_kubeconfig = var.path_kubeconfig
}

module "kerberus_dashboard" {
  source  = "projectkerberus/dashboard/kerberus"
  version = "0.2.1"

  kerberus_k8s_endpoint            = var.kerberus_k8s_endpoint
  kerberus_dashboard_namespace     = var.kerberus_dashboard_namespace
  kerberus_service_account         = var.kerberus_service_account
  kerberus_dashboard_repository    = var.kerberus_dashboard_repository
  kerberus_dashboard_chart         = var.kerberus_dashboard_chart
  kerberus_dashboard_chart_version = var.kerberus_dashboard_chart_version
  kerberus_dashboard_values_path   = var.kerberus_dashboard_values_path

  argocd_token = module.argocd.argocd_token
  argocd_url   = var.argocd_url

  github_client_id      = var.github_client_id
  github_client_secrets = var.github_client_secrets
  github_token          = var.github_token

  gitlab_token = var.gitlab_token

  github_app_id             = var.github_app_id
  github_app_webhook_url    = var.github_app_webhook_url
  github_app_client_id      = var.github_app_client_id
  github_app_client_secret  = var.github_app_client_secret
  github_app_webhook_secret = var.github_app_webhook_secret
  github_app_private_key    = var.github_app_private_key
}
