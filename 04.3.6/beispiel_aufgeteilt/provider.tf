provider "vsphere" {
  user                 = "administrator@vsphere.local"
  password             = "strenggeheim"
  vsphere_server       = "192.168.1.111"
  allow_unverified_ssl = true
}
