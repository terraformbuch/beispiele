terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  credentials = pathexpand("~/.config/gcloud/application_default_credentials.json")
  project     = "terraform-buch"
  region      = "europe-west3"
  zone        = "europe-west3-b"
}

resource "google_compute_network" "terraform" {
  name                    = "terraform-netzwerk"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "terraform" {
  name          = "terraform-subnet"
  network       = google_compute_network.terraform.name
  ip_cidr_range = "172.16.10.0/24"
}

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

output "Public_IP_der_VM" {
  value = google_compute_instance.terraform.network_interface.0.access_config.0.nat_ip
}
