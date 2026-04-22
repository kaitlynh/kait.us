#!/bin/bash
# Runs on the server (via cron). Detects any server-side changes
# (plugin/theme auto-updates, manual wp-admin installs, hand-edits)
# and pushes them to GitHub so laptop and repo stay in sync.
#
# Intended crontab:
#   17 * * * * /bin/bash $HOME/kait.us/deploy/server-sync.sh >> $HOME/kait.us/deploy/server-sync.log 2>&1
#
# To force an immediate sync from the laptop:
#   ssh dreamhost 'bash ~/kait.us/deploy/server-sync.sh'
set -e

cd ~/kait.us

# Refresh the manifest so plugin/theme/WP-core version changes are captured.
bash deploy/update-manifest.sh

git add -A
if git diff --cached --quiet; then
  echo "$(date -Iseconds)  no changes"
  exit 0
fi

git commit -m "server: auto-sync $(date -Iseconds)"
git push origin main
echo "$(date -Iseconds)  pushed"
