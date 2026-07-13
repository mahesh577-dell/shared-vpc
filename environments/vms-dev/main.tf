# ═══════════════════════════════════════════════════════════════
# ENVIRONMENT: vms-dev (SERVICE PROJECT)
#
# PURPOSE:
# Deploys VMS DEV application resources into the
# Shared VPC managed by host-dev-project.
#
# IMPORTANT:
# This environment does NOT create VPC or subnets!
# Those are created by environments/host-dev
#
# WHAT THIS CREATES:
# → Placeholder — resources to be added
#
# RUN AFTER: environments/host-dev
# ═══════════════════════════════════════════════════════════════

# Placeholder — VMS DEV resources to be implemented
# Uses subnets from host-dev-project shared VPC:
# → vms-dev-public    10.60.12.0/22
# → vms-dev-private   10.60.16.0/22 (GKE nodes)
# → vms-dev-data      10.60.20.0/22 (Cloud SQL)
# → vms-dev-pods      10.60.192.0/18 (GKE pods secondary)
# → vms-dev-services  10.60.132.0/22 (GKE services secondary)
