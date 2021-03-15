terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.9.4"
    }
  }
}

provider "kubernetes" {
  config_path = var.PATH_KUBECONFIG
}

provider "kubectl" {
  load_config_file       = true
  apply_retry_count = 15
}

provider "helm" {
  kubernetes {
    config_path = var.PATH_KUBECONFIG
  }
}

provider "google" {
  project     = var.GCP_PROJECT
  region  = var.GCP_REGION
  zone    = var.GCP_ZONE
}

resource "kubernetes_namespace" "crossplane_namespace" {
  metadata {
    name = var.CROSSPLANE_NAMESPACE
  }
}

# Installation of Crossplane and Providers
resource "helm_release" "crossplane" {
  depends_on = [ kubernetes_namespace.crossplane_namespace ]
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

}
data "google_project" "my_project" {
}

resource "google_project_service" "project_service" {
  project = var.GCP_PROJECT
  count = length(var.GCP_SERVICES)
  service =  var.GCP_SERVICES[count.index]
  disable_dependent_services = "true"   
}

resource "google_project_iam_binding" "iam_project" {
  project = var.GCP_PROJECT
  count = length(var.GCP_ROLES)
  role    = var.GCP_ROLES[count.index]
  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}
resource "google_service_account" "service_account" {
  account_id   = var.GCP_SA
  display_name = "Crossplane Service Account"
  project = var.GCP_PROJECT
}
resource "google_service_account_key" "crossplan_key" {
  service_account_id = google_service_account.service_account.name
}

resource "kubernetes_secret" "gcp-credential" {
  metadata {
    name = "gcp-creds"
    namespace = var.CROSSPLANE_NAMESPACE
  }
  data = {
    "credentials" = base64decode(google_service_account_key.crossplan_key.private_key)
  }
}

# Configuratrion of Crossplane Resources

resource "kubectl_manifest" "providerconfig" {
    depends_on = [ helm_release.crossplane,kubernetes_secret.gcp-credential ]
    yaml_body = <<YAML
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
  depends_on = [ kubectl_manifest.providerconfig ]
  provisioner "local-exec" {
    command = "kubectl crossplane install configuration '${var.CROSSPLANE_REGISTRY}'"
  }
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
  depends_on = [ kubernetes_namespace.argo_namespace ]
  name       = "argocd"
  namespace  = var.ARGOCD_NAMESPACE
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  values = [
    "${file("values.yaml")}"
  ]
}
