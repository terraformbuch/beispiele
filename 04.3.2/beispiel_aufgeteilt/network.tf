resource "google_compute_network" "terraform" {
  name                    = "terraform-netzwerk"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "terraform" {
  name          = "terraform-subnet"
  network       = google_compute_network.terraform.name
  ip_cidr_range = "172.16.10.0/24"
}
