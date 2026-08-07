#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HELM_DIR="$ROOT_DIR/helm"

source "$ROOT_DIR/centalisingValues.sh"

echo "$CLUSTER_NAME"
echo "$REGION"
echo "$VPC_ID"

echo $ROOT_DIR
echo $HELM_DIR

cd $HELM_DIR/networking

helm upgrade --install ingress . --namespace kube-system --create-namespace --wait --set aws-load-balancer-controller.clusterName="$CLUSTER_NAME" \
    --set aws-load-balancer-controller.region="$REGION" \
    --set aws-load-balancer-controller.vpcId="$VPC_ID"
sleep 60s

cd $HELM_DIR/autoscaling
helm upgrade --install autoscaling . \
    --namespace kube-system --wait \
    --create-namespace \
    --set cluster-autoscaler.autoDiscovery.clusterName="$CLUSTER_NAME" \
    --set cluster-autoscaler.awsRegion="$REGION"
sleep 60s

cd $HELM_DIR/monitoring
helm upgrade --install monitoring . \
    --namespace monitoring \
    --create-namespace --wait
sleep 60s

cd $HELM_DIR/service-mesh
helm upgrade --install istio-base charts/base-*.tgz  -n istio-system --create-namespace --wait -f base-values.yaml
helm upgrade --install istiod charts/istiod-*.tgz -n istio-system --wait -f istiod-values.yaml
helm upgrade --install istio-ingress charts/gateway-*.tgz -n istio-system --create-namespace --wait -f gateway-values.yaml
helm upgrade --install monitoring-ingress charts/gateway-*.tgz -n istio-system --wait -f monitoring-gateway-values.yaml
sleep 60s

cd $HELM_DIR/agroCD
helm upgrade --install argo charts/agro-*.tgz -n argocd --create-namespace --wait -f values.yaml
