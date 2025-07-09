#!/bin/bash

#!/bin/bash

CLUSTER="bonus-cluster"
DEV_NAMESPACE="dev"
GLB_NAMESPACE="gitlab"
AGCD_NAMESPACE="argocd"

echo "🧹 Cleaning up previous setup..."

for NAMESPACE in "$DEV_NAMESPACE" "$GLB_NAMESPACE" "$AGCD_NAMESPACE"; do
  if kubectl get namespace "$NAMESPACE" &>/dev/null; then
    echo "🔻 Deleting namespace $NAMESPACE..."
    kubectl delete namespace "$NAMESPACE" || true
  else
    echo "⚠️ Namespace $NAMESPACE does not exist."
  fi
done


if k3d cluster list | grep -q "$CLUSTER"; then
  echo "🧨 Deleting K3d cluster '$CLUSTER'..."
  k3d cluster delete "$CLUSTER"
else
  echo "⚠️ K3d cluster '$CLUSTER' does not exist."
fi


HOST_ENTRY="127.0.0.1 gitlab.k3d.gitlab.com"
HOSTS_FILE="/etc/hosts"
if grep -q "$HOST_ENTRY" "$HOSTS_FILE"; then
  echo "🗑 Removing GitLab host entry from $HOSTS_FILE..."
  sudo sed -i "\|$HOST_ENTRY|d" "$HOSTS_FILE"
else
  echo "⚠️ Host entry not found in $HOSTS_FILE."
fi

echo "✅ Cleanup complete."
