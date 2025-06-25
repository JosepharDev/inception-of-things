#!/bin/bash


#install kubectl
#   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#chmod +x kubectl
#sudo mv kubectl /usr/local/bin/

# install k3d
# curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# create cluster it create agent and server
# k3d cluster create iot-cluster --agents 1 --port "8888:80@loadbalancer"
#k3d cluster create iot-cluster --agents 1 \
#  --port "8888:8888@loadbalancer" \  # App
#  --port "8080:443@loadbalancer"     # Argo CD
sudo k3d cluster create p3-cluster
echo "✅ Checking K3d cluster status..."
sudo k3d cluster list


#check => sudo kubectl get nodes
echo "✅ Checking Kubernetes nodes..." #Check if the cluster is up and running
sudo kubectl get nodes -o wide

# install argo cd in k3d cluster 
sudo kubectl create namespace argocd && sudo kubectl create namespace dev
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#List all namespaces
echo "✅ Verifying namespaces..."
sudo kubectl get namespaces | grep -E 'argocd|dev'

# Check Argo CD deployments and pods
echo "✅ Verifying Argo CD deployment..."
sleep 5
sudo kubectl get all -n argocd

#waitpods
echo "⏳ Waiting for Argo CD pods to be ready (timeout: 10 minutes)..."
sudo kubectl wait --for=condition=ready --timeout=600s pod --all -n argocd

# Check if the secret exists
echo "✅ Verifying 'argocd-initial-admin-secret' exists..."
sudo kubectl get secret argocd-initial-admin-secret -n argocd


echo "✅ Final pod status in 'argocd' namespace:"
sudo kubectl get pods -n argocd


# passowrd argocd UI
echo -n "${GREEN}ARGOCD PASSWORD : "
  sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo "${RESET}"

#port forwarding 
sudo kubectl port-forward svc/argocd-server -n argocd 8085:443 > /dev/null 2>&1 &

# Check if port is listening
sleep 3
echo "✅ Checking if port-forward was successful..."
sudo lsof -i :8085 | grep LISTEN && echo "✅ Ready! Open https://localhost:8085"


# forward 8080:443 expose argo cd
#sudo kubectl port-forward svc/argocd-server -n argocd 8080:443

# get password for agro server localhost:8000
#sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d


# install argocd CLI
#curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
#sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
#rm argocd-linux-amd64



#### install docker
# sudo apt update
# sudo apt install apt-transport-https ca-certificates curl software-properties-common
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
# sudo apt install docker-ce


# create cluster name argocluster with 2 agents
#sudo k3d cluster create argocluster --agents 2


#create k3d cluster
# k3d cluster create iot-cluster --agents 1 --port "8888:80@loadbalancer"
##confirm => kubectl get nodes

# create dev namespace 
#kubectl create ns dev


# create argo app yaml and apply it
# sudo kubectl apply -f app_argo.yaml




#list clusters
#k3d cluster list

#delete cluster
#k3d cluster delete <cluster-name>


#K3d Cluster is Running
#k3d cluster list
#kubectl get nodes


#Argo CD is Running in Namespace argocd
#kubctl get pods -n argocd

#Argo CD UI Accessible
#kubectl port-forward svc/argocd-server -n argocd 8080:443


#Argo CD Application Synced with GitHub Repo
#kubectl get applications.argoproj.io -n argocd


#Application is Running in Namespace dev
#kubectl get ns
#kubectl get pods -n dev


#Change Version (v1 → v2) and Git Push
#sed -i 's/playground:v1/playground:v2/' deployment.yaml
#git commit -am "Update to v2"
#git push


#Check Events for the Namespace
#kubectl get events -n argocd --sort-by=.metadata.creationTimestamp

#Check Pod Details
#kubectl describe pod argocd-server-67b6bf4f8d-hjmwg -n argocd


#Verify Network Plugins (CNI)
#kubectl get pods -n kube-system
