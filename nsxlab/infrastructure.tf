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
    edge_cluster_path = data.nsxt_policy_edge_cluster.edge-cluster.path
    display_name = "nsx-edge1"
}

data "nsxt_policy_edge_node" "edge2" {
    edge_cluster_path = data.nsxt_policy_edge_cluster.edge-cluster.path
    display_name = "nsx-edge2"
}

# Create L2 vlan segments 
resource "nsxt_policy_vlan_segment" "t0_extgw_vlan60" {
    display_name = "Uplink-EXTGW-vlan60"
    nsx_id = "Uplink-EXTGW-vlan60"
    description = "vlan segment created by Terraform"
    vlan_ids = "60"
    advanced_config {
      connectivity = "0n"
    
    }
  
}

# Create L2 vlan segments 
resource "nsxt_policy_vlan_segment" "t0_extgw_vlan70" {
    display_name = "Uplink-EXTGW-vlan60"
    nsx_id = "Uplink-EXTGW-vlan70"
    description = "vlan segment created by Terraform"
    vlan_ids = "70"
    advanced_config {
      connectivity = "0n"
    
    }
  
}

# Create NSXT Logical Switches
resource "nsxt_logical_switch" "nsxhostSwitch1" {
  admin_state       = "UP"
  description       = "Switch created by Terraform"
  display_name      = var.nsxhostSwitch1
  transport_zone_id = data.nsxt_policy_transport_zone.tz-overlay.id
  replication_mode  = "MTEP"
  
}

# Create NSXT Logical Switches
resource "nsxt_logical_switch" "nsxhostSwitch2" {
  admin_state       = "UP"
  description       = "Switch created by Terraform"
  display_name      = var.nsxhostSwitch2
  transport_zone_id = data.nsxt_policy_transport_zone.tz-vlan.id
  replication_mode  = "MTEP"
  
}