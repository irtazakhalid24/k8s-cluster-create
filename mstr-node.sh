#update the ubuntu
sudo apt update
sudo apt upgrade

#Install Docker
sudo apt install docker.io
docker --version

#start and enable docker
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker

#Install Kubernetes
#Add the kuubernetes on ubuntu 22.04 & up repository and import the reportory's GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/kubernetes-xenial.gpg
#Add the Kubernetes repository
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
#Install the necessary packages for kubernetes
sudo apt update
sudo apt install kubeadm kubelet kubectl
sudo apt-mark hold kubelet kubeadm kubectl

#Turn off swap
sudo swapoff -a
#Swap can be off by putting hash infront of swap entry in /etc/fstab

kubeadm version

#Initialize kubernetes on Master node
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

#Configure your user account to access the cluster as non-root user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#A Pod Network is a way to allow communication between different nodes in the cluster. This tutorial uses the flannel virtual network.
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

#Verify that everything is running and communicating:
kubectl get pods --all-namespaces
