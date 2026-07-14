#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
# Bootstrap Runner — run bootstrap per project via parameters
#
# USAGE:
#   ./run_bootstrap.sh host-dev          → bootstrap one project
#   ./run_bootstrap.sh all               → bootstrap ALL projects
#   ./run_bootstrap.sh host-dev plan     → plan only (no apply)
#
# ORDER (when running individually):
#   1. host-dev   (creates nonprod CircleCI SA)
#   2. host-prod  (creates prod CircleCI SA)
#   3. everything else (grants existing SA access)
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

ENV="${1:-}"
ACTION="${2:-apply}"

ALL_ENVS=(host-dev host-prod host-staging tms-dev tms-staging tms-prod vms-dev vms-staging vms-prod analytics-dev analytics-prod)

mkdir -p states

run_one() {
  local env="$1"
  local tfvars="projects/${env}.tfvars"

  if [ ! -f "$tfvars" ]; then
    echo "❌ $tfvars not found!"
    exit 1
  fi

  echo ""
  echo "═══════════════════════════════════════════"
  echo " Bootstrapping: $env"
  echo "═══════════════════════════════════════════"

  terraform init -input=false

  if [ "$ACTION" = "plan" ]; then
    terraform plan \
      -state="states/${env}.tfstate" \
      -var-file="$tfvars" \
      -input=false
  else
    terraform apply \
      -state="states/${env}.tfstate" \
      -var-file="$tfvars" \
      -input=false \
      -auto-approve
    echo "✅ $env bootstrapped!"
  fi
}

if [ -z "$ENV" ]; then
  echo "Usage: ./run_bootstrap.sh <env|all> [plan|apply]"
  echo "Envs: ${ALL_ENVS[*]}"
  exit 1
fi

if [ "$ENV" = "all" ]; then
  # host-dev and host-prod FIRST (they create the CircleCI SAs)
  for e in "${ALL_ENVS[@]}"; do
    run_one "$e"
  done
else
  run_one "$ENV"
fi

echo ""
echo "✅ Bootstrap complete!"
