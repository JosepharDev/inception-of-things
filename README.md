# inception-of-things



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

#k3d cluster delete `<cluster-name>`

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

# create cluster it create agent and server

# k3d cluster create iot-cluster --agents 1 --port "8888:80@loadbalancer"

#k3d cluster create iot-cluster --agents 1 \

# --port "8888:8888@loadbalancer" \  # App

# --port "8080:443@loadbalancer"     # Argo CD


#sudo helm status gitlab -n gitlab
