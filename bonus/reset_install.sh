#!/bin/bash
set -e

NAMESPACE="gitlab"
CLUSTER="p3-cluster"
DOMAIN="gitlab.local"

echo "🧹 Cleaning up previous setup..."

# Delete k3d cluster if exists
# if k3d cluster list | grep -q "$CLUSTER"; then
#   echo "Deleting cluster $CLUSTER..."
#   k3d cluster delete "$CLUSTER"
# else
#   echo "Cluster $CLUSTER not found, skipping delete."
# fi

# # Remove /etc/hosts entry
# echo "Removing $DOMAIN from /etc/hosts..."
# sudo sed -i "/$DOMAIN/d" /etc/hosts || true

# Delete namespace if exists (requires cluster context)
if kubectl get namespace "$NAMESPACE" &>/dev/null; then
  echo "Deleting namespace $NAMESPACE..."
  kubectl delete namespace "$NAMESPACE" || true
else
  echo "Namespace $NAMESPACE does not exist."
fi

echo "✅ Cleanup complete."

