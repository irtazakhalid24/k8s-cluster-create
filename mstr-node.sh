#update the ubuntu
sudo apt update
sudo apt upgrade

#install this package if netplan try does not work and throw error like "Cannot call Open vSwitch: ovsdb-server.service is not running.
#Failed to reload network settings: Unit dbus-org.freedesktop.network1.service not found."
sudo apt-get install openvswitch-switch-dpdk

#Install Docker
sudo apt install docker.io
docker --version

#Create the initial configuration:

sudo mkdir /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

#For this cluster to work properly, we’ll need to enable SystemdCgroup within the configuration. To do that, we’ll need to edit the config we’ve just created:
sudo nano /etc/containerd/config.toml

#Within that file, find the following line of text:
#[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
#Underneath that, find the SystemdCgroup option and change it to true, which should look like this:
SystemdCgroup = true

#Note: Reboot the system to make these changes take affect.

#This will solve the crashloopbackoff problem with kube-proxy

#start and enable docker
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker

#Install Kubernetes
#Add the kuubernetes on ubuntu 22.04 & up repository and import the reportory's GPG key
####curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/kubernetes-xenial.gpg
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

#Add the Kubernetes repository
####sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
#Install the necessary packages for kubernetes
sudo apt update
sudo apt install kubeadm kubelet kubectl
sudo apt-mark hold kubelet kubeadm kubectl

#Turn off swap
sudo swapoff -a
#Swap can be off by putting hash infront of swap entry in /etc/fstab
#For Centos swapoff this commnad also work #swapoff /dev/mapper/centos-swap

kubeadm version

#Initialize kubernetes on Master node
###sudo kubeadm init --pod-network-cidr=10.244.0.0/16

sudo kubeadm init --control-plane-endpoint=192.168.1.172 --node-name k8-master-d --pod-network-cidr=10.244.0.0/16
#To regenerate the actual join command (kubeadm token create --print-join-commnad) The join command had time limit if generate a while ago it won't work. In that case you have to regenerate it.

#Configure your user account to access the cluster as non-root user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#A Pod Network is a way to allow communication between different nodes in the cluster. This tutorial uses the flannel virtual network.
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

#Verify that everything is running and communicating:
kubectl get pods --all-namespaces

# Must reboot the system to take these changes effect

#I had problem of proxy crashed every couple of mins by running these commanads i fixed this issue(I had to configure kubeproxy in master node) and restart the services.
#kubectl edit cm/kube-proxy -n kube-system

#.....
#metricsBindAddress: 0.0.0.0:10249
#.....

#kubectl rollout restart ds kube-proxy -n kube-system
#kubectl rollout status ds kube-proxy -n kube-system

#Generate new token to join work node
kubeadm token create --print-join-command
