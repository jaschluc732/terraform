terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
    }
  }
}
#NSXT Specific details, hostname, login credentials etc

provider "nsxt" {
  host                 = "192.168.1.13"
  username             = "admin"
  password             = "NSxVMware!2345"
  allow_unverified_ssl = true
  max_retries          = 10
  retry_min_delay      = 500
  retry_max_delay      = 5000
  retry_on_status_codes = [ 429 ]
}