#!/bin/bash

function create_cluster() {
  if [[ $(kind get clusters) ]]; then echo "Stop kind" && exit 1; fi
  kind create cluster --config kind-config/kind_config.yaml  && sleep 20
}

function deploy_ingress_controller() {
  kubectl apply -f "kind-config/ingress.yaml"
  kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=90s
}

function deploy_gitlab() {
    helm upgrade -i "gitlab" --namespace gitlab \
    --create-namespace ./gitlab
}

function main() {
    create_cluster
    deploy_ingress_controller
    deploy_gitlab
}

main