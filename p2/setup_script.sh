#!/bin/bash

apt-get update -y
apt-get install -y curl
#curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-iface eth1" | INSTALL_K3S_EXEC='--write-kubeconfig-mode=644' |  sh -
curl -sfL https://get.k3s.io | sh -


while [ ! -f /etc/rancher/k3s/k3s.yaml ]; do sleep 2; done

sudo cp /etc/rancher/k3s/k3s.yaml /vagrant/config
sudo chown $(id -u):$(id -g) /vagrant/config

kubectl apply -f /vagrant/app1.yaml
# kubectl apply -f /vagrant/app2.yaml
# kubectl apply -f /vagrant/app3.yaml