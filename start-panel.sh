#!/usr/bin/env bash
# Deployment helper for panel host.
# Copy this repo to the panel host's /home/container and run this script there.

set -euo pipefail
cd "$(dirname "$0")"

if [ ! -f deploy.env ]; then
  echo "Error: deploy.env not found in $(pwd)"
  exit 1
fi

if [ -f .env ]; then
  mv .env ".env.bak.$(date +%s)"
  echo "Backed up existing .env"
fi
cp deploy.env .env

echo "Installing dependencies..."
npm install --no-audit --no-fund

echo "Running database connectivity test..."
npm run db-test

echo "Starting app with PM2..."
if ! command -v pm2 >/dev/null 2>&1; then
  echo "Installing pm2 globally..."
  npm install -g pm2
fi
cat > ecosystem.config.js <<'JS'
module.exports = {
  apps: [{
    name: 'nyodera',
    script: 'index.js',
    cwd: '$(pwd)',
    env: { NODE_ENV: 'production' }
  }]
};
JS
pm2 start ecosystem.config.js
pm2 save
pm2 startup || true

echo "Deployment complete. Use 'pm2 status' and 'pm2 logs nyodera --lines 200' to inspect the app."
