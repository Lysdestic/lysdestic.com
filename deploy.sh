#!/usr/bin/env bash
set -e

DEPLOY_DIR="deploy_upload"
TIMESTAMP=$(date -u +"%Y%m%dT%H%M%SZ")
COMMIT_MSG=$(git log -1 --format="%s" | tr ' ' '-' | tr -cd '[:alnum:]-' | cut -c1-40)
ZIP_NAME="deploy_${TIMESTAMP}_${COMMIT_MSG}.zip"

echo "→ Calculating stardate..."
STARDATE=$(node -e "
  const now = new Date()
  const epoch = new Date('1987-07-15T00:00:00Z')
  process.stdout.write(((((now.getTime() - epoch.getTime()) / 1000 / 3155.76) + 410000) / 10).toFixed(1))
")
echo "  Stardate: $STARDATE"

echo "→ Writing stardate to package.json..."
node -e "
  const fs = require('fs')
  const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'))
  pkg.version = '${STARDATE}'
  fs.writeFileSync('package.json', JSON.stringify(pkg, null, 4))
"

echo "→ Building site..."
PUBLIC_STARDATE=$STARDATE npm run build

echo "→ Packaging dist/ into ${DEPLOY_DIR}/${ZIP_NAME}..."
mkdir -p "$DEPLOY_DIR"
cd dist && zip -r "../${DEPLOY_DIR}/${ZIP_NAME}" . && cd ..

echo ""
echo "✓ Done! Stardate ${STARDATE} written to package.json and baked into build."
echo ""
echo "  Upload this file to your cPanel File Manager:"
echo "  ${DEPLOY_DIR}/${ZIP_NAME}"
echo ""
echo "  Extract it into public_html/ (overwrite existing files)."
echo "  Purge host cache, then Cloudflare if needed."