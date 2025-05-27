#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="openshift-marketplace"

# CatalogSource names
CATALOG_NAMES=(
  "redhat-operators"
  "certified-operators"
  "community-operators"
  "redhat-marketplace"
)

# Corresponding base image paths (no tag)
CATALOG_IMAGES=(
  "redhat/redhat-operator-index"
  "redhat/certified-operator-index"
  "redhat/community-operator-index"
  "redhat/redhat-marketplace-index"
)

check_image_exists() {
  local image="$1"
  local tag="$2"
  # Force platform to linux/amd64 for manifest inspection
  skopeo inspect --override-arch=amd64 --override-os=linux "docker://registry.redhat.io/${image}:${tag}" &>/dev/null
}

echo "🔍 Checking catalog images availability for linux/amd64..."

FINAL_IMAGES=()

for i in "${!CATALOG_NAMES[@]}"; do
  name="${CATALOG_NAMES[$i]}"
  base_image="${CATALOG_IMAGES[$i]}"

  if check_image_exists "$base_image" "v4.20"; then
    FINAL_IMAGES[$i]="registry.redhat.io/${base_image}:v4.20"
    echo "✅ $name → v4.20"
  else
    FINAL_IMAGES[$i]="registry.redhat.io/${base_image}:v4.19"
    echo "⚠️ $name → v4.19 (fallback)"
  fi
done

echo "📦 Applying updated CatalogSources..."

for i in "${!CATALOG_NAMES[@]}"; do
  name="${CATALOG_NAMES[$i]}"
  image="${FINAL_IMAGES[$i]}"
  display_name="$(echo "$name" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')"

  cat <<EOF | kubectl apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ${name}
  namespace: ${NAMESPACE}
spec:
  sourceType: grpc
  image: ${image}
  displayName: ${display_name}
  publisher: Red Hat
EOF

done

echo "✅ All CatalogSources updated."
echo "Run:"
echo "  kubectl -n ${NAMESPACE} get catalogsources"
echo "  kubectl -n ${NAMESPACE} get pods -l olm.catalogSource"
