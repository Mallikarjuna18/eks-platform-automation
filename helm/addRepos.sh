#!/bin/bash

set -e

echo "Adding Helm repositories..."
helm repo add eks https://aws.github.io/eks-charts
helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add metric https://kubernetes-sigs.github.io/metrics-server/
echo "Updating repositories..."
helm repo update
