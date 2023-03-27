data "google_compute_node_types" "type_list" {
  zone = "europe-west3-b"
}

output "type_list" {
  value = data.google_compute_node_types.type_list.names
}
