#!/bin/sh

echo -e "\033[1;33m---------------INSTALL K3D---------------\033[0m"
sudo dnf --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos -y
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | sh
sudo mv /usr/local/bin/k3d /usr/local/sbin/k3d

echo -e "\033[1;33m---------------INSTALL DOCKER---------------\033[0m"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo systemctl start docker

echo -e "\033[1;33m---------------INSTALL KUBECTL---------------\033[0m"
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv kubectl /usr/local/sbin/kubectl

echo -e "\033[1;33m---------------CREATE CLUSTER---------------\033[0m"
sudo /usr/local/sbin/k3d cluster create CLUSTER --api-port 0.0.0.0:6443 -p "8080:80@loadbalancer"
sudo /usr/local/sbin/kubectl cluster-info

echo -e "\033[1;33m---------------INSTALL ARGOCD---------------\033[0m"
sudo /usr/local/sbin/kubectl create namespace dev
sudo /usr/local/sbin/kubectl create namespace argocd
sudo /usr/local/sbin/kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


echo -e "\033[1;33m---------------KUBECTL APPLY---------------\033[0m"
sudo /usr/local/sbin/kubectl apply -f /vagrant/confs/ingress.yml -n argocd
sudo /usr/local/sbin/kubectl apply -f /vagrant/confs/app.yml
sudo /usr/local/sbin/kubectl apply -f /vagrant/confs/project.yml

echo -e "\033[1;33m---------------INFORMATION---------------\033[0m"
sudo /usr/local/sbin/kubectl get all
sudo /usr/local/sbin/kubectl get ns
sudo /usr/local/sbin/kubectl get pods -n dev
