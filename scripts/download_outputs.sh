#!/bin/bash

LOCAL_DIR="/Users/johannkaspar/Projects/voice_biomarker/outputs"
REMOTE_DIR="ChariteTeams:/General/Outputs"

echo "Copying files from $LOCAL_DIR to $REMOTE_DIR..."
if rclone copy "$REMOTE_DIR" "$LOCAL_DIR" --verbose; then
    echo "Copy completed successfully."
else
    echo "Error during rclone copy." >&2
    exit 1
fi
