#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /sempoa/tmp/pids/server.pid

mkdir -p /sempoa/public/packs
mkdir -p /sempoa/public/assets
# rake production_asset_manifest:get

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

