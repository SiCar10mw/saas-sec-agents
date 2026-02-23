#!/usr/bin/env bash
set -euo pipefail

# Upload DFIR sample data to Azure Storage with SHA256 manifest generation.
# This script is for controlled lab datasets and quarantined malware samples.

if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <resource-group> <storage-account> <container> <source-path>" >&2
  exit 1
fi

RG="$1"
SA="$2"
CONTAINER="$3"
SRC="$4"

if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI (az) is required." >&2
  exit 1
fi

if [[ ! -e "$SRC" ]]; then
  echo "Source path not found: $SRC" >&2
  exit 1
fi

MANIFEST="manifest-$(date +%Y%m%d-%H%M%S).sha256"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

if [[ -d "$SRC" ]]; then
  find "$SRC" -type f -print0 | xargs -0 shasum -a 256 > "$TMPDIR/$MANIFEST"
  az storage blob upload-batch \
    --auth-mode login \
    --account-name "$SA" \
    --destination "$CONTAINER" \
    --source "$SRC" \
    --overwrite false
else
  shasum -a 256 "$SRC" > "$TMPDIR/$MANIFEST"
  az storage blob upload \
    --auth-mode login \
    --account-name "$SA" \
    --container-name "$CONTAINER" \
    --name "$(basename "$SRC")" \
    --file "$SRC" \
    --overwrite false
fi

az storage blob upload \
  --auth-mode login \
  --account-name "$SA" \
  --container-name "manifests" \
  --name "$MANIFEST" \
  --file "$TMPDIR/$MANIFEST" \
  --overwrite false

echo "Upload complete."
echo "Resource group: $RG"
echo "Storage account: $SA"
echo "Container: $CONTAINER"
echo "Manifest: manifests/$MANIFEST"
