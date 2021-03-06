# install ECK
module "elastic" {
  source                 = "../../../terraform-modules/elastic"
  kubernetes_config_path = local_file.kube_config_server_yaml.filename
  storage_class_name     = module.longhorn.storage_class_name
  eck_host               = azurerm_public_ip.rke2-lb-pip.ip_address
  es_count               = 3
  kb_count               = 3
}

