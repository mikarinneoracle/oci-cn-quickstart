terraform {
  required_version = ">=1.6.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">=6.3.0"
    }
  }
}

provider "oci" {
  region = var.region
}