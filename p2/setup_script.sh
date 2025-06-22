#!/bin/bash

apt-get update -y
apt-get install -y curl

export INSTALL_K3S_EXEC="--disable=traefik --write-kubeconfig-mode=644 --flannel-iface eth1"
curl -sfL https://get.k3s.io | sh -

while [ ! -f /etc/rancher/k3s/k3s.yaml ]; do sleep 2; done

sudo cp /etc/rancher/k3s/k3s.yaml /vagrant/config
sudo chown $(id -u):$(id -g) /vagrant/config

# Install NGINX Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.5/deploy/static/provider/cloud/deploy.yaml

# Wait for ingress controller pod to be ready
echo "Waiting for NGINX Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s

kubectl apply -f /vagrant/app1.yaml
kubectl apply -f /vagrant/app2.yaml
kubectl apply -f /vagrant/app3.yaml
kubectl apply -f /vagrant/ingress.yaml
