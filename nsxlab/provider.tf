terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
  }
}

#NSXT Specific details, hostname, login credentials etc

provider "nsxt" {
  host                 = "192.168.1.17"
  username             = "admin"
  password             = "VMware!nsxt@1"
  allow_unverified_ssl = true
  max_retries          = 10
  retry_min_delay      = 500
  retry_max_delay      = 5000
  retry_on_status_codes = [ 429 ]
}