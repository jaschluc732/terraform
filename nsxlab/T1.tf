######################
#     T1 Creation    #
######################
resource "nsxt_policy_tier1_gateway" "T1GW" {
    description = "T1 provisioned by Terraform"
    failover_mode = "NON_PREEMPTIVE"
    default_rule_logging = false
    enable_firewall = false
    enable_standby_relocation = false
    edge_cluster_path = data.nsxt_policy_edge_cluster.edge-cluster.path
    tier0_path = nsxt_policy_tier0_gateway.T0_MPBGP.path?
    route_advertisement_types = [TEIR1]
}