locals {
  available_groups = [
    {
      name                        = "ubuntu"
      description                 = "Ubuntu machines"
      instanceobject              = module.create_ubuntu_instances
      number_of_desired_instances = 1
    },
    {
      name                        = "opensuse"
      description                 = "openSUSE machines"
      instanceobject              = module.create_opensuse_instances
      number_of_desired_instances = 1
    },
    {
      name                        = "rhel"
      description                 = "Red Hat Enterprise Linux machines"
      instanceobject              = module.create_rhel_instances
      number_of_desired_instances = 3
    },
    {
      name                        = "sles"
      description                 = "SUSE Linux Enterprise Server machines"
      instanceobject              = module.create_sles_instances
      number_of_desired_instances = 4
    }
  ]
}