FROM hashicorp/terraform:0.14.8

ENV KUBE_LATEST_VERSION="v1.20.4"

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && export ARCH="$(uname -m)" && if [[ ${ARCH} == "x86_64" ]]; then export ARCH="amd64"; fi && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/${ARCH}/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*

RUN kubectl version --client

FROM google/cloud-sdk:alpine

ADD ./kerberusdemo-21c9a3ffdcfd.json /tmp/kerberusdemo-21c9a3ffdcfd.json

RUN pwd

RUN gcloud config configurations create kerberus-gcp-config
RUN gcloud auth activate-service-account --key-file /tmp/kerberusdemo-21c9a3ffdcfd.json
RUN gcloud projects list 
