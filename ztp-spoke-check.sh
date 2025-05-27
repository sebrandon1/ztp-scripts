#!/bin/bash

echo "=== ZTP Spoke Object Existence Check ==="

# Namespaces
for ns in openshift-sriov-network-operator openshift-ptp openshift-logging openshift-local-storage openshift-marketplace openshift-monitoring openshift-cluster-node-tuning-operator; do
  echo -n "Namespace $ns: "
  oc get ns $ns --no-headers &>/dev/null && echo "Found" || echo "Missing"
done

# OperatorGroups
echo -e "\nOperatorGroups:"
oc get operatorgroup --all-namespaces

# Subscriptions
echo -e "\nSubscriptions:"
oc get subscription --all-namespaces

# ClusterLogForwarder
echo -e "\nClusterLogForwarder:"
oc get clusterlogforwarder --all-namespaces

# PerformanceProfile
echo -e "\nPerformanceProfile:"
oc get performanceprofile --all-namespaces

# PtpConfig
echo -e "\nPtpConfig:"
oc get ptpconfig --all-namespaces

# PtpOperatorConfig
echo -e "\nPtpOperatorConfig:"
oc get ptpoperatorconfig --all-namespaces

# SriovOperatorConfig
echo -e "\nSriovOperatorConfig:"
oc get sriovoperatorconfig --all-namespaces

# MachineConfigPool
echo -e "\nMachineConfigPool:"
oc get machineconfigpool

# Tuned
echo -e "\nTuned:"
oc get tuned --all-namespaces

# CatalogSource
echo -e "\nCatalogSource:"
oc get catalogsource --all-namespaces

# ClusterRoleBindings for logcollector
echo -e "\nClusterRoleBindings for logcollector:"
oc get clusterrolebinding | grep logcollector

# ServiceAccounts for collector
echo -e "\nServiceAccounts named collector:"
oc get serviceaccount --all-namespaces | grep collector

echo -e "\n=== End of ZTP Spoke Object Check ==="
