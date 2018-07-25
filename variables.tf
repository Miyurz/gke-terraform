/*
variable "bucket_name" {
   description = "Store terraform state here"
}
*/
variable "k8s_node_machine_type" {
  description = "Provision k8s machine node type"
}
variable "k8s_version" {
  description = "K8s version for master as well nodes. Lets keep it same"
}
variable "startup_script" {
  description = "Provisioning script"
}
variable "gce_ssh_pub_key_file" {
  description = "SSH key to login into bastion server"
}
variable "gce_ssh_user" {
   description = "ssh user to login"
}
variable "project" {
   description = ""
}
variable "region" {
   description = ""
}
variable "k8s_cluster" {
   description = ""
}
variable "k8s_cluster_zone" {
   description = ""
}
variable "master_auth_username" {
   description = ""
}
variable "master_auth_password" {
  description = ""
}
