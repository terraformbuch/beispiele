data "vsphere_datastore" "datastore" {
  name          = "default_pool"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
