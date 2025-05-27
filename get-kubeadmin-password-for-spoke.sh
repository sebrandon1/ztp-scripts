#!/bin/bash

# Usage: ./get-kubeadmin-password.sh <cluster-name>
CLUSTER_NAME="$1"

if [ -z "$CLUSTER_NAME" ]; then
  echo "Usage: $0 <cluster-name>"
  exit 1
fi

echo "Searching for kubeadmin password for cluster: $CLUSTER_NAME"

# Look up the secret using oc across all namespaces
SECRET_INFO=$(oc get secret -A | grep "${CLUSTER_NAME}" | grep "admin-password")

if [ -z "$SECRET_INFO" ]; then
  echo "Error: admin-password secret not found for cluster '$CLUSTER_NAME'"
  exit 2
fi

# Extract namespace and secret name
NAMESPACE=$(echo "$SECRET_INFO" | awk '{print $1}')
SECRET_NAME=$(echo "$SECRET_INFO" | awk '{print $2}')

# Retrieve and decode the password
PASSWORD=$(oc get secret "$SECRET_NAME" -n "$NAMESPACE" -o jsonpath='{.data.password}' | base64 --decode)

echo "kubeadmin password for cluster '$CLUSTER_NAME': $PASSWORD"
