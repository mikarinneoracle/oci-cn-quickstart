terraform {
  required_version = ">=1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "6.3.0"
      configuration_aliases = [oci.home]
    }
  }
}

provider "oci" {
  region = var.region
}

provider "oci" {
  alias = "home"
  region = local.home_region
}