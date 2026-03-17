#!/usr/bin/env bash
set -e

DEPLOY_DIR="deploy_upload"
TIMESTAMP=$(date -u +"%Y%m%dT%H%M%SZ")
COMMIT_MSG=$(git log -1 --format="%s" | tr ' ' '-' | tr -cd '[:alnum:]-' | cut -c1-40)
ZIP_NAME="deploy_${TIMESTAMP}_${COMMIT_MSG}.zip"

echo "→ Building site..."
npm run build

echo "→ Packaging dist/ into ${DEPLOY_DIR}/${ZIP_NAME}..."
mkdir -p "$DEPLOY_DIR"
cd dist && zip -r "../${DEPLOY_DIR}/${ZIP_NAME}" . && cd ..

echo ""
echo "✓ Done! Upload this file to your cPanel File Manager:"
echo "  ${DEPLOY_DIR}/${ZIP_NAME}"
echo ""
echo "  Extract it into public_html/ (overwrite existing files)."
