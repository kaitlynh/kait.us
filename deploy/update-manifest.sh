#!/bin/bash
# Regenerates the third-party manifest from the current live site.
# Run on the server; commits nothing itself.
set -e
cd "$(dirname "$0")/.."
wp plugin list --fields=name,version,status --format=csv > deploy/third-party-plugins.csv
wp theme list --fields=name,version,status --format=csv > deploy/third-party-themes.csv
wp core version > deploy/wp-core-version.txt
echo "Manifest updated."
