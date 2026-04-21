#!/bin/bash
# Takes a timestamped DB + files backup to ~/backups/rotating/.
# Keeps the most recent 7 of each. Baseline backups (kait.us-*-pre-migration-*)
# live in ~/backups/ directly and are never rotated.
#
# Usage (on the server):
#   bash ~/kait.us/deploy/backup.sh

set -e

STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$HOME/backups/rotating"
SITE_DIR="$HOME/kait.us"
KEEP=7

mkdir -p "$BACKUP_DIR"
cd "$SITE_DIR"

wp db export "$BACKUP_DIR/db-$STAMP.sql" --add-drop-table > /dev/null
tar -czf "$BACKUP_DIR/files-$STAMP.tar.gz" -C "$HOME" kait.us 2>/dev/null

cd "$BACKUP_DIR"
ls -t db-*.sql    2>/dev/null | tail -n +$((KEEP+1)) | xargs -r rm --
ls -t files-*.tar.gz 2>/dev/null | tail -n +$((KEEP+1)) | xargs -r rm --

echo "Backup written: $BACKUP_DIR/{db,files}-$STAMP"
