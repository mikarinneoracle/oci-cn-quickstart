resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn.id
  display_name = "SG"
  services {
    service_id = lookup(data.oci_core_services.all_oci_services.services[0], "id")
  }
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn.id
  display_name = "NAT"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn.id
  display_name = "IG"
  count = var.lb_subnet_private ? 0 : 1
}

resource "oci_core_route_table" "service_route_table" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn.id
  display_name = "service-gateway-rt"
  route_rules {
    network_entity_id = oci_core_service_gateway.service_gateway.id
    destination_type = "SERVICE_CIDR_BLOCK"
    destination = lookup(data.oci_core_services.all_oci_services.services[0], "cidr_block")
    description = "Route for all internal OCI services in the region"
  }
}

resource "oci_core_route_table" "nat_route_table" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn.id
  display_name = "nat-gateway-rt"
  route_rules {
    network_entity_id = oci_core_service_gateway.service_gateway.id
    destination_type = "SERVICE_CIDR_BLOCK"
    destination = lookup(data.oci_core_services.all_oci_services.services[0], "cidr_block")
    description = "Route for all internal OCI services in the region"
  }
  route_rules {
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
    destination_type = "CIDR_BLOCK"
    destination = "0.0.0.0/0"
    description = "Route to reach external Internet through a NAT gateway"
  }
}

resource "oci_core_route_table" "internet_route_table" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.spoke_vcn.id
  display_name = "internet-gateway-rt"
  route_rules {
    network_entity_id = oci_core_internet_gateway.internet_gateway[0].id
    destination_type = "CIDR_BLOCK"
    destination = "0.0.0.0/0"
    description = "Route to reach external Internet through the Internet gateway"
  }
  count = var.lb_subnet_private ? 0 : 1
}