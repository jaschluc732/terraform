data "nsxt_policy_edge_cluster" "CLUSTER1" {
    display_name = "Prod-Cluster"
}

data "nsxt_policy_transport_zone" "TZ-OVERLAY" {
    display_name = "tz-overlay"
}

data "nsxt_policy_transport_zone" "TZ-VLAN" {
    display_name = "tz-vlan"
}

data "nsxt_policy_edge_node" "edge1" {
    edge_cluster_path = data.nsxt_policy_edge_cluster.CLUSTER1.path
    display_name = "nsx-edge1"
}

data "nsxt_policy_edge_node" "edge2" {
    edge_cluster_path = data.nsxt_policy_edge_cluster.CLUSTER1.path
    display_name = "nsx-edge2"
}