#!/bin/bash

GREEN='\033[0;32m'
RESET='\033[0m'

echo "✅ ${GREEB} Apply ArgoCD app configuration ...."
sudo kubectl apply -f confs/argo_app.yaml

echo "✅ ${GREEB} Cloning The Remote Repo ...."
git clone git@github.com:JosepharDev/yoyahya_iot.git

echo -e "${GREEN}Waiting for svc-wil service to be available...${RESET}"
while ! sudo kubectl get svc svc-wil -n dev >/dev/null 2>&1; do
  sleep 2
done

sleep 20
echo -e "${GREEN}PORT-FORWARD : sudo kubectl port-forward svc/svc-wil -n dev 8888:8080${RESET}"
sudo kubectl port-forward svc/svc-wil -n dev 8888:8080 > /dev/null 2>&1 &