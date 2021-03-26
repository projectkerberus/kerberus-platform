FROM hashicorp/terraform:0.14.8

FROM google/cloud-sdk:alpine

COPY --from=0 /bin/terraform /usr/local/bin/ 

ENV KUBE_LATEST_VERSION="v1.20.4"

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && export ARCH="$(uname -m)" && if [[ ${ARCH} == "x86_64" ]]; then export ARCH="amd64"; fi && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/${ARCH}/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*

RUN apk add --update --no-cache jq 

RUN curl -sL https://raw.githubusercontent.com/crossplane/crossplane/release-1.1/install.sh | sh

ENV CROSSPLANE_REGISTRY="ghcr.io/projectkerberus/platform-ref-gcp:latest"

RUN mkdir /kerberus-platform

COPY ./terraform /kerberus-platform/

WORKDIR /kerberus-platform

RUN terraform init

ENTRYPOINT ["terraform"]
