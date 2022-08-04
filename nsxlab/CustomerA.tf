#Define T1 Router/Tenancy for CustomerA
resource "nsxt_policy_tier1_gateway" "CustomerA" {
  display_name = "CustomerA"
  description = "Tier1 provisioned thru terraform"
  edge_cluster_path = data.nsxt_policy_edge_cluster.CLUSTER1.path
  dhcp_config_path = nsxt_policy_dhcp_server.demo_dhcp_server.path
  failover_mode = "PREEMPTIVE"
  default_rule_logging = "false"
  enable_firewall = "true"
  enable_standby_relocation = "false"
  tier0_path = nsxt_policy_tier0_gateway.Peering.path
  route_advertisement_types = ["TIER1_STATIC_ROUTES", "TIER1_CONNECTED"]
  pool_allocation = "ROUTING"
}
  
#Connect IPv4 Segment to Distributed Router, enable DHCP
resource "nsxt_policy_segment" "CustomerA_Segment" {
  display_name = "CustomerA_Segment"
  description = "Segment provisioned thru terraform"
  connectivity_path = nsxt_policy_tier1_gateway.CustomerA.path
  transport_zone_path = data.nsxt_policy_transport_zone.TZ-OVERLAY.path
  subnet {
    cidr     = "10.100.0.1/24"
    dhcp_ranges = ["10.100.0.10-10.100.0.100"]
    dhcp_v4_config {
      lease_time = 36000
    }
  }

}