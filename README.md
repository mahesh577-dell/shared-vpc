# FreightFox — Terraform Infrastructure (GCP Shared VPC)

## Design Decisions
- **Shared VPC**: 3 host projects own VPCs; service projects consume subnets
- **Individual SA per project**: 11 SAs — least privilege, 1 key leak = 1 project risk
- **State bucket per project**: each project holds its own tfstate bucket
- **APIs per project type**: host / service / analytics get different API sets
- **Parameterized bootstrap**: run per project via script, CLI, or CircleCI

## Repository Structure

```
freightfox-terraform/
├── .circleci/config.yml          ← 11 env workflows + bootstrap workflow
├── terraform/bootstrap/          ← Parameterized per-project bootstrap
│   ├── main.tf                   ← APIs + state bucket + dedicated SA
│   ├── run_bootstrap.sh          ← ./run_bootstrap.sh tms-dev | all
│   ├── projects/*.tfvars         ← 1 tfvars per project (11 files)
│   └── states/                   ← local state per project (gitignored)
├── modules/
│   ├── networking/ (vpc, subnet, shared-vpc, firewall, cloud-router, nat)
│   ├── database/cloud-sql/
│   ├── data-pipeline/ (placeholders)
│   └── security/ (secret-manager + placeholders)
└── environments/
    ├── host-dev/                 ← ACTIVE: Shared VPC + 8 subnets
    ├── tms-dev/                  ← ACTIVE: Cloud SQL + Secret Manager
    ├── vms-dev/ analytics-dev/   ← placeholders (empty by request)
    └── ... all other envs
```

## What Bootstrap Creates (per project)

| Item | Example (tms-dev) |
|---|---|
| APIs enabled | compute, sqladmin, secretmanager... (by type) |
| State bucket | freightfox-tfstate-tms-dev (in tms-dev project) |
| Dedicated SA | circleci-tf-tms-dev@tms-dev-501607.iam... |
| SA roles | editor + storage.admin on own project |
| networkUser | on host project (service/analytics only) |

## CircleCI Contexts — One Per Environment

| Environment | Context | SA |
|---|---|---|
| host-dev | gcp-host-dev | circleci-tf-host-dev |
| host-staging | gcp-host-staging | circleci-tf-host-staging |
| host-prod | gcp-host-prod | circleci-tf-host-prod |
| tms-dev | gcp-tms-dev | circleci-tf-tms-dev |
| tms-staging | gcp-tms-staging | circleci-tf-tms-staging |
| tms-prod | gcp-tms-prod | circleci-tf-tms-prod |
| vms-dev | gcp-vms-dev | circleci-tf-vms-dev |
| vms-staging | gcp-vms-staging | circleci-tf-vms-staging |
| vms-prod | gcp-vms-prod | circleci-tf-vms-prod |
| analytics-dev | gcp-analytics-dev | circleci-tf-analytics-dev |
| analytics-prod | gcp-analytics-prod | circleci-tf-analytics-prod |
| (bootstrap) | gcp-bootstrap | org-admin key (temporary) |

Each context has ONE variable: `GOOGLE_CREDENTIALS` = SA JSON key

## How to Bootstrap

### Update project IDs first!
Edit `terraform/bootstrap/projects/*.tfvars` — replace all XXXXX.

### Option A — Helper script (local)
```bash
cd terraform/bootstrap
./run_bootstrap.sh host-dev        # one project
./run_bootstrap.sh all             # all 11 projects
./run_bootstrap.sh tms-dev plan    # plan only
```

### Option B — Raw terraform (local)
```bash
cd terraform/bootstrap
terraform init
terraform apply \
  -state="states/tms-dev.tfstate" \
  -var-file="projects/tms-dev.tfvars"
```

### Option C — CircleCI (parameterized)
```
Trigger Pipeline →
  run_bootstrap = true
  bootstrap_env = tms-dev
→ Approve → runs with gcp-bootstrap context
```

## Full Setup Flow

```
1. Update projects/*.tfvars with real project IDs
2. Bootstrap all 11 projects (any order — SAs are independent!)
3. For each project:
   → gcloud iam service-accounts keys create key.json \
       --iam-account=circleci-tf-<env>@<project>.iam.gserviceaccount.com
   → CircleCI: create context gcp-<env>
   → Add GOOGLE_CREDENTIALS = key content
4. Deploy environments:
   → host-dev FIRST (creates shared VPC)
   → then tms-dev, vms-dev, analytics-dev
5. Repeat for staging + prod tiers
```

## Deploying an Environment

```
CircleCI → Trigger Pipeline
→ environment = host-dev
→ Run pipeline
→ validate → plan → approve → apply
```
