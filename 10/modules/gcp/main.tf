locals {
  gcp_ip              = var.ipaddress-internal
  gcp_ip_bastion      = google_compute_instance.bastion.network_interface.0.access_config.0.nat_ip
  gcp_ip_loadbalancer = module.gce-lb-http.external_ip
  gcp_ansible_trigger = google_compute_instance.webserver.id
}

resource "google_compute_network" "net" {
  name                    = "${var.name}-net"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet"
  network       = google_compute_network.net.name
  region        = var.region
  ip_cidr_range = var.iprange-subnet-internal
}

resource "google_compute_firewall" "allow_internal" {
  name          = "${var.name}-fw-internal"
  network       = google_compute_network.net.name
  source_ranges = [var.iprange-net-internal]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
}

resource "google_compute_firewall" "allow_icmp" {
  name          = "${var.name}-fw-icmp"
  network       = google_compute_network.net.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion", "webserver"]

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow_ssh" {
  name          = "${var.name}-fw-ssh"
  network       = google_compute_network.net.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_http" {
  name          = "${var.name}-fw-http"
  network       = google_compute_network.net.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["webserver"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

# router and NAT to connect VMs without public IPs to internet
resource "google_compute_router" "router" {
  name    = "${var.name}-router"
  network = google_compute_network.net.name
}

resource "google_compute_router_nat" "nat" {
  name   = "${var.name}-nat"
  router = google_compute_router.router.name

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.subnet.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_instance" "bastion" {
  machine_type = var.vm_size
  name         = "${var.name}-bastion"
  zone         = "${var.region}-b"

  can_ip_forward = true

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
    network_ip = var.ipaddress-bastion-internal

    # get public IP address
    access_config {
    }
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  boot_disk {
    initialize_params {
      image = var.os_image
    }

    auto_delete = true
  }

  metadata = {
    # user-data = "${var.user_data}"
    # enable-oslogin = "TRUE"
    #sshKeys = "${var.admin_user}:${file(var.public_key)}"
    ssh-keys = "${var.admin_user}:${file(var.public_key)}"
  }

  service_account {
    scopes = ["compute-rw", "storage-rw", "logging-write", "monitoring-write", "service-control", "service-management"]
  }

  tags = ["bastion"]
}

resource "google_compute_instance" "webserver" {
  machine_type = var.vm_size
  name         = var.name
  zone         = "${var.region}-b"

  can_ip_forward = true

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
    network_ip = var.ipaddress-internal
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  boot_disk {
    initialize_params {
      image = var.os_image
    }

    auto_delete = true
  }

  metadata = {
    # user-data = "${var.user_data}"
    # enable-oslogin = "TRUE"
    sshKeys = "${var.admin_user}:${file(var.public_key)}"
  }

  service_account {
    scopes = ["compute-rw", "storage-rw", "logging-write", "monitoring-write", "service-control", "service-management"]
  }

  tags = ["webserver"]
}


resource "null_resource" "gcp_ansible" {
  triggers = {
    id = local.gcp_ansible_trigger
  }

  connection {
    host                = local.gcp_ip
    type                = "ssh"
    user                = var.admin_user
    private_key         = file(pathexpand(var.private_key))
    bastion_host        = local.gcp_ip_bastion
    bastion_user        = var.admin_user
    bastion_private_key = file(pathexpand(var.private_key))
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "cloud-init status --wait"
  #   ]
  # }

  provisioner "local-exec" {
    command = <<EOL
        export ANSIBLE_HOST_KEY_CHECKING=False;
        export ANSIBLE_SSH_COMMON_ARGS='-A -i ${var.private_key} -o ProxyCommand="ssh -W %h:%p ${var.admin_user}@${local.gcp_ip_bastion}"'
        ssh-keygen -R ${local.gcp_ip_bastion}
        ssh-keygen -R ${local.gcp_ip}
        until nc -zv ${local.gcp_ip_bastion} 22; do sleep 10; done
        pgrep ssh-agent || eval $(ssh-agent) && ssh-add ${var.private_key}
        ansible-playbook -u ${var.admin_user} --private-key ${var.private_key} -i ${local.gcp_ip}, ansible/web-playbook.yaml
      EOL
  }
}

resource "google_compute_instance_group" "webserver" {
  name      = var.name
  instances = [google_compute_instance.webserver.self_link]

  named_port {
    name = "http"
    port = "80"
  }

  named_port {
    name = "https"
    port = "443"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# see https://github.com/terraform-google-modules/terraform-google-lb-http for details
module "gce-lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 6.3.0"

  project     = var.project
  name        = "${var.name}-http-lb"
  target_tags = ["webserver"]

  backends = {
    http = {
      description             = null
      protocol                = "HTTP"
      port                    = 80
      port_name               = "http"
      timeout_sec             = 10
      enable_cdn              = false
      custom_request_headers  = null
      custom_response_headers = null
      security_policy         = null

      connection_draining_timeout_sec = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = 80
        host                = null
        logging             = null
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group                        = google_compute_instance_group.webserver.id
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }
    },
    https = {
      description             = null
      protocol                = "HTTPS"
      port                    = 443
      port_name               = "https"
      timeout_sec             = 10
      enable_cdn              = false
      custom_request_headers  = null
      custom_response_headers = null
      security_policy         = null

      connection_draining_timeout_sec = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null

      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/"
        port                = 443
        host                = null
        logging             = null
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group                        = google_compute_instance_group.webserver.id
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }
    }
  }
}

resource "null_resource" "gcp_open_url" {
  depends_on = [null_resource.gcp_ansible]

  triggers = {
    id = null_resource.gcp_ansible.id
  }

  provisioner "local-exec" {
    command = <<EOL
        curl http://${local.gcp_ip_loadbalancer}
      EOL
  }
}
