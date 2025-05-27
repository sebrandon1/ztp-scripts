#!/bin/bash

# Usage: ./get-ztp-kubeconfig.sh <namespace> [output_file]
# Example: ./get-ztp-kubeconfig.sh cnfdf29 cnfdf29-kubeconfig

set -euo pipefail

NAMESPACE="${1:-}"
OUTPUT_FILE="${2:-${NAMESPACE}-kubeconfig}"

if [[ -z "$NAMESPACE" ]]; then
  echo "Usage: $0 <namespace> [output_file]"
  exit 1
fi

echo "[INFO] Looking up admin kubeconfig secret in namespace: $NAMESPACE"

SECRET_NAME=$(oc get clusterdeployment -n "$NAMESPACE" -o jsonpath='{.items[0].spec.clusterMetadata.adminKubeconfigSecretRef.name}' 2>/dev/null)

if [[ -z "$SECRET_NAME" ]]; then
  echo "[ERROR] Could not find ClusterDeployment or kubeconfig secret in namespace '$NAMESPACE'"
  exit 2
fi

echo "[INFO] Found secret: $SECRET_NAME"

echo "[INFO] Extracting kubeconfig to: $OUTPUT_FILE"

oc get secret -n "$NAMESPACE" "$SECRET_NAME" -o jsonpath='{.data.kubeconfig}' | base64 -d > "$OUTPUT_FILE"

echo "[INFO] Kubeconfig written to '$OUTPUT_FILE'"

echo "[INFO] Testing connection..."
KUBECONFIG="$OUTPUT_FILE" oc get nodes

echo "[SUCCESS] Kubeconfig retrieval and cluster access verified."

