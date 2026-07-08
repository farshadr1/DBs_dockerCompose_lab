#!/bin/bash

# This script is used to backup the MongoDB database
# Requires MongoDB Database Tools

#######################################
## Writen by:
## FarshadRavaee@gmail.com (2026-07-05)
#######################################

#-------------
#set -euo pipefail enables three useful Bash safety features:
#-e: exit immediately if a command fails.
#-u: treat the use of an unset variable as an error.
#-o pipefail: make a pipeline fail if any command in it fails, not just the last one.
#-------------
set -euo pipefail

STAMP=$(date +%F-%R)
DEST="/backup_files/$STAMP"

mkdir -p "$DEST"

mongodump \
  --host mongodb \
  --username "$MONGODB_INITDB_ROOT_USERNAME" \
  --password "$MONGODB_INITDB_ROOT_PASSWORD" \
  --authenticationDatabase admin \
  --out "$DEST"

if [ $? -eq 0 ]; then
  echo "Backup created in $DEST"
else
  echo "Error: Backup not created!"
fi