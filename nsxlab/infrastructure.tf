data "nsxt_policy_edge_cluster" "Prod-Cluster" {
    display_name = "Prod-Cluster"
}

data "nsxt_policy_transport_zone" "tz-overlay" {
    display_name = "tz-overlay"
}

data "nsxt_policy_transport_zone" "tz-vlan" {
    display_name = "tz-vlan"
}

data "nsxt_policy_edge_node" "edge1" {
    edge_cluster_path = data.nsxt_policy_edge_cluster.Prod-Cluster.path
    display_name = "nsx-edge1"
}

data "nsxt_policy_edge_node" "edge2" {
    edge_cluster_path = data.nsxt_policy_edge_cluster.Prod-Cluster.path
    display_name = "nsx-edge2"
}