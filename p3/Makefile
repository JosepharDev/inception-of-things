all:
	echo "-------- creating the cluster --------"
	sudo k3d cluster create iot-cluster --agents 1
	echo "---------- check ------------------"
	sudo kubectl get nodes
	echo "-------------- create namespaces -----------"
	sudo kubectl create namespace argocd
	sudo kubectl create namespace dev
	echo "------------ install argocd on namespace argocd"
	sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

dd:
	sudo docker rm -f $$(sudo docker ps -aq)
	sudo docker system prune -a
	sudo docker volume rm $$(sudo docker volume ls)