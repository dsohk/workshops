#! /bin/bash

export PATH=$PATH:/var/lib/rancher/rke2/bin
export CTR_OPTS="-a /run/k3s/containerd/containerd.sock"
export SRC_IMAGE=${SRC_IMAGE}
export DEST_IMAGE=${DEST_IMAGE}
export SRC_REGISTRY=docker.io
export DEST_REGISTRY=${HARBOR_HOST}
export DEST_REGISTRY_CRED="${HARBOR_USR}:${HARBOR_PWD}"

ctr $CTR_OPTS image pull --platform linux/amd64 $SRC_REGISTRY/$SRC_IMAGE
ctr $CTR_OPTS image tag $SRC_REGISTRY/$SRC_IMAGE $DEST_REGISTRY/$DEST_IMAGE
ctr $CTR_OPTS image push --platform linux/amd64 -k -u $DEST_REGISTRY_CRED $DEST_REGISTRY/$DEST_IMAGE