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
```bash
./get-kubeadmin-password-for-spoke.sh <cluster-name>
```

### `setup-420-catalogsources.sh` / `setup-catalogsources-auto-version.sh`
Configure catalog sources for OCP versions.

### `extract-latest-420.sh`
Extract the latest 4.20 release information.

### `gather-aci-debug.sh`
Gather ACI debugging information.
```bash
./gather-aci-debug.sh <namespace>
```

### `ztp-analysis.sh` / `ztp-spoke-check.sh`
Analyze ZTP deployments and check spoke cluster status.

**Note:** `ztp-analysis.sh` has hardcoded values (e.g., `SITE=cnfdf29`) that need to be edited before use.

### `delete-pgts.sh`
Delete Policy objects from a spoke namespace (useful for forcing policy re-sync from GitOps).

## Requirements

- `oc` (OpenShift CLI) with cluster-admin privileges
- `kubectl` (for catalog source setup scripts)
- Access to ZTP hub cluster
- `jq` for JSON processing
- `base64` for decoding secrets
- `skopeo` for image manifest inspection (setup-catalogsources-auto-version.sh)
- `curl` for fetching release data (extract-latest-420.sh)

## Code Style

### Bash
- Use `shellcheck` for linting
- Include usage comments at the top of scripts
- Handle errors gracefully with meaningful messages
