#!/bin/bash

# echo "✅ Installing Kubectl ...."
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# chmod +x kubectl
# sudo mv kubectl /usr/local/bin/

echo "✅ Installing K3D ....."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash


sudo k3d cluster create p3-cluster
echo "✅ Checking K3d cluster status..."
sudo k3d cluster list


echo "✅ Checking Kubernetes nodes..." 
sudo kubectl get nodes -o wide


echo "✅ Creating ArgoCD & Dev Namespaces ...."
sudo kubectl create namespace argocd && sudo kubectl create namespace dev


echo "✅ Installing ARGOCD ......"
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


echo "✅ Verifying namespaces..."
sudo kubectl get namespaces | grep -E 'argocd|dev'


echo "✅ Verifying Argo CD deployment..."
sleep 5
sudo kubectl get all -n argocd


echo "⏳ Waiting for Argo CD pods to be ready (timeout: 10 minutes)..."
sudo kubectl wait --for=condition=ready --timeout=600s pod --all -n argocd


echo "✅ Verifying 'argocd-initial-admin-secret' exists..."
sudo kubectl get secret argocd-initial-admin-secret -n argocd


echo "✅ Final pod status in 'argocd' namespace:"
sudo kubectl get pods -n argocd


echo -n "${GREEN}ARGOCD PASSWORD : "
  sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo "${RESET}"

sudo kubectl port-forward svc/argocd-server -n argocd 8085:443 > /dev/null 2>&1 &
exec scripts/app.sh
