# install longhorn
module "longhorn" {
  source                 = "../../../terraform-modules/longhorn"
  kubernetes_config_path = local_file.kube_config_server_yaml.filename
}


