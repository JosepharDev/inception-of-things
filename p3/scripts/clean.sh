#!/bin/bash


echo "🧹 Cleaning up Argo CD and K3d environment..."

echo "🔌 Stopping port-forwarding..."
sudo pkill -f "kubectl port-forward svc/argocd-server" && echo "✅ Port-forwarding stopped." || echo "ℹ️ No port-forwarding process found."

echo "📦 Deleting namespaces 'argocd' and 'dev'..."
sudo kubectl delete namespace argocd 
sudo kubectl delete namespace dev 

echo "⚠️ Deleting K3d cluster 'p3-cluster'..."
sudo k3d cluster delete p3-cluster

sudo docker system prune -af
echo "✅ Verifying cleanup..."
sudo kubectl get namespaces
sudo k3d cluster list
