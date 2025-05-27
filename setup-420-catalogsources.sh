#!/bin/bash

set -e

echo "🔧 Disabling all default OperatorHub sources..."
kubectl patch operatorhub cluster --type merge -p '{
  "spec": {
    "disableAllDefaultSources": true
  }
}'

echo "⏳ Waiting a few seconds for defaults to disable..."
sleep 5

echo "📦 Creating custom CatalogSources with v4.20 images..."

cat <<EOF | kubectl apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: redhat-operators
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: registry.redhat.io/redhat/redhat-operator-index:v4.20
  displayName: Red Hat Operators
  publisher: Red Hat
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: certified-operators
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: registry.redhat.io/redhat/certified-operator-index:v4.20
  displayName: Certified Operators
  publisher: Red Hat
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: community-operators
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: registry.redhat.io/redhat/community-operator-index:v4.20
  displayName: Community Operators
  publisher: Red Hat
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: redhat-marketplace
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: registry.redhat.io/redhat/redhat-marketplace-index:v4.20
  displayName: Red Hat Marketplace
  publisher: Red Hat
EOF

echo "✅ Done! Use the following to verify:"
echo "  kubectl get catalogsources -A -o=jsonpath='{range .items[*]}{.metadata.name}: {.spec.image}{\"\\n\"}{end}'"
echo "  kubectl -n openshift-marketplace get pods -l olm.catalogSource"
