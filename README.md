# FreightFox — Terraform Infrastructure (GCP Shared VPC Model)

## Repository Structure1

```
freightfox-terraform/
├── .circleci/config.yml          ← CircleCI pipeline
├── .gitignore
├── terraform/bootstrap/          ← Run ONCE manually
├── modules/
│   ├── networking/
│   │   ├── vpc/                  ← VPC (used by host projects)
│   │   ├── subnet/               ← Subnets with GKE secondary ranges
│   │   ├── firewall/             ← Firewall rules
│   │   ├── shared-vpc/           ← Shared VPC host/service setup ← NEW!
│   │   ├── cloud-router/         ← Cloud Router
│   │   ├── nat/                  ← Cloud NAT
│   │   ├── cloudflare-ztna/      ← PLACEHOLDER
│   │   └── vpc-peering/          ← PLACEHOLDER
│   ├── database/
│   │   └── cloud-sql/            ← PostgreSQL 16
│   ├── data-pipeline/
│   │   ├── dataflow/             ← PLACEHOLDER
│   │   ├── datastream/           ← PLACEHOLDER
│   │   ├── bigquery/             ← PLACEHOLDER
│   │   └── pubsub/               ← PLACEHOLDER
│   └── security/
│       ├── secret-manager/       ← Stores DB passwords
│       ├── kms/                  ← PLACEHOLDER
│       ├── iam/                  ← PLACEHOLDER
│       └── cloud-armor/          ← PLACEHOLDER
└── environments/
    ├── shared/                   ← Org IAM, Cloudflare
    ├── host-dev/                 ← ACTIVE: Shared VPC for dev ← NEW!
    ├── host-staging/             ← Shared VPC for staging ← NEW!
    ├── host-prod/                ← Shared VPC for prod ← NEW!
    ├── tms-dev/                  ← ACTIVE: TMS DEV service project
    ├── tms-staging/              ← placeholder
    ├── tms-prod/                 ← placeholder
    ├── vms-dev/                  ← placeholder
    ├── vms-staging/              ← placeholder
    ├── vms-prod/                 ← placeholder
    ├── analytics-dev/            ← placeholder
    └── analytics-prod/           ← placeholder (NO staging!)
```

## Shared VPC Architecture

```
host-dev-project (host)
└── host-dev-vpc (10.60.0.0/16)
    ├── tms-dev-public     10.60.0.0/22
    ├── tms-dev-private    10.60.4.0/22  + pods/services secondary
    ├── tms-dev-data       10.60.8.0/22
    ├── vms-dev-public     10.60.12.0/22
    ├── vms-dev-private    10.60.16.0/22 + pods/services secondary
    ├── vms-dev-data       10.60.20.0/22
    ├── analytics-dev-private 10.60.24.0/22
    └── analytics-dev-data    10.60.28.0/22

Service projects consume subnets from host:
├── tms-dev-501607     → uses tms-dev-* subnets
├── vms-dev-XXXXX      → uses vms-dev-* subnets
└── analytics-dev-XXXXX → uses analytics-dev-* subnets
```

## Deployment Order

```
Step 1: terraform/bootstrap (ONCE manually)
Step 2: environments/shared
Step 3: environments/host-dev
Step 4: environments/host-staging
Step 5: environments/host-prod
Step 6: environments/tms-dev
Step 7: environments/vms-dev
Step 8: environments/analytics-dev
...and so on
```

## CircleCI

```
Push to feature/* → validate + plan only
Merge to main    → validate + plan + approve + apply

To deploy host-dev:
CircleCI → Trigger Pipeline → environment = host-dev

To deploy tms-dev:
CircleCI → Trigger Pipeline → environment = tms-dev
```
