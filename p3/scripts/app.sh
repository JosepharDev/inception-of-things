#!/bin/bash

GREEN='\033[0;32m'
RESET='\033[0m'

# Apply ArgoCD app configuration
sudo kubectl apply -f ../argo_app.yaml

# Wait until the service is ready
echo -e "${GREEN}Waiting for svc-wil service to be available...${RESET}"
while ! sudo kubectl get svc svc-wil -n dev >/dev/null 2>&1; do
  sleep 2
done

sleep 20
echo -e "${GREEN}PORT-FORWARD : sudo kubectl port-forward svc/svc-wil -n dev 8888:8080${RESET}"
sudo kubectl port-forward svc/svc-wil -n dev 8888:8080 > /dev/null 2>&1 &
