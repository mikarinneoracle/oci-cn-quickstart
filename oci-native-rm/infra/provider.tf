terraform {
  required_version = ">=1.5.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "6.7.0"
    }
  }
}

provider "oci" {
  region = var.my_region
}