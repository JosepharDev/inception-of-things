#!/bin/bash

# create user name and root for gitlab
GITLAB_PASS=$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)

cat <<EOF | sudo tee /root/.netrc > /dev/null
machine gitlab.k3d.gitlab.com
login root
password ${GITLAB_PASS}
EOF

sudo chmod 600 /root/.netrc


# clone repo
sudo git clone http://gitlab.k3d.gitlab.com/root/testrepo.git git_repo

# clone repo from github
sudo git clone https://github.com/JosepharDev/iot-test.git iot_test
# copy from git_buthor and git_repo
sudo mv iot_test/deployment.yaml git_repo/

# del repo from github
sudo rm -rf iot_test/

cd git_repo
sudo git add *
sudo git commit -m "update"
sudo git push
cd ..

sudo kubectl apply -n dev -f deploy.yml

# Warning port-forward
echo "${GREEN}PORT-FORWARD : sudo kubectl port-forward svc/svc-wil -n dev 8889:8080${RESET}"