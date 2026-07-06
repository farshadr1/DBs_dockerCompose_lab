#!/bin/bash

# This script is used to restore MonogDB backup

#######################################
## Written by:
## FarshadRavaee@gmail.com (2026-07-05)
#######################################

source ../.env

echo "Restoring MongoDB database..."

container_name="mongodb-mongodb-1"

# Check if the container is healthy
status=$(docker inspect \
    --format='{{.State.Health.Status}}' \
    "$container_name" 2>/dev/null)

if [ "$status" != "healthy" ]; then
    echo "Error: Container '$container_name' is not healthy."
    exit 1
fi

# Check backup exists
if [ ! -d "./backups/backup" ]; then
    echo "Error: Backup directory not found."
    exit 1
fi

# Copy backup into the container
if ! docker cp ./backups/backup "$container_name":/tmp/backup
then
    echo "Error: Failed to copy backup into container."
    exit 1
fi

# Restore database
if ! docker exec "$container_name" mongorestore \
    --username "$MONGODB_INITDB_ROOT_USERNAME" \
    --password "$MONGODB_INITDB_ROOT_PASSWORD" \
    --authenticationDatabase admin \
    /tmp/backup
then
    echo "Error: Failed to restore MongoDB database."
    exit 1
fi

echo "MongoDB restore completed successfully."