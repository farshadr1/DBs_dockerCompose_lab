#!/bin/bash

# This script is used to backup the MongoDB database
# Requires MongoDB Database Tools

#######################################
## Writen by:
## FarshadRavaee@gmail.com (2026-07-05)
#######################################

source ../.env

echo "Backing up MongoDB database..."
container_name="mongodb-mongodb-1"

# chenck if the container is running
container=$(docker ps --filter "name=$container_name" --filter "health=healthy" --quiet)

if [ -z "$container" ]; then
    echo "Container is not running or not healthy."
    exit 1
fi

# use mongodump to backup
if ! docker exec $container_name mongodump \
  --username $MONGODB_INITDB_ROOT_USERNAME \
  --password $MONGODB_INITDB_ROOT_PASSWORD \
  --authenticationDatabase admin \
  --out /tmp/backup
then
  echo "Error: Failed to backup MongoDB database."
  exit 1
fi

# copy backup from container to host
if ! docker cp $container_name:/tmp/backup ./backups
then
  echo "Error: Failed to copy backup from container to host."
  exit 1
fi