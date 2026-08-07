#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HELM_DIR="$ROOT_DIR/helm"


echo "Building Networking dependencies..."
helm dependency build "$HELM_DIR/networking"

echo "Building Metricserver dependencies.."
helm dependency build "$HELM_DIR/metrics-server"

echo "Building Autoscaling dependencies..."
helm dependency build "$HELM_DIR/autoscaling"

echo "Building Monitoring dependencies..."
helm dependency build "$HELM_DIR/monitoring"

echo "Building Service Mesh dependencies..."
helm dependency build "$HELM_DIR/service-mesh"

echo "Building AgroCD dependencies..."
helm dependency build "$HELM_DIR/agroCD"
