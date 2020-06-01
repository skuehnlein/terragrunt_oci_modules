data "oci_identity_compartments" "compartments" {
    # Required
    compartment_id = var.tenancy_OCID

    # Optional
    access_level = "ACCESSIBLE"
    compartment_id_in_subtree = true
}

locals {
    compartment_ids = zipmap(data.oci_identity_compartments.compartments.compartments[*].name, data.oci_identity_compartments.compartments.compartments[*].id)
}

resource "oci_identity_policy" "compartment_policies" {
    for_each = var.all_compartment_policies

    #Required
    compartment_id = lookup(local.compartment_ids,each_value["compartment_name"])
    name = each_value["name"]
    description = each_value["description"]
    statements = each_value["statements"]
}