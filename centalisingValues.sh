#!/bin/bash
#!/bin/bash

set -e

# Always run from the directory where this script exists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

export CLUSTER_NAME=$(terraform output -raw cluster_name)
export REGION=$(terraform output -raw region)
export VPC_ID=$(terraform output -raw vpc_id)

aws eks update-kubeconfig \
    --region "$REGION" \
    --name "$CLUSTER_NAME"

echo "Cluster : $CLUSTER_NAME"
echo "Region  : $REGION"
echo "VPC     : $VPC_ID"