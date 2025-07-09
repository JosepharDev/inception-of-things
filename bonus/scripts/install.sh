#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

HOST_ENTRY="127.0.0.1 gitlab.k3d.gitlab.com"
HOSTS_FILE="/etc/hosts"
CLUSTER="bonus-cluster"
DEV_NAMESPACE="dev"
GLB_NAMESPACE="gitlab"
AGCD_NAMESPACE="argocd"

echo -e "${YELLOW}🛠 Installing Git...${RESET}"
sudo apt install -y git


echo -e "${YELLOW}🚀 Creating K3d cluster '$CLUSTER' with ports exposed...${RESET}"
sudo k3d cluster create "$CLUSTER"

echo -e "${YELLOW}📦 Creating namespaces: $DEV_NAMESPACE, $GLB_NAMESPACE, $AGCD_NAMESPACE...${RESET}"
sudo kubectl create namespace $GLB_NAMESPACE
sudo kubectl create namespace $AGCD_NAMESPACE
sudo kubectl create namespace $DEV_NAMESPACE

echo -e "${YELLOW}📥 Installing Argo CD...${RESET}"
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo -e "${YELLOW}📥 Installing Helm...${RESET}"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

if grep -q "$HOST_ENTRY" "$HOSTS_FILE"; then
    echo -e "${GREEN}✔ Host entry already exists in $HOSTS_FILE${RESET}"
else
    echo -e "${YELLOW}➕ Adding GitLab domain to $HOSTS_FILE...${RESET}"
    echo "$HOST_ENTRY" | sudo tee -a "$HOSTS_FILE"
fi

echo -e "${YELLOW}📦 Adding GitLab Helm repo and updating...${RESET}"
sudo helm repo add gitlab https://charts.gitlab.io/
sudo helm repo update 

echo -e "${YELLOW}🐙 Installing GitLab in namespace $GLB_NAMESPACE... (this may take a while)${RESET}"
sudo helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  --set global.hosts.domain=k3d.gitlab.com \
  --set global.hosts.externalIP=0.0.0.0 \
  --set global.hosts.https=false \
  --timeout 600s

echo -e "${YELLOW}⏳ Waiting for GitLab pods to be ready (timeout: 20 minutes)...${RESET}"
sudo kubectl wait --for=condition=ready --timeout=1200s pod -l app=webservice -n gitlab

echo -e "${GREEN}🔐 GitLab Root Password:${RESET}"
echo -n "${GREEN}GITLAB PASSWORD: "
sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode
echo "${RESET}"

echo -e "${YELLOW}⏳ Waiting for Argo CD pods to be ready (timeout: 10 minutes)...${RESET}"
sudo kubectl wait --for=condition=ready --timeout=600s pod --all -n argocd

echo -e "${GREEN}🔐 Argo CD Admin Password:${RESET}"
echo -n "${GREEN}ARGOCD PASSWORD: "
sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo "${RESET}"

echo -e "${YELLOW}🔁 Port-forwarding GitLab (80) and Argo CD (8085)...${RESET}"
sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 80:8181 >/dev/null 2>&1 &
sudo kubectl port-forward svc/argocd-server -n argocd 8085:443 >/dev/null 2>&1 &

echo -e "${GREEN}✅ Setup complete!${RESET}"
echo -e "${GREEN}➡ Access GitLab at: http://localhost${RESET}"
echo -e "${GREEN}➡ Access Argo CD at: https://localhost:8085${RESET}"

exec scripts/gitlab_set.sh

#sudo helm status gitlab -n gitlab

# sudo kubectl exec -it -n gitlab gitlab-toolbox-6594f5cdc5-qbd9q -- bash


