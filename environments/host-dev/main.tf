# ═══════════════════════════════════════════════════════════════
# ENVIRONMENT: host-dev
#
# PURPOSE:
# Creates the Shared VPC infrastructure for ALL dev environments
# tms-dev, vms-dev, analytics-dev all share this VPC
#
# WHAT THIS CREATES:
# 1. VPC (host-dev-vpc) in host-dev-project
# 2. All subnets for tms-dev, vms-dev, analytics-dev
# 3. Shared VPC host project setup
# 4. Service project attachments
# 5. IAM for service projects to use subnets
# 6. Firewall rules
# 7. Cloud Router + NAT
#
# RUN BEFORE:
# tms-dev, vms-dev, analytics-dev environments
# ═══════════════════════════════════════════════════════════════

# ── 1. VPC ────────────────────────────────────────────────────
module "vpc" {
  source      = "../../modules/networking/vpc"
  project_id  = var.host_project_id
  vpc_name    = "host-dev-vpc"
  description = "FreightFox DEV Shared VPC — tms-dev, vms-dev, analytics-dev"
}

# ── 2. Subnets ────────────────────────────────────────────────
# All subnets for dev service projects
# Created in HOST project — shared to service projects
module "subnets" {
  source        = "../../modules/networking/subnet"
  project_id    = var.host_project_id
  region        = var.region
  vpc_self_link = module.vpc.network_self_link
  flow_sampling = 0.1

  subnets = {
    # ── TMS-DEV subnets ──────────────────────────────────────
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

    # ── VMS-DEV subnets ──────────────────────────────────────
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

    # ── ANALYTICS-DEV subnets ────────────────────────────────
    # No GKE — uses Dataflow/Datastream/BigQuery managed services
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

# ── 3. Shared VPC Setup ───────────────────────────────────────
# Enable host project + attach service projects
module "shared_vpc" {
  source              = "../../modules/networking/shared-vpc"
  host_project_id     = var.host_project_id
  service_project_ids = var.service_project_ids

  depends_on = [module.vpc, module.subnets]
}

# ── 4. Firewall Rules ─────────────────────────────────────────
module "firewall" {
  source      = "../../modules/networking/firewall"
  project_id  = var.host_project_id
  vpc_name    = module.vpc.network_name
  vpc_cidr    = "10.60.0.0/16"
  name_prefix = "host-dev"

  depends_on = [module.vpc]
}

# ── 5. Cloud Router ───────────────────────────────────────────
module "router" {
  source      = "../../modules/networking/cloud-router"
  project_id  = var.host_project_id
  region      = var.region
  router_name = "host-dev-router"
  vpc_id      = module.vpc.network_id
  bgp_asn     = 64514

  depends_on = [module.vpc]
}

# ── 6. Cloud NAT ──────────────────────────────────────────────
module "nat" {
  source      = "../../modules/networking/nat"
  project_id  = var.host_project_id
  region      = var.region
  router_name = module.router.router_name
  nat_name    = "host-dev-nat"

  subnet_self_links = [
    module.subnets.subnet_self_links["tms-dev-private"],
    module.subnets.subnet_self_links["vms-dev-private"],
    module.subnets.subnet_self_links["analytics-dev-private"],
  ]

  depends_on = [module.router, module.subnets]
}
