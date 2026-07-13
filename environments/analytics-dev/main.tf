# ═══════════════════════════════════════════════════════════════
# ENVIRONMENT: analytics-dev (SERVICE PROJECT)
#
# PURPOSE:
# Deploys Analytics DEV resources into the
# Shared VPC managed by host-dev-project.
#
# IMPORTANT:
# This environment does NOT create VPC or subnets!
# Those are created by environments/host-dev
#
# ANALYTICS USES MANAGED SERVICES — NO GKE!
# → Dataflow   (managed Apache Beam)
# → Datastream (managed CDC replication)
# → BigQuery   (serverless data warehouse)
# → Pub/Sub    (serverless messaging)
#
# WHAT THIS CREATES:
# → Placeholder — resources to be added
#
# RUN AFTER: environments/host-dev
# ═══════════════════════════════════════════════════════════════

# Placeholder — Analytics DEV resources to be implemented
# Uses subnets from host-dev-project shared VPC:
# → analytics-dev-private  10.60.24.0/22 (Dataflow workers)
# → analytics-dev-data     10.60.28.0/22 (Datastream/BigQuery)
