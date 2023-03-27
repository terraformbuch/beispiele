# In dieser Datei können Variablen gesetzt werden um die Standardeinstellungen in "variables.tf" zu überschreiben.
# Einzelne Provider können mit "*_enabled = true|false" an- und abgeschaltet werden.

name        = "terraformbuch"              # Resourcen werden in diesem Namensraum erstellt
admin_user  = "terraform"                  # Benutzer für SSH-Verbindungen
public_key  = "./terraform_id_ed25519.pub" # Öffentlich Schlüssel für SSH-Verbindungen
private_key = "./terraform_id_ed25519"     # Privateer Schlüssel für SSH-Verbindungen

# Provider spezifisch

## AWS
aws_enabled  = false                     # AWS einschalten
aws_region   = "us-east-2"               # AWS Region
aws_azs      = ["us-east-2a", "us-east-2b", "us-east-2c"] # AWS availability zones
aws_os_image = "ami-0be91f4be81da8bea"   # AWS AMI - default openSUSE Leap latest
aws_os_size  = "t2.micro"                # AWS Instanzgröße

## Azure
azure_enabled            = false                 # Azure einschalten
azure_region             = "westeurope"          # Azure Region
azure_os_image_publisher = "SUSE"                # Azure image Hersteller
azure_os_image_offer     = "opensuse-leap-15-3"  # Azure image
azure_os_image_sku       = "gen2"                # Azure image sku
azure_os_image_version   = "2022.01.13"          # Azure image version
azure_vm_size            = "Standard_B1s"        # Azure Instanzgröße

## GCP
gcp_enabled     = false                          # GCP einschalten
gcp_project     = "my-project"                   # bereits existierendes Projekt
gcp_credentials = "gcp_credentials.json"         # JSON Datei mit GCP Zugangsdaten
gcp_region      = "europe-west1"                 # GCP Region
gcp_os_image    = "opensuse-cloud/opensuse-leap" # GCP image
gcp_vm_size     = "custom-1-1024"                # GCP Instanzgröße

## Libvirt
libvirt_enabled       = false             # Libvirt einschalten
libvirt_qemu_uri      = "qemu:///system"  # Libvirt Verbindungs-URL
libvirt_network_name  = "default"         # bereits existierendes Libvirt-Netzwerk
libvirt_bridge_device = "virbr0"          # Bridge-Device auf dem das Netzwerk läuft

## OpenStack
openstack_enabled               = false                                  # OpenStack einschalten
openstack_external_network_name = "external"                             # bereits existierendes externes Netzwerk
openstack_floatingip_pool       = "external"                             # bereits existierender floating-IP-pool
openstack_region_net            = "south-2"                              # existierende region # anders in jeder OpenStack Installation
openstack_region_compute        = "south-2"                              # existierende region # anders in jeder OpenStack Installation
openstack_os_image              = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # openSUSE Leap 15.3 # anders in jeder OpenStack Installation
openstack_os_size               = "2C-2GB-10GB"                          # vorhandes Flavor muss gefählt werden # anders in jeder OpenStack Installation

## VMware
vmware_enabled    = false                           # VMware einschalten
vmware_datacenter = "dc1"                           # VMware Datacenter
vmware_cluster    = "cluster1"                      # VMware Cluster
vmware_host       = "esxi1.home.lab"                # VMware Host
vmware_datastore  = "datastore1"                    # VMware Datastore
vmware_network    = "VM Network"                    # VMware Netzwerk
vmware_ipaddress  = "192.168.122.222"               # IP Adresse für Instanz (kein DHCP im Netzwerk)
vmware_ipcidr     = "/24"                           # CIDR-Maske für Instanz
vmware_ipgateway  = "192.168.122.1"                 # Gateway für Instanz
