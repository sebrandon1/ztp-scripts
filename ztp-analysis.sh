#!/bin/bash

# Set your site/cluster name
SITE=cnfdf29
GROUP_NS=ztp-group-$SITE
COMMON_NS=ztp-common-$SITE

echo "=== ManagedCluster Labels ==="
oc get managedcluster $SITE -o json | jq '.metadata.labels'

echo -e "\n=== PolicyGenTemplates in $GROUP_NS ==="
oc get policygentemplate -n $GROUP_NS -o yaml

echo -e "\n=== PolicyGenTemplates in $COMMON_NS ==="
oc get policygentemplate -n $COMMON_NS -o yaml

echo -e "\n=== ACM Policies in $GROUP_NS ==="
oc get policy -n $GROUP_NS -o yaml

echo -e "\n=== ACM Policies in $COMMON_NS ==="
oc get policy -n $COMMON_NS -o yaml

echo -e "\n=== PlacementRules in $GROUP_NS ==="
oc get placementrule -n $GROUP_NS -o yaml

echo -e "\n=== PlacementBindings in $GROUP_NS ==="
oc get placementbinding -n $GROUP_NS -o yaml

echo -e "\n=== ManifestWorks in $SITE namespace ==="
oc get manifestwork -n $SITE -o yaml

echo -e "\n=== Policy Framework Addon Pods on Spoke ==="
oc get pods -n open-cluster-management-agent-addon | grep governance

echo -e "\n=== ArgoCD Application Status (if using ArgoCD) ==="
oc get applications.argoproj.io -A

echo -e "\n=== Events in $GROUP_NS ==="
oc get events -n $GROUP_NS --sort-by=.metadata.creationTimestamp | tail -20

echo -e "\n=== Events in $COMMON_NS ==="
oc get events -n $COMMON_NS --sort-by=.metadata.creationTimestamp | tail -20
