# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Helpful bash scripts for working with Zero Touch Provisioning (ZTP) hubs and spokes in OpenShift environments.

## Available Scripts

### `get-ztp-kubeconfig.sh`
Retrieves the admin kubeconfig for a cluster managed by ZTP.
```bash
./get-ztp-kubeconfig.sh <namespace> [output_file]
```

### `get-kubeadmin-password-for-spoke.sh`
Retrieves the kubeadmin password for a spoke cluster.

### `setup-420-catalogsources.sh` / `setup-catalogsources-auto-version.sh`
Configure catalog sources for OCP versions.

### `extract-latest-420.sh`
Extract the latest 4.20 release information.

### `gather-aci-debug.sh`
Gather ACI debugging information.

### `ztp-analysis.sh` / `ztp-spoke-check.sh`
Analyze ZTP deployments and check spoke cluster status.

### `delete-pgts.sh`
Delete PolicyGenTemplates from the cluster.

## Requirements

- `oc` (OpenShift CLI) with cluster-admin privileges
- Access to ZTP hub cluster
- `jq` for JSON processing
- `base64` for decoding secrets

## Code Style

### Bash
- Use `shellcheck` for linting
- Include usage comments at the top of scripts
- Handle errors gracefully with meaningful messages
