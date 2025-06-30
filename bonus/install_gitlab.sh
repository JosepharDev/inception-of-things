#!/bin/bash
set -e

NAMESPACE="gitlab"
RELEASE="gitlab"
CLUSTER="p3-cluster"
VALUES_FILE="gitlab-values.yaml"
DOMAIN="gitlab.local"
HELM_VERSION="v3.14.0"

GREEN='\033[0;32m'
RESET='\033[0m'

# echo "🚀 Creating k3d cluster $CLUSTER with ports exposed..."
# k3d cluster create "$CLUSTER"

# Install Helm if missing
if ! command -v helm &>/dev/null; then
  echo -e "${GREEN}🔧 Installing Helm $HELM_VERSION...${RESET}"
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod +x get_helm.sh
  ./get_helm.sh --version "$HELM_VERSION"
  rm get_helm.sh
else
  echo -e "${GREEN}✅ Helm installed: $(helm version --short)${RESET}"
fi

kubectl create namespace "$NAMESPACE" || true

helm repo add gitlab https://charts.gitlab.io || true
helm repo update

echo -e "${GREEN}📦 Installing or upgrading GitLab...${RESET}"

# helm upgrade --install "$RELEASE" gitlab/gitlab \
#   -n "$NAMESPACE" \
#   -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
#   --wait \
#   --timeout 30m

helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  -f gitlab-values.yaml \
  --timeout 900s

  #https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  # --set global.hosts.domain=localhost \
  # --set global.hosts.externalIP=10.0.2.15 \
  # --set global.hosts.https=false \

# Optional: Add domain to /etc/hosts
# echo "📝 Adding $DOMAIN to /etc/hosts"
# echo "127.0.0.1 $DOMAIN" | sudo tee -a /etc/hosts

echo -e "${GREEN}⏳ Waiting for GitLab pods to be ready...${RESET}"
kubectl wait --for=condition=Available=True deployment -n "$NAMESPACE" --timeout=600s --all || true

echo -e "${GREEN}✅ GitLab installed.${RESET}"
kubectl get pods -n "$NAMESPACE"
kubectl get svc -n "$NAMESPACE"
kubectl get ingress -n "$NAMESPACE" || echo "⚠️ No ingress found."

sleep 10
echo -e "${GREEN}🔑 GitLab root password:${RESET}"
kubectl get secret gitlab-gitlab-initial-root-password -n "$NAMESPACE" -o jsonpath="{.data.password}" | base64 -d && echo

sleep 10
echo
echo -e "${GREEN}ℹ️ To access GitLab via localhost:8080, run:${RESET}"
echo "kubectl -n $NAMESPACE port-forward svc/gitlab-webservice-default 8080:8181"



#helm uninstall gitlab -n gitlab
#sudo kubectl describe pod gitlab-webservice-default-ff7ff9988-s9vf9 -n gitlab
#kubectl logs gitlab-webservice-default-ff7ff9988-s9vf9 -n gitlab --all-containers --tail=50
#kubectl get pvc -n gitlab
#sudo kubectl describe node k3d-p3-cluster-server-0
#kubectl delete pods -n gitlab --all
#watch kubectl get pods -n gitlab
#kubectl describe node k3d-p3-cluster-server-0 | grep Taints
#kubectl describe pvc data-gitlab-postgresql-0 -n gitlab


#List PersistentVolumes (PVs) in the cluster:
#sudo kubectl get pv

#List all PVCs in the GitLab namespace:
#sudo kubectl get pvc -n gitlab

#Delete all PVCs in GitLab namespace:
# sudo kubectl delete pvc --all -n gitlab
