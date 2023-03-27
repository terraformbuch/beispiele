resource "google_compute_firewall" "terraform" {
  name          = "erlaube-ssh-und-icmp"
  network       = google_compute_network.terraform.name
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "icmp"
  }
}
