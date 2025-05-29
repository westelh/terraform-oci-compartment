terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

data "oci_identity_tag_namespaces" "oracle_standard" {
  compartment_id          = var.tenancy_ocid
  include_subcompartments = false
}

locals {
  oracle_standard_tag_namespace = [for i in data.oci_identity_tag_namespaces.oracle_standard.tag_namespaces : i if i.name == "Oracle-Standard"][0]
}

data "oci_identity_tag" "environment" {
  tag_name         = "Environment"
  tag_namespace_id = local.oracle_standard_tag_namespace.id
}

locals {
  defined_tags = merge({
    "Oracle-Standard.Environment" = var.environment
  }, var.defined_tags)
  freeform_tags = merge({}, var.freeform_tags)
}

resource "oci_identity_compartment" "this" {
  compartment_id = var.compartment_ocid
  name           = var.name
  description    = var.description
  enable_delete  = true

  defined_tags  = local.defined_tags
  freeform_tags = local.freeform_tags
}

resource "oci_identity_tag_default" "this" {
  compartment_id    = oci_identity_compartment.this.id
  tag_definition_id = data.oci_identity_tag.environment.id
  value             = var.environment
  is_required       = true
}

output "id" {
   value = oci_identity_compartment.this.id
   description = "Created compartment ocid"
}

