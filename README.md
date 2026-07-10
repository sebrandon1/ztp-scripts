# ZTP Scripts

Bash scripts for managing Zero Touch Provisioning (ZTP) hubs and spokes in OpenShift environments.

---

## Scripts

### `get-ztp-kubeconfig.sh`
Retrieves the admin kubeconfig for a cluster managed by ZTP in a given namespace.

**Usage:**
```bash
./get-ztp-kubeconfig.sh <namespace> [output_file]
```
- `<namespace>`: The namespace where the ClusterDeployment exists.
- `[output_file]`: (Optional) The file to write the kubeconfig to. Defaults to `<namespace>-kubeconfig`.

---

### `get-kubeadmin-password-for-spoke.sh`
Looks up the admin-password secret across all namespaces for a given cluster name and decodes the kubeadmin password.

**Usage:**
```bash
./get-kubeadmin-password-for-spoke.sh <cluster-name>
```

---

### `delete-pgts.sh`
Deletes all Policy objects from a spoke namespace, useful for forcing a policy re-sync from GitOps.

**Usage:**
```bash
./delete-pgts.sh <spoke-namespace>
```

---

### `extract-latest-420.sh`
Fetches the latest OCP 4.20 nightly release image pullspec from the CI release stream and extracts its contents locally using `oc adm release extract`.

> **Note:** Hardcoded to 4.20 nightly stream. Update `VERSION_STREAM` for other versions.

---

### `gather-aci-debug.sh`
Collects AgentClusterInstall, ClusterDeployment, InfraEnv, NMStateConfig, Agents, BareMetalHosts, ConfigMaps, and Events from a namespace into a timestamped debug directory, then analyzes ACI conditions and agent validations.

**Usage:**
```bash
./gather-aci-debug.sh <namespace>
```

---

### `setup-420-catalogsources.sh`
Disables all default OperatorHub sources and creates custom CatalogSources pointing to the v4.20 operator index images.

> **Note:** Hardcoded to v4.20 images. Update the image tags for other versions.

---

### `setup-catalogsources-auto-version.sh`
Same as `setup-420-catalogsources.sh` but automatically checks whether v4.20 catalog images exist (via `skopeo inspect`) and falls back to v4.19 if not available.

---

### `ztp-analysis.sh`
Dumps ManagedCluster labels, PolicyGenTemplates, ACM Policies, PlacementRules, PlacementBindings, ManifestWorks, governance pods, ArgoCD applications, and recent events for a site.

> **Note:** Has hardcoded site name (`SITE=cnfdf29`). Edit the variable before running.

---

### `ztp-spoke-check.sh`
Checks a spoke cluster for expected ZTP-applied objects: operator namespaces, OperatorGroups, Subscriptions, PerformanceProfile, PtpConfig, SriovOperatorConfig, CatalogSources, Tuned, MachineConfigPools, and more.

---

## Prerequisites

- `oc` (OpenShift CLI) with cluster-admin privileges
- `kubectl`
- `jq`
- `base64`
- `skopeo` (for `setup-catalogsources-auto-version.sh`)
- `curl` (for `extract-latest-420.sh`)
- Access to a ZTP hub cluster

> **Note:** Several scripts reference OCP 4.20 specifically (`extract-latest-420.sh`, `setup-420-catalogsources.sh`, `setup-catalogsources-auto-version.sh`). Update version strings as needed for other releases.
