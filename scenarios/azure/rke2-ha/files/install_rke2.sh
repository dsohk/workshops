echo "Install Rancher Server using helm chart on RKE2 ..."
echo "Install RKE2 v1.22 ..."
sudo bash -c 'curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL="v1.22" sh -'
sudo mkdir -p /etc/rancher/rke2
sudo bash -c 'echo "write-kubeconfig-mode: \"0644\"" > /etc/rancher/rke2/config.yaml'
if [ ${first_instance} == "no" ]; then
  sudo bash -c 'echo "server: https://${rke2_first_node_public_ip}:9345" >> /etc/rancher/rke2/config.yaml'
fi
sudo bash -c 'echo "token: my-shared-secret" >> /etc/rancher/rke2/config.yaml'
sudo bash -c 'echo "tls-san:" >> /etc/rancher/rke2/config.yaml'
sudo bash -c 'echo "  - ${rke2_loadbalancer_public_ip}" >> /etc/rancher/rke2/config.yaml'
sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service