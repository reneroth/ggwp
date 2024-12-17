#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Usage: $0 <subdomain:password>"
    exit 1
fi

AUTH_CODE=$1

USER=$(echo "$AUTH_CODE" | cut -d':' -f1 | cut -d'.' -f1)
SUBDOMAIN=$(echo "$AUTH_CODE" | cut -d':' -f1)
PASSWORD=$(echo "$AUTH_CODE" | cut -d':' -f2)

if [[ -z "$SUBDOMAIN" || -z "$PASSWORD" ]]; then
    echo "Invalid auth code format. Expected: subdomain:password"
    exit 1
fi

echo "Opening SSH reverse tunnel for $USER..."

# todo: test data
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -N -R 0:localhost:9000 -p 22 "$USER@localhost"
