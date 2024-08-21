resource "oci_core_vcn" "spoke_vcn" {
  compartment_id = var.network_compartment_id
  display_name = var.vcn_name
  cidr_blocks = var.vcn_cidr_blocks
  dns_label = var.vcn_dns_label
}

resource "oci_core_default_security_list" "lockdown" {
  manage_default_resource_id = oci_core_vcn.spoke_vcn.default_security_list_id
  lifecycle {
    ignore_changes = [egress_security_rules, ingress_security_rules, defined_tags]
  }
}