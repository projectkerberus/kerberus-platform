
output "argocd_endpoint" {
  description = "Argo LINK"
  value       = "https://${var.ARGOCD_HOSTNAME}"
}

output "argocd_password" {
  description = "Argo password"
  value       = data.kubernetes_secret.retreive_argocd_password.data["password"]
}

output "argocd_token" {
  description = "To remove only for debug"
  value       = lookup(data.external.generate_argocd_token.result, "argo_token")
}