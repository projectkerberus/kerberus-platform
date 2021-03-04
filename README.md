# Kerberus
Kerberus is an open source tool, based CNCF projects such as Kubernetes and Crossplane, that gives users the capability to create any desired resource on basically any infrastructure they'd like. Be it a K8s cluster, microservice, application, pipeline, database or anything else, Kerberus has got your back. The only requirement is for the resource to be descriptible via a YAML file representing the resource's *desired state* (rings a bell? 😉).

Kerberus allows for:
- **Creating any kind of resources within and outside the Kubernetes cluster it runs on**: whilst Kerberus runs as a Deployment in a Kubernetes cluster, it can also create resources *outside* the cluster. You can use Kerberus to create anything from new Kubernetes clusters, Logstash pipelines, Docker registries, API gateways, and many others.
- **Focusing on the management of services**: thanks to [Crossplane](https://crossplane.io) and to [Backstage](https://backstage.io/), Kerberus frees the user from most of the burden of cluster management, giving them the ability to entirely focus on the services that must be run. While the infrastructure is managed by Crossplane, the resources to be deployed can be easily found and configured in Backstage's UI, which acts as a catalog of ready-to-use services. This results a phenomenal user experience that drastically reduces wastes of time.  
- **Single-handedly monitoring and controlling resources**: Kerberus also acts as a centralized controlplane, letting users monitor anything ranging from CI/CD pipelines to pod statuses and open tickets on your JIRA. All the information you need is present on a single page -- you'll never have to guess the correct dashboard ever again.


## Our mission
With Kerberus, we aim at putting together many awesome tools from the CNCF landscape to provide our users with a simple-to-use, complete and modular platform that allows for creating resources on any infrastructure. We see Kerberus as a powerful tool that improves the workflow of teams by defining clear roles in which the infrastructure team creates the resource templates needed by the developers, and the developers are the final users that use those templates and can manage the lifecycle of the created resources from a simple, unified dashboard. 

In our vision, Kerberus is:
- a *self-service platform*, where users can autonomously choose what to create and where;
- a complete *controlplane* that eases and centralizes many processes, putting all the relevant information in a single page rather than distributing it on tens of different locations;
- a *multi-cloud provider* tool: it works with all the major cloud providers and with on-prem installations;
- either managed or easily installable on your existing Kubernetes cluster.


## Getting started
Getting started with Kerberus is as easy as following its [installation instructions](./INSTALL.md).

