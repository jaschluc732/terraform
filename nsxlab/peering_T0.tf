#Define vlan attached segment
resource "nsxt_policy_vlan_segment" "peering1" {
  display_name = "peering1_interface_vlan_208"
  transport_zone_path = data.nsxt_policy_transport_zone.TZ-VLAN.path
  vlan_ids = [ "208" ]
}

resource "nsxt_policy_vlan_segment" "peering2" {
  display_name = "peering2_interface_vlan_209"
  transport_zone_path = data.nsxt_policy_transport_zone.TZ-VLAN.path
  vlan_ids = [ "209" ]
}

#Define T0 Core Router, name, cluster relationship and BGP AS number
resource "nsxt_policy_tier0_gateway" "Peering" {
  display_name                 = "Peering"
  edge_cluster_path            = data.nsxt_policy_edge_cluster.CLUSTER1.path

  bgp_config {
      local_as_num            = "65001"
      enabled                  = true
      inter_sr_ibgp            = true    
  }
}

resource "nsxt_policy_gateway_redistribution_config" "advertised-routes" {
  gateway_path = nsxt_policy_tier0_gateway.Peering.path
  bgp_enabled  = true
  ospf_enabled = true
  rule {
    name = "advertised-routes"
    types = ["TIER0_STATIC", "TIER0_CONNECTED", "TIER1_CONNECTED"]
  }
}

#Define T0 Router.... this is the core that connects to the remote GW
resource "nsxt_policy_tier0_gateway_interface" "peering1" {
  display_name = "Peering1_interface"
  description = "connection to Peering1"
  edge_node_path = data.nsxt_policy_edge_node.edge1.path
  type = "EXTERNAL"
  gateway_path = nsxt_policy_tier0_gateway.Peering.path
  segment_path = nsxt_policy_vlan_segment.peering1.path
  subnets = ["192.168.150.1/24"] 
  mtu = 1500
}

resource "nsxt_policy_tier0_gateway_interface" "peering2" {
  display_name = "Peering2_interface"
  description = "connection to Peering2"
  edge_node_path = data.nsxt_policy_edge_node.edge2.path
  type = "EXTERNAL"
  gateway_path = nsxt_policy_tier0_gateway.Peering.path
  segment_path = nsxt_policy_vlan_segment.peering2.path
  subnets = ["192.168.160.1/24"] 
  mtu = 1500
}

#Define BGP Neighbors
resource "nsxt_policy_bgp_neighbor" "Peer1" {
    display_name = "Lab BGP Peering"
    description = "Terraform provisioned BgpNeighborConfig"
    bgp_path = nsxt_policy_tier0_gateway.Peering.bgp_config.0.path
    allow_as_in = true
    graceful_restart_mode = "HELPER_ONLY"
    hold_down_time = 300
    keep_alive_time = 100
    neighbor_address = "192.168.150.254"
    remote_as_num = "65000"
    source_addresses = nsxt_policy_tier0_gateway_interface.Peering1.ip_addresses
}

resource "nsxt_policy_bgp_neighbor" "Peer2" {
    display_name = "Lab BGP Peering"
    description = "Terraform provisioned BgpNeighborConfig"
    bgp_path = nsxt_policy_tier0_gateway.Peering.bgp_config.0.path
    allow_as_in = true
    graceful_restart_mode = "HELPER_ONLY"
    hold_down_time = 300
    keep_alive_time = 100
    neighbor_address = "192.168.160.254"
    remote_as_num = "65000"
    source_addresses = nsxt_policy_tier0_gateway_interface.Peering2.ip_addresses
}