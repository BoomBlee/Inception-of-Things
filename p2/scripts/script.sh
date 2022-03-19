#!/bin/sh

sudo dnf --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos -y
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='server --flannel-iface=eth1' K3S_TOKEN='token' K3S_KUBECONFIG_MODE=644 K3S_NODE_NAME="SERVER"  sh -s -

/usr/local/bin/kubectl apply -f /vagrant/confs/app1.yml
/usr/local/bin/kubectl apply -f /vagrant/confs/app2.yml
/usr/local/bin/kubectl apply -f /vagrant/confs/app3.yml
/usr/local/bin/kubectl apply -f /vagrant/confs/ingress.yml
