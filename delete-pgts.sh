#!/bin/bash

set -euo pipefail

SPOKE_NAMESPACE="${1:-}"
if [[ -z "$SPOKE_NAMESPACE" ]]; then
  echo "Usage: $0 <spoke-namespace>"
  exit 1
fi

echo "[INFO] Deleting Policy objects in namespace: $SPOKE_NAMESPACE"

POLICIES=$(oc get policy -n "$SPOKE_NAMESPACE" --no-headers -o custom-columns=NAME:.metadata.name)

if [[ -z "$POLICIES" ]]; then
  echo "[INFO] No Policy objects found in $SPOKE_NAMESPACE"
  exit 0
fi

for policy in $POLICIES; do
  echo "[INFO] Deleting policy: $policy"
  oc delete policy "$policy" -n "$SPOKE_NAMESPACE"
done

echo "[INFO] All policies deleted. If managed by GitOps, they should be re-applied shortly."

