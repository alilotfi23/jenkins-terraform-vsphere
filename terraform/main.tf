# Data source to retrieve the specified vSphere datacenter by name
data "vsphere_datacenter" "datacenter" {
    name = var.vsphere_datacenter
}

# Data source to retrieve the specified vSphere network within the datacenter
data "vsphere_network" "network" {
  name          = var.vm_network          # Network name to be used for the VM
  datacenter_id = data.vsphere_datacenter.datacenter.id  # Reference to the datacenter's ID
}

# Data source to retrieve the specified vSphere datastore within the datacenter
data "vsphere_datastore" "datastore" {
  name          = var.datastore           # Datastore name where VM disks will be stored
  datacenter_id = data.vsphere_datacenter.datacenter.id  # Reference to the datacenter's ID
}

# Data source to retrieve the specified vSphere compute cluster within the datacenter
data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster_name        # Cluster name where the VM will be deployed
  datacenter_id = data.vsphere_datacenter.datacenter.id  # Reference to the datacenter's ID
}

# Resource block to define a new virtual machine in vSphere
resource "vsphere_virtual_machine" "vm" {
  name                 = var.vm_name        # Name of the virtual machine
  datastore_id         = data.vsphere_datastore.datastore.id  # Reference to the datastore's ID
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id  # Reference to the resource pool of the cluster
  guest_id             = var.guest_id       # The guest OS identifier (e.g., "ubuntu64Guest")
  cpu                  = var.cpu            # Number of CPUs for the VM
  ram                  = var.ram            # Amount of RAM in MB for the VM

  # Timeout settings for waiting for guest OS network and IP
  wait_for_guest_net_timeout = 0            # Disable waiting for guest network
  wait_for_guest_ip_timeout  = 0            # Disable waiting for guest IP

  # CD-ROM configuration for the VM
  cdrom {
    datastore_id = data.vsphere_datastore.datastore.id  # Reference to the datastore for the CD-ROM
    path         = var.path          # Path to the ISO or image file for the CD-ROM
  }

  # Network interface configuration for the VM
  network_interface {
    network_id = data.vsphere_network.network.id  # Reference to the network for the VM
  }

  # Disk configuration for the VM
  disk {
    label = "${var.vm_name}.vmdk"  # Disk label for the VM's virtual disk
    size  = var.vm_size            # Size of the virtual disk in GB
  }

  # Provisioner block to run a local command after VM creation
  provisioner "local-exec" {
    inline = [
      "ansible-playbook lamp.yml"  # Command to execute an Ansible playbook for further configuration
    ]
  }
}
