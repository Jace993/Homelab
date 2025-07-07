sudo apt update && sudo apt dist-upgrade

sudo apt install qemu-guest-agent

cd /etc/netplan
cat /etc/hostname
cat /etc/hosts

sudo apt install containerd

sudo mkdir /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo nano /etc/containerd/config.toml
# change the following lines
runc.io.containerd.runc.v2>>
#   SystemdCgroup = true

# swap must be disabled
sudo nano /etc/fstab
# comment out the swap line
sudo swapoff -a
free -m

# enable ip forward
sudo nano /etc/sysctl.conf
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo nano /etc/sysctl.conf
# uncomment the following lines
#net.ipv4.ip_forward = 1
sudo sysctl -p
#ubuntu 25.10
sudo ln -s /etc/sysctl.conf /etc/sysctl.d/99-sysctl.conf




# enable briding
sudo nano /etc/modules-load.d/k8s.conf
# br_netfilter

# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
sudo apt update

# install pre reqs
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
sudo apt install kubeadm kubelet kubectl

# kube Node template BEGIN !
sudo cloud-init clean
sudo rm -rf /var/lib/cloud/instances

# reset hardware id
sudo truncate -s 0 /etc/machine-id

sudo rm /var/lib/dbus/machine-id
#create a symlink to /etc/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
ls -l /var/lib/dbus/machine-id

# should be empty
cat /etc/machine-id

# power off node
sudo poweroff

## Create 3 nodes in proxmox
## node END

# Controller begin
sudo kubeadm init --control-plane-endpoint=192.168.1.250 --node-name k8s-controller --pod-network-cidr=10.244.0.0/16

#kube controller - give local user access to the cluster
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# commands kubectl
kubectl get pods --all-namespaces

# install dns flannel
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

kubectl get nodes

# regenerate join command / token on controller
kubeadm token create --print-join-command
