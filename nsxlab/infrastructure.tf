data "nsxt_policy_edge_cluster" "CLUSTER1" {
    display_name = "Cluster-1"
}

data "nsxt_policy_transport_zone" "TZ-OVERLAY" {
    display_name = "TZ-Overlay"
}

data "nsxt_policy_transport_zone" "TZ-VLAN" {
    display_name = "TZ-VLAN"
}

data "nsxt_policy_edge_node" "edge1" {
    edge_cluster_path = data.nsxt_policy_edge_cluster.CLUSTER1.path
    display_name = "edge1"
}

data "nsxt_policy_edge_node" "edge2" {
    edge_cluster_path = data.nsxt_policy_edge_cluster.CLUSTER1.path
    display_name = "edge2"
}

#Define Distributed DHCP server
resource "nsxt_policy_dhcp_server" "demo_dhcp_server" {
  display_name = "demo_dhcp"
  description  = "DHCP Server for lab assignment"
  server_addresses = []
}