# Installer

## Description

The installer is composed of a Terraform recipe which installs and configure the following component on a Kubernetes cluster:

- [Crossplane](https://github.com/crossplane/crossplane), the [GCP](https://github.com/crossplane/provider-gcp) and [helm](https://github.com/crossplane-contrib/provider-helm) provider;
- installation of a Crossplane package for [GCP platform reference](https://github.com/idallaserra/platform-ref-gcp) defining the API and XRD for Networking, GKE, and CloudSQL resources;
- GCP service account with required permission for creating the resources;
- [Argo CD](https://argoproj.github.io/projects/argo-cd) for GitOps resources management with relative Ingress Controller.


## Requirements

### Kerberus Platform

To correctly install the platform there are some requirements:

1. [docker](https://www.docker.com/);
2. a Kubernetes cluster with default storage-class and the relative `kubeconfig` file;
3. a [gcp project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) and the [service account key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys);
4. GitHub client_id, client_secret, and token.

### Created Resources

The resources created are on GCP platform, so locally configured [gcloud CLI](https://cloud.google.com/sdk/gcloud) and a project previously created on it are required.

Since the Installer takes care of creating the necessary service account on the platform GCP, owner permission on the project is a must.

## Installation

1. Create a folder (in this tutorial we will refer to them with the name of `kerberus-platform`) to store our files and the `terraform.tfstate`:

```shell
mkdir data
```

2. Inside the `data` folder do the following:

   * Copy your  `kubeconfig` file;

   * Copy your [service account key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys);

   * create a file named `terraform.tfvars` containing at minimum the following variables:

```yaml
# K8S vars
PATH_KUBECONFIG       = "./data/<KUBECONFIG file name>"

# GCP vars
GCP_PROJECT           = "<GCP project ID>"
GCP_SA                = "<GCP service account name>"
CLIENT_ID_FILE        = "./data/<GCP service account key file name>"
CROSSPLANE_REGISTRY   = "ghcr.io/projectkerberus/platform-ref-gcp:latest"

# Argo vars
ARGOCD_HOSTNAME       = "<FQDN name of ARGO>"

# GitHub Vars
GITHUB_CLIENT_ID      = "<GitHub client ID>"
GITHUB_CLIENT_SECRETS = "<GitHub clinet secrets>"
GITHUB_TOKEN          = "<GitHub token>"
```

3. Review and check the execution plan:

```shell
docker run --name=kerberus-plan --rm -v <abs-path-to-data-folder>/data:/kerberus-platform/data ghcr.io/projectkerberus/kerberus-platform:0.1.0 plan -var-file=./data/terraform.tfvars
```

4. Apply the plan:

```bash
docker run --name=kerberus-plan --rm -v <abs-path-to-data-folder>/data:/kerberus-platform/data ghcr.io/projectkerberus/kerberus-platform:0.1.0 apply --auto-approve -var-file=./data/terraform.tfvars -state=./data/terraform.tfstate
```

If everything goes well pointing your browser to <https://ARGOCD_HOSTNAME> you should see the Argo CD web UI.

## Uninstall

```bash
docker run --name=kerberus-plan --rm -v <abs-path-to-data-folder>/data:/kerberus-platform/data ghcr.io/projectkerberus/kerberus-platform:0.1.0 destroy --auto-approve -var-file=./data/terraform.tfvars -state=./data/terraform.tfstate
```

Be careful, like explained in the [Crossplane documentation](https://crossplane.io/docs/v1.0/getting-started/install-configure.html#install-crossplane-cli) CRD resources are not removed using helm, so additional command is required:

```shell
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
