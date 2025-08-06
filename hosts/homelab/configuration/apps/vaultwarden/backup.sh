#!/usr/bin/env bash

# Allow use of !() when copying to not copy certain files
shopt -s extglob

# Get the script name without the path
SCRIPT_NAME=$(basename "$0")

# Function to display help message
show_help() {
	cat <<EOF
Usage: $SCRIPT_NAME [OPTIONS]

Backup Vaultwarden data to timestamped tar.gz archives.

OPTIONS:
  --backup-dir PATH     Directory where backups will be stored
  --data-dir PATH    Vaultwarden data directory to backup
  -h, --help           Show this help message

ENVIRONMENT VARIABLES:
  BACKUP_FOLDER        Fallback for --backup-dir
  DATA_FOLDER          Fallback for --data-dir

EXAMPLES:
  $SCRIPT_NAME --backup-dir /backups --data-dir /data
  BACKUP_FOLDER=/backups DATA_FOLDER=/data $SCRIPT_NAME

The script creates backups named 'vaultwarden-YYYYMMDD_HHMMSS.tar.gz'
and automatically removes backups older than 30 days if successful.
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
	case $1 in
	--backup-dir)
		BACKUP_FOLDER="$2"
		shift 2
		;;
	--data-dir)
		DATA_FOLDER="$2"
		shift 2
		;;
	-h | --help)
		show_help
		exit 0
		;;
	*)
		echo "Unknown option: $1" >&2
		show_help
		exit 1
		;;
	esac
done

# Check if required parameters are provided
if [ -z "$BACKUP_FOLDER" ] || [ -z "$DATA_FOLDER" ]; then
	echo "Error: Both --backup-dir and --data-dir must be specified (or set via environment variables)" >&2
	show_help
	exit 1
fi

# Based on: https://github.com/dani-garcia/vaultwarden/wiki/Backing-up-your-vault
if [ ! -d "$BACKUP_FOLDER" ]; then
	echo "Backup folder '$BACKUP_FOLDER' does not exist" >&2
	exit 1
fi

if [ ! -d "$DATA_FOLDER" ]; then
	echo "No data folder (yet). This will happen on first launch if backup is triggered before vaultwarden has started."
	exit 0
fi

# Create timestamp for backup filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="vaultwarden-${TIMESTAMP}.tar.gz"
TEMP_BACKUP_DIR="/tmp/vaultwarden-backup"

# Create and clean temp directory
rm -rf "$TEMP_BACKUP_DIR"
mkdir -p "$TEMP_BACKUP_DIR"

# Backup SQLite database if it exists
if [[ -f "$DATA_FOLDER"/db.sqlite3 ]]; then
	sqlite3 "$DATA_FOLDER"/db.sqlite3 ".backup '$TEMP_BACKUP_DIR/db.sqlite3'"
fi

# Copy other data files (excluding db.* files)
cp -r "$DATA_FOLDER"/!(db.*) "$TEMP_BACKUP_DIR"/ 2>/dev/null || true

# Check if there is anything to backup
if [ -z "$(ls -A "$TEMP_BACKUP_DIR")" ]; then
	echo "Warning: Temporary backup directory '$TEMP_BACKUP_DIR' is empty. Skipping backup creation." >&2
else
	# Create tar.gz archive
	tar -czf "$BACKUP_FOLDER/$BACKUP_NAME" -C "$TEMP_BACKUP_DIR" .
	echo "Backup created: $BACKUP_NAME"
	# Remove backups older than 30 days
	find "$BACKUP_FOLDER" -name "vaultwarden-*.tar.gz" -type f -mtime +30 -delete
	echo "Old backups (>30 days) removed"
fi

# Clean up temporary directory
rm -rf "$TEMP_BACKUP_DIR"
