# Scripts Directory

This directory contains several Bash scripts for managing and interacting with OpenShift clusters and related resources. Below is a summary of each script and instructions on how to use them.

---

## Script List

### 1. `get-ztp-kubeconfig.sh`
Retrieves the admin kubeconfig for a cluster managed by ZTP (Zero Touch Provisioning) in a given namespace.

**Usage:**
```bash
./get-ztp-kubeconfig.sh <namespace> [output_file]
```
- `<namespace>`: The namespace where the ClusterDeployment exists.
- `[output_file]`: (Optional) The file to write the kubeconfig to. Defaults to `<namespace>-kubeconfig`.

**What it does:**
- Looks up the admin kubeconfig secret for the specified namespace.
- Extracts and decodes the kubeconfig, saving it to the specified file.
- Verifies access to the cluster using the new kubeconfig.

---

### 2. `get-kubeadmin-password-for-spoke.sh`
Retrieves the kubeadmin password for a spoke cluster. (See script for details.)

---

### 3. `delete_pgts.sh`
Deletes specific resources or objects, likely related to PostgreSQL or a similar service. (See script for details.)

---

### 4. `extract-latest-420.sh`
Extracts the latest OpenShift 4.20 release information or images. (See script for details.)

---

### 5. `gather-aci-debug.sh`
Gathers debug information for ACI (Application Centric Infrastructure) or related components. (See script for details.)

---

### 6. `setup-420-catalogsources.sh` and `setup-catalogsources-auto-version.sh`
Scripts for setting up OpenShift catalog sources, possibly for version 4.20 or with automatic versioning. (See scripts for details.)

---

### 7. `ztp-analysis.sh` and `ztp-spoke-check.sh`
Scripts for analyzing ZTP deployments and checking the status of spoke clusters. (See scripts for details.)

---

## General Notes
- All scripts are Bash scripts and should be run from a terminal on a system with the required tools (e.g., `oc`, `base64`).
- Make scripts executable if needed:
  ```bash
  chmod +x <scriptname>.sh
  ```
- Run scripts with `./<scriptname>.sh` and follow the usage instructions or check the script header for details.

For more information on a specific script, open it in a text editor and review the comments and usage examples at the top.
