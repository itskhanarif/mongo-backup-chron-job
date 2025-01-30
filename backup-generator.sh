#!/bin/bash

# Script Variables
DB_NAME="myDB"
BUCKET_NAME="mongodb-backup-bucket-arif" # Replace with your S3 bucket name
BACKUP_DIR="/tmp/mongo_backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$TIMESTAMP.gz"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Perform the MongoDB backup
echo "Creating backup for database: $DB_NAME..."
mongodump --db="$DB_NAME" --archive="$BACKUP_FILE" --gzip
if [ $? -eq 0 ]; then
    echo "Backup created successfully: $BACKUP_FILE"
else
    echo "Error creating backup. Exiting."
    exit 1
fi

# Upload the backup to S3
echo "Uploading backup to S3: s3://$BUCKET_NAME/..."
aws s3 cp "$BACKUP_FILE" "s3://$BUCKET_NAME/"
if [ $? -eq 0 ]; then
    echo "Backup uploaded successfully."
else
    echo "Error uploading backup to S3. Exiting."
    exit 1
fi

# Cleanup old backups (optional: keep backups for the last 1 day)
find "$BACKUP_DIR" -type f -mtime +1 -exec rm -f {} \;
echo "Old backups cleaned up."

echo "Backup process completed successfully!"
