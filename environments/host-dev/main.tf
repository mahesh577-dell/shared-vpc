# ---------------------------------------------------------------
# ENVIRONMENT: host-dev
#
# PURPOSE:
# Creates the Shared VPC infrastructure for ALL dev environments
# tms-dev, vms-dev, analytics-dev all share this VPC
#
# WHAT THIS CREATES:
# 1. VPC (host-dev-vpc)
# 2. All subnets for tms-dev, vms-dev, analytics-dev
# 3. Shared VPC host project setup
# 4. Service project attachments
# 5. IAM for service projects to use subnets
# ---------------------------------------------------------------

# -- 1. VPC ----------------------------------------------------
module "vpc" {
  source      = "../../modules/networking/vpc"
  project_id  = var.host_project_id
  vpc_name    = "host-dev-vpc"
  description = "FreightFox DEV Shared VPC for tms-dev, vms-dev, analytics-dev"
}

# -- 2. Subnets ------------------------------------------------
module "subnets" {
  source        = "../../modules/networking/subnet"
  project_id    = var.host_project_id
  region        = var.region
  vpc_self_link = module.vpc.network_self_link
  flow_sampling = 0.1

  subnets = {
    "tms-dev-public" = {
      cidr                     = "10.60.0.0/22"
      description              = "TMS DEV Public — Load Balancer / Bastion"
      private_ip_google_access = false
    }
    "tms-dev-private" = {
      cidr                     = "10.60.4.0/22"
      description              = "TMS DEV Private — GKE Nodes / GCE VMs"
      private_ip_google_access = true
      secondary_ranges = [
        {
          range_name    = "tms-dev-pods"
          ip_cidr_range = "10.60.64.0/18"
        },
        {
          range_name    = "tms-dev-services"
          ip_cidr_range = "10.60.128.0/22"
        }
      ]
    }
    "tms-dev-data" = {
      cidr                     = "10.60.8.0/22"
      description              = "TMS DEV Data — Cloud SQL private IP"
      private_ip_google_access = true
    }
    "vms-dev-public" = {
      cidr                     = "10.60.12.0/22"
      description              = "VMS DEV Public — Load Balancer / Bastion"
      private_ip_google_access = false
    }
    "vms-dev-private" = {
      cidr                     = "10.60.16.0/22"
      description              = "VMS DEV Private — GKE Nodes / GCE VMs"
      private_ip_google_access = true
      secondary_ranges = [
        {
          range_name    = "vms-dev-pods"
          ip_cidr_range = "10.60.192.0/18"
        },
        {
          range_name    = "vms-dev-services"
          ip_cidr_range = "10.60.132.0/22"
        }
      ]
    }
    "vms-dev-data" = {
      cidr                     = "10.60.20.0/22"
      description              = "VMS DEV Data — Cloud SQL private IP"
      private_ip_google_access = true
    }
    "analytics-dev-private" = {
      cidr                     = "10.60.24.0/22"
      description              = "Analytics DEV Private — Dataflow / Datastream workers"
      private_ip_google_access = true
    }
    "analytics-dev-data" = {
      cidr                     = "10.60.28.0/22"
      description              = "Analytics DEV Data — BigQuery / Datastream connections"
      private_ip_google_access = true
    }
  }

  depends_on = [module.vpc]
}

# -- 3. Shared VPC Setup ---------------------------------------
module "shared_vpc" {
  source              = "../../modules/networking/shared-vpc"
  host_project_id     = var.host_project_id
  service_project_ids = var.service_project_ids

  depends_on = [module.vpc, module.subnets]
}
