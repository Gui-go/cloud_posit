output "tf_vm_externalip" {
  value = google_compute_instance.tf_computeinstance.network_interface[0].access_config[0].nat_ip
}
