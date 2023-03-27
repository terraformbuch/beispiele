resource "google_compute_instance" "terraform" {
  name         = "beispiel-instanz"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.terraform.name

    access_config {
    }
  }

  metadata = {
    ssh-keys = "tux:${file(pathexpand("~/.ssh/id_ed25519.pub"))}"
  }
}
