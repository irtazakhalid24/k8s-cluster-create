sudo apt update
sudo apt upgrade
sudo apt install docker.io
docker --version
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/kubernetes-xenial.gpg
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt update
sudo apt install kubeadm kubelet kubectl
sudo apt-mark hold kubelet kubeadm kubectl
kubeadm version
sudo swapoff –a
#sudo vim /etc/fstab
sudo reboot
sudo kubeadm join 192.168.1.215:6443 --token su0qfj.t4j8xp38cm7adi6w --discovery-token-ca-cert-hash sha256:4b261e426c9aebb532a86fb3f02252632dec886c14affa69becb973562cd0e85
