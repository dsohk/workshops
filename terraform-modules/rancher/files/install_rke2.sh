echo "Install Rancher Server using helm chart on RKE2 ..."
echo "Install RKE2 v1.23 ..."
sudo bash -c 'curl -sfL https://get.rke2.io | INSTALL_RKE2_METHOD=tar INSTALL_RKE2_CHANNEL="v1.23" sh -'
sudo mkdir -p /etc/rancher/rke2
sudo bash -c 'echo "write-kubeconfig-mode: \"0644\"" > /etc/rancher/rke2/config.yaml'
sudo bash -c 'echo "tls-san:" >> /etc/rancher/rke2/config.yaml'
sudo bash -c 'echo "  - ${rancher_server_public_ip}" >> /etc/rancher/rke2/config.yaml'
sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service