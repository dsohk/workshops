# install ECK
module "elastic" {
  source                 = "../elastic"
  kubernetes_config_path = local_file.kube_config_server_yaml.filename
  storage_class_name     = module.longhorn.storage_class_name
  eck_host               = azurerm_public_ip.rke2-lb-pip.ip_address
}

