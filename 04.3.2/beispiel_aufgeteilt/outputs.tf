output "Public_IP_der_VM" {
  value = google_compute_instance.terraform.network_interface.0.access_config.0.nat_ip
}
