#!/bin/bash

sudo kubectl apply -f argo_app.yaml

echo -e "${GREEN}PORT-FORWARD : sudo kubectl port-forward svc/svc-wil -n dev 8888:8080${RESET}"
sudo kubectl port-forward svc/svc-wil -n dev 8888:8080