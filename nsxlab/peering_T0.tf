#Define vlan attached segment




resource "nsxt_policy_vlan_segment" "peering1" {
  display_name = "peering1_interface_vlan_60"
  transport_zone_path = data.nsxt_policy_transport_zone.tz-vlan.path
  vlan_ids = [ "60" ]
}

resource "nsxt_policy_vlan_segment" "peering2" {
  display_name = "peering2_interface_vlan_70"
  transport_zone_path = data.nsxt_policy_transport_zone.tz-vlan.path
  vlan_ids = [ "70" ]
}

#Define T0 Core Router, name, cluster relationship and BGP AS number
resource "nsxt_policy_tier0_gateway" "T0-MPBGP" {
  description   = "T0 provisioned by terraform"
  display_name  = "T0-MPBGP"
  failover_mode = "Non_Premptive"
  default_rule_logging = false
  enable_firewall = false
  ha_mode = "Active_Standby"
  internal_transit_subnets = [var.internal_transit_subnets]
  transit_subnets = [var.transit_subnets]
  edge_cluster_path            = data.nsxt_policy_edge_cluster.Prod-Cluster.path
  
  bgp_config {
      local_as_num            = "65000"
      ecmp = true
      enabled                  = true
      inter_sr_ibgp            = true    
  }
}

resource "nsxt_policy_gateway_redistribution_config" "advertised-routes" {
  gateway_path = nsxt_policy_tier0_gateway.Peering.path
  bgp_enabled  = true
  ospf_enabled = false
  rule {
    name = "advertised-routes"
    types = ["TIER0_CONNECTED", "TIER0_EVPN_TEP_IP"]
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
  subnets = ["172.16.60.0/24"] 
  mtu = 1500
}

resource "nsxt_policy_tier0_gateway_interface" "peering2" {
  display_name = "Peering2_interface"
  description = "connection to Peering2"
  edge_node_path = data.nsxt_policy_edge_node.edge2.path
  type = "EXTERNAL"
  gateway_path = nsxt_policy_tier0_gateway.Peering.path
  segment_path = nsxt_policy_vlan_segment.peering2.path
  subnets = ["172.16.70.0/24"] 
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
    neighbor_address = "172.16.60.1"
    remote_as_num = "65001"
    maximum_hop_limit = 5
    source_addresses = nsxt_policy_tier0_gateway_interface.Peering1.ip_addresses
    bfd_config {
      enabled = true
      interval = ?
      multiple = ?
    }
}

resource "nsxt_policy_bgp_neighbor" "Peer2" {
    display_name = "Lab BGP Peering"
    description = "Terraform provisioned BgpNeighborConfig"
    bgp_path = nsxt_policy_tier0_gateway.Peering.bgp_config.0.path
    allow_as_in = true
    graceful_restart_mode = "HELPER_ONLY"
    hold_down_time = 300
    keep_alive_time = 100
    neighbor_address = "172.16.70.1"
    remote_as_num = "65001"
    maximum_hop_limit = 5
    source_addresses = nsxt_policy_tier0_gateway_interface.Peering2.ip_addresses
}

resource "nsxt_policy_bgp_neighbor" "Peer1" {
    display_name = "Lab BGP Peering"
    description = "Terraform provisioned BgpNeighborConfig"
    bgp_path = nsxt_policy_tier0_gateway.Peering.bgp_config.0.path
    allow_as_in = true
    graceful_restart_mode = "HELPER_ONLY"
    hold_down_time = 300
    keep_alive_time = 100
    neighbor_address = "10.10.10.3"
    remote_as_num = "65001"
    maximum_hop_limit = 5
    source_addresses = nsxt_policy_tier0_gateway_interface.Peering1.ip_addresses
    route_filtering {
      address_family = "IPV4"
    }
    route_filtering {
      address_family = "L2VPN_EVPN"
    }
}

resource "nsxt_policy_bgp_neighbor" "Peer2" {
    display_name = "Lab BGP Peering"
    description = "Terraform provisioned BgpNeighborConfig"
    bgp_path = nsxt_policy_tier0_gateway.Peering.bgp_config.0.path
    allow_as_in = true
    graceful_restart_mode = "HELPER_ONLY"
    hold_down_time = 300
    keep_alive_time = 100
    neighbor_address = "10.10.10.4"
    remote_as_num = "65001"
    maximum_hop_limit = 5
    source_addresses = nsxt_policy_tier0_gateway_interface.Peering2.ip_addresses
    route_filtering {
      address_family = "IPV4"
    }
    route_filtering {
      address_family = "L2VPN_EVPN"
    }
}