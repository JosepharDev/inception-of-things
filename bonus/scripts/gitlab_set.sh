#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

echo -e "${YELLOW}🔐 Retrieving GitLab root password...${RESET}"
GITLAB_PASS=$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)

echo -e "${YELLOW}📝 Creating .netrc for GitLab authentication...${RESET}"
cat <<EOF | sudo tee /root/.netrc > /dev/null
machine gitlab.k3d.gitlab.com
login root
password ${GITLAB_PASS}
EOF
sudo chmod 600 /root/.netrc

if [ -d "git_repo" ]; then
  echo -e "${YELLOW}🧹 Removing existing git_repo directory...${RESET}"
  sudo rm -rf git_repo
fi

echo -e "${YELLOW}📥 Cloning GitLab repo...${RESET}"
sudo git clone http://gitlab.k3d.gitlab.com/root/testrepo.git git_repo

echo -e "${YELLOW}📥 Cloning GitHub repo for source deployment files...${RESET}"
sudo git clone https://github.com/JosepharDev/iot-test.git iot_test

echo -e "${YELLOW}📂 Copying deployment.yaml to GitLab repo...${RESET}"
sudo mv iot_test/deployment.yaml git_repo/

echo -e "${YELLOW}🧹 Removing temporary GitHub repo...${RESET}"
sudo rm -rf iot_test/

cd git_repo
echo -e "${YELLOW}📦 Committing and pushing to GitLab...${RESET}"
sudo git add *
sudo git commit -m "update"
sudo git push
cd ..

echo -e "${YELLOW}🚀 Applying deployment to Kubernetes in namespace 'dev'...${RESET}"
sudo kubectl apply -n dev -f ../confs/deploy.yml
sleep 10
echo -e "${GREEN}✅ All done!${RESET}"
echo -e "${YELLOW}   sudo kubectl port-forward svc/svc-wil -n dev 8889:8080${RESET}"
