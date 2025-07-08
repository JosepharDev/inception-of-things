#!/bin/bash

sudo kubectl create namespace gitlab
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

sudo helm repo add gitlab https://charts.gitlab.io/
sudo helm repo update



sudo helm install gitlab gitlab/gitlab -f gitlab-values.yaml -n gitlab --wait=false
