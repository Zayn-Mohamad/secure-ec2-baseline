#!/bin/bash

# Define log directory and file
LOG_DIR="/var/log/lynis"
LOG_FILE="$LOG_DIR/lynis_$(date +%F).log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Run Lynis audit and log output
/usr/local/lynis/lynis audit system >> "$LOG_FILE" 2>&1

# keep only last 7 logs
find "$LOG_DIR" -type f -name "lynis_*.log" -mtime +7 -exec rm {} \;
