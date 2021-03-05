# Installer

## Description

The installer is composed of a Terraform recipe which install and configure the following component on a Kubernetes cluster:

- [Crossplane](https://github.com/crossplane/crossplane), the [GCP](https://github.com/crossplane/provider-gcp) and [helm](https://github.com/crossplane-contrib/provider-helm) provider;
- installation of a Crossplane package for [GCP platform reference](https://github.com/idallaserra/platform-ref-gcp) defining the api and XRD for Networking, GKE and CloudSQL resources;
- GCP service account with required permission for creating the resources;
- [Argo CD](https://argoproj.github.io/projects/argo-cd) for GitOps resources management with relative Ingress Controller.

List of files:

```console
├── CODE_OF_CONDUCT.md      Code of Conduct FIle
├── CONTRIBUTING.md         Contributing File
├── LICENSE                 License File
├── main.tf                 MAIN Terraform recipe
├── output.tf               Terraform Output
├── README.md               This File 
├── values.yaml             Argo CD helm chart values
└── variables.tf            Terraform variable settings
```


## Requirements

### Kerberus Platform

In order to correctly install the platform there are some requirements:

1. [Terraform OSS](https://www.terraform.io/downloads.html) (tested with version v0.14.4)

2. a Kubernetes cluster with local `KUBECONFIG` and [kubectl CLI](https://kubernetes.io/docs/reference/kubectl/) with [application default](https://cloud.google.com/sdk/gcloud/reference/auth/application-default/login) configured.

    The cluster must run:

- an ingress controller for example [Contour](https://projectcontour.io/);
- [cert-manager](https://cert-manager.io/docs/) component installed and configured to serve a FQDN registered domain;\
- [prometheus-operator](https://github.com/prometheus-operator/prometheus-operator) (optional);

3. [Crossplane CLI](https://crossplane.io/docs/v1.0/getting-started/install-configure.html#install-crossplane-cli) locally installed;

### Created Resources

The resources created are on GCP platform, so locally configured [gcloud CLI](https://cloud.google.com/sdk/gcloud) and a project previously created on it is required.

Since the Installer takes care of creating the necessary service account on the platform GCP, owner permission on the project is a must.

## Installation

Fir step clone the repo 
`git clone <repourl>`

Create a file named `terraform.tvars` containing at minimum the following variables:

```bash
# GCP vars
GCP_PROJECT = <GCP project ID>
PATH_KUBECONFIG = <PATH to lcoal KUBECONFIG file>
CROSSPLANE_REGISTRY = "ghcr.io/projectkerberus/platform-ref-gcp:latest"

# Argo vars
ARGOCD_HOSTNAME = <FQDN name of ARGO>
```

Change the values `argocdServerAdminPassword` in file `values.yaml`.

Initialize Terraform working directory:

```bash
terraform init
```

Review and check the execution plan:

```bash
terraform plan
```

Apply the plan:

```bash
terraform apply
```

If everything goes well pointing your browser to <https://ARGOCD_HOSTNAME> you should see the Argo CD web UI.

## Uninstall

```bash
terraform destroy
```

Be careful, like explained in the [Crossplane documentation](https://crossplane.io/docs/v1.0/getting-started/install-configure.html#install-crossplane-cli) CRD resources are not removed using helm, so additional command is required:

```bash
kubectl patch lock lock -p '{"metadata":{"finalizers": []}}' --type=merge
kubectl get crd -o name | grep crossplane.io | xargs kubectl delete
```
## Support

TBD
## Roadmap

TBD
## Contributing

Please refer to Contributing file in repository.

## License

Please refer to LICENSE file in repository.
  