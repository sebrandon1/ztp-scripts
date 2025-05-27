#!/bin/bash

# Set target version
VERSION_STREAM="4.20.0-0.nightly"
ARCH="amd64"
RELEASE_STREAM_URL="https://${ARCH}.ocp.releases.ci.openshift.org/api/v1/releasestream/${VERSION_STREAM}/latest"

# Optional: customize output directory
OUTPUT_DIR="./ocp-${VERSION_STREAM}"

# Fetch latest nightly image pullspec
echo "Fetching latest release image for ${VERSION_STREAM}..."
RELEASE_IMAGE=$(curl -s "$RELEASE_STREAM_URL" | jq -r '.pullSpec')

if [[ -z "$RELEASE_IMAGE" || "$RELEASE_IMAGE" == "null" ]]; then
  echo "❌ Failed to retrieve release image. Exiting."
  exit 1
fi

echo "✅ Found release image: $RELEASE_IMAGE"

# Extract the release contents
echo "Extracting release contents to: $OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"
oc adm release extract --from="$RELEASE_IMAGE" --to="$OUTPUT_DIR" --registry-config ~/.docker/config.json

echo "🎉 Done! Contents extracted to $OUTPUT_DIR"
