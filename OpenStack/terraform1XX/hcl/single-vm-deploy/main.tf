################################################################
# Module to deploy Single VM
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Licensed Materials - Property of IBM
#
# Copyright IBM Corp. 2017.
#
################################################################
variable "openstack_image_id" {
  description = "The ID of the image to be used for deploy operations."
  default = "01bd5882-5491-4737-8581-089a9e14803f"
}

variable "openstack_flavor_id" {
  description = "The ID of the flavor to be used for deploy operations."
  default = "94743f72-1f0e-483a-9f8b-b7f004d7102f"
}

variable "openstack_network_name" {
  description = "The name of the network to be used for deploy operations."
  default = "ibm-net"
}

variable "key_pair_name" {
  description = "The name of a ssh key pair which will be injected into the instance when they are created. The key pair must already be created and associated with the tenant's account. Changing key pair name creates a new instance."
  default     = "cloud"
}

variable "instance_name" {
  description = "A unique instance name. If a name is not provided a name would be generated."
}

# Generate a random padding
resource "random_id" "random_padding" {
  byte_length = "2"
}

provider "openstack" {
  insecure = true
  #version  = "~> 0.3"
}

resource "openstack_compute_instance_v2" "single-vm" {
  name = length(var.instance_name) > 0 ? var.instance_name : "terraform-single-vm-${random_id.random_padding.hex}"
  image_id  = var.openstack_image_id
  flavor_id = var.openstack_flavor_id
  key_pair  = var.key_pair_name

  network {
    name = var.openstack_network_name
  }
}

output "single-vm-ip" {
  value = element(
    openstack_compute_instance_v2.single-vm.*.network.0.fixed_ip_v4,
    0,
  )
}

