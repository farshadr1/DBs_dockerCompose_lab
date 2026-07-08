#!/bin/bash

# This script is used to backup the MongoDB database
# Requires MongoDB Database Tools

#######################################
## Writen by:
## FarshadRavaee@gmail.com (2026-07-05)
#######################################

set -euo pipefail

# check the number of command-line arguments passed
if [ $# -ne 1 ]; then
    echo "Usage: $0 <backup-directory>"
    exit 1
fi

mongorestore \
  --host mongodb \
  --username "$MONGO_INITDB_ROOT_USERNAME" \
  --password "$MONGO_INITDB_ROOT_PASSWORD" \
  --authenticationDatabase admin \
  --drop "/backup_files/$1"

if [ $? -eq 0 ]; then
  echo "Backup restored"
else
  echo "Error: Backup not restored!"
fi  