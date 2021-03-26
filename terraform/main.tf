terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
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
      version = "3.62.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.3"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.10.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.PATH_KUBECONFIG
}

provider "kubectl" {
  load_config_file  = true
  apply_retry_count = 15
}

provider "helm" {
  kubernetes {
    config_path = var.PATH_KUBECONFIG
  }
}

provider "google" {
  project     = var.GCP_PROJECT
  region      = var.GCP_REGION
  zone        = var.GCP_ZONE
  credentials = file(var.CLIENT_ID_FILE)
}

resource "kubernetes_namespace" "crossplane_namespace" {
  metadata {
    name = var.CROSSPLANE_NAMESPACE
  }
}

# Installation of Crossplane and Providers
resource "helm_release" "crossplane" {
  depends_on = [kubernetes_namespace.crossplane_namespace]
  name       = "crossplane"
  namespace  = var.CROSSPLANE_NAMESPACE
  repository = "https://charts.crossplane.io/stable"
  chart      = "crossplane"

  set {
    name  = "image.pullPolicy"
    value = "IfNotPresent"
  }

  set {
    name  = "provider.packages"
    value = "{crossplane/provider-gcp:v0.15.0,crossplane/provider-helm:v0.5.0}"
  }

  # Fix while we wait for pull request: https://github.com/crossplane/crossplane/pull/2240/commits/f630b80dd82c4bbef6c74d3e26861598f4666c2e
  set {
    name  = "securityContextCrossplane.runAsUser"
    value = "65532"
  }

  set {
    name  = "securityContextCrossplane.runAsGroup"
    value = "65532"
  }

  set {
    name  = "securityContextRBACManager.runAsUser"
    value = "65532"
  }

  set {
    name  = "securityContextRBACManager.runAsGroup"
    value = "65532"
  }

}

data "google_project" "my_project" {
}

resource "google_project_service" "project_service" {
  project                    = var.GCP_PROJECT
  count                      = length(var.GCP_SERVICES)
  service                    = var.GCP_SERVICES[count.index]
  disable_dependent_services = "true"
}

resource "google_project_iam_binding" "iam_project" {
  project = var.GCP_PROJECT
  count   = length(var.GCP_ROLES)
  role    = var.GCP_ROLES[count.index]
  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

resource "google_service_account" "service_account" {
  account_id   = var.GCP_SA
  display_name = "Crossplane Service Account"
  project      = var.GCP_PROJECT
}

resource "google_service_account_key" "crossplan_key" {
  service_account_id = google_service_account.service_account.name
}

resource "kubernetes_secret" "gcp-credential" {
  metadata {
    name      = "gcp-creds"
    namespace = var.CROSSPLANE_NAMESPACE
  }
  data = {
    "credentials" = base64decode(google_service_account_key.crossplan_key.private_key)
  }
}

# Configuratrion of Crossplane Resources

resource "kubectl_manifest" "providerconfig" {
  depends_on = [helm_release.crossplane, kubernetes_secret.gcp-credential]
  yaml_body  = <<YAML
apiVersion: gcp.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  # replace this with your own gcp project id
  projectID: ${var.GCP_PROJECT}
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: gcp-creds
      key: credentials
YAML
}

resource "null_resource" "package_gcp" {
  depends_on = [kubectl_manifest.providerconfig]
  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${abspath(var.PATH_KUBECONFIG)} crossplane install configuration '${var.CROSSPLANE_REGISTRY}'"
  }
  # TODO: fix the destroy with the kubeconfig path
  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete --all configurations.pkg.crossplane.io"
  }
}

# Installation of ArgoCD
resource "kubernetes_namespace" "argo_namespace" {
  metadata {
    name = var.ARGOCD_NAMESPACE
  }
}

resource "helm_release" "argocd" {
  depends_on = [kubernetes_namespace.argo_namespace]
  name       = "argocd"
  namespace  = kubernetes_namespace.argo_namespace.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  values     = [file(join("/", [path.module, "files", "argocd", "values.yaml"]))]
}

resource "null_resource" "arcocg_wait" {
  depends_on = [helm_release.argocd]

  provisioner "local-exec" {
    command = "kubectl --kubeconfig=${abspath(var.PATH_KUBECONFIG)} rollout status deploy/argocd-server -n argo"
  }
}

data "kubernetes_secret" "retreive_argocd_password" {
  depends_on = [null_resource.arcocg_wait]

  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = helm_release.argocd.namespace
  }
}

data "external" "generate_argocd_token" {
  depends_on = [null_resource.arcocg_wait]

  program = ["/bin/bash", join("/", [path.module, "files", "argocd", "generate-token.sh"])]

  query = {
    argo_password = data.kubernetes_secret.retreive_argocd_password.data["password"]
    argo_hostname = var.ARGOCD_HOSTNAME
  }
}

# Installation of Kerberus Dashboard

resource "kubernetes_namespace" "kerberus_dashboard_namespace" {
  metadata {
    name = var.DASHBOARD_NAMESPACE
  }
}

resource "kubernetes_service_account" "create_kerberus_dashboard_service_account" {
  metadata {
    name      = "kerberus-admin"
    namespace = kubernetes_namespace.kerberus_dashboard_namespace.metadata[0].name
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "bind_kerberus_dashboard_service_account_to_admin_role" {
  metadata {
    name = kubernetes_service_account.create_kerberus_dashboard_service_account.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.create_kerberus_dashboard_service_account.metadata[0].name
    namespace = kubernetes_service_account.create_kerberus_dashboard_service_account.metadata[0].namespace
  }
}

data "kubernetes_secret" "retreive_kerberus_dashboard_service_account_token" {
  metadata {
    name      = kubernetes_service_account.create_kerberus_dashboard_service_account.default_secret_name
    namespace = kubernetes_service_account.create_kerberus_dashboard_service_account.metadata[0].namespace
  }
}

resource "helm_release" "kerberus_dashboard" {

  depends_on = [kubernetes_namespace.kerberus_dashboard_namespace]

  name       = "kerberus-dashboard"
  namespace  = kubernetes_namespace.kerberus_dashboard_namespace.metadata[0].name
  repository = "https://projectkerberus.github.io/kerberus-dashboard/"
  chart      = "kerberus-dashboard"
  values     = [file(join("/", [path.module, "files", "kerberus-dashboard", "values.yaml"]))]

  set {
    name  = "env.argo_token"
    value = lookup(data.external.generate_argocd_token.result, "argo_token")
  }

  set {
    name  = "env.github_client_id"
    value = var.GITHUB_CLIENT_ID
  }

  set {
    name  = "env.github_client_secret"
    value = var.GITHUB_CLIENT_SECRETS
  }

  set {
    name  = "env.github_token"
    value = var.GITHUB_TOKEN
  }

  set {
    name  = "env.k8s_cluster_token"
    value = data.kubernetes_secret.retreive_kerberus_dashboard_service_account_token.data["token"]
  }

}