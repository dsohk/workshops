# install longhorn
module "longhorn" {
  source                 = "../longhorn"
  kubernetes_config_path = local_file.kube_config_server_yaml.filename
}


