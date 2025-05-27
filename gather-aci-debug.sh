#!/bin/bash

set -euo pipefail

# Colors for log levels
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Log functions
info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }

# Check for required command
for cmd in jq oc; do
  if ! command -v $cmd &>/dev/null; then
    error "Required command '$cmd' not found."
    exit 1
  fi
done

if [ $# -ne 1 ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

NS="$1"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
OUTPUT_DIR="aci-debug-${TIMESTAMP}"

info "Cleaning up old aci-debug-* folders..."
find . -maxdepth 1 -type d -name 'aci-debug-*' -mtime +7 -exec rm -rf {} +

info "Gathering must-gather data for AgentClusterInstall in namespace: $NS"
info "Output directory: $OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

echo
echo "========== Collecting resources... =========="

resources=(
  agentclusterinstall
  clusterdeployment
  infraenv
  nmstateconfig
  agents
  baremetalhosts
  configmaps
  events
)

for res in "${resources[@]}"; do
  info "Collecting $res..."
  oc get "$res" -n "$NS" -o json > "$OUTPUT_DIR/${res}.json" || warn "Failed to get $res"
done

echo
echo "========== Analyzing AgentClusterInstall conditions... =========="

ACI_JSON="$OUTPUT_DIR/agentclusterinstall.json"

if jq -e '.items | length > 0' "$ACI_JSON" &>/dev/null; then
  jq -r '
    .items[] |
    "[INFO] SpecSynced: \(.status.conditions[]? | select(.type == "SpecSynced") | .status) - \(.message)",
    "[INFO] RequirementsMet: \(.status.conditions[]? | select(.type == "RequirementsMet") | .status) - \(.message)",
    "[INFO] Validated: \(.status.conditions[]? | select(.type == "Validated") | .status) - \(.message)",
    "[INFO] Completed: \(.status.conditions[]? | select(.type == "Completed") | .status) - \(.message)",
    "[INFO] Failed: \(.status.conditions[]? | select(.type == "Failed") | .status) - \(.message)",
    "[INFO] Stopped: \(.status.conditions[]? | select(.type == "Stopped") | .status) - \(.message)",
    "[INFO] LastInstallationPreparationFailed: \(.status.conditions[]? | select(.type == "LastInstallationPreparationFailed") | .status) - \(.message)"
  ' "$ACI_JSON"
else
  warn "No AgentClusterInstall found in namespace: $NS"
fi

echo
echo "========== Analyzing Agent states and validations... =========="

AGENTS_JSON="$OUTPUT_DIR/agents.json"

if jq -e '.items | length > 0' "$AGENTS_JSON" &>/dev/null; then
  agent_count=$(jq '.items | length' "$AGENTS_JSON")
  info "Found $agent_count agent(s)"

  jq -r '
    .items[] as $agent |
    "[INFO] Agent ID: \($agent.metadata.name // "unknown")",
    "[INFO] Hostname: \($agent.status.hostname // "unknown")",
    "[INFO] Approval: \($agent.spec.approved)",
    "[INFO] Role: \($agent.spec.role // "unset")",
    "[INFO] Validation Info:",
    (
      $agent.status.validations as $v |
      if $v == null then
        "[WARN] No validations present"
      elif ($v | type == "array") then
        $v[] | "  [\(.status)] \(.id): \(.message)"
      elif ($v | type == "object") then
        $v | to_entries[] | .value[] | "  [\(.status)] \(.id): \(.message)"
      else
        "[ERROR] Unknown validation format"
      end
    ),
    ""
  ' "$AGENTS_JSON"
else
  warn "No agents found in namespace: $NS"
fi
