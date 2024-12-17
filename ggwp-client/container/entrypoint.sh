#!/bin/bash
if [ -z "$GGWP_AUTH" ]; then
    echo "Missing GGWP_AUTH"
    exit 1
fi
if [ -z "$GGWP_TARGET" ]; then
    echo "Missing GGWP_TARGET"
fi

CLIENT_USER=$(echo "$GGWP_AUTH" | cut -d':' -f1 | cut -d'.' -f1)
CLIENT_SUBDOMAIN=$(echo "$GGWP_AUTH" | cut -d':' -f1)
CLIENT_PASSWORD=$(echo "$GGWP_AUTH" | cut -d':' -f2)

if [[ -z "$CLIENT_SUBDOMAIN" || -z "$CLIENT_PASSWORD" ]]; then
    echo "Invalid GGWP_AUTH format. Expected: subdomain:password"
    exit 1
fi

if [ -z "$GGWP_TARGET" ]; then
    echo "GGWP_TARGET must be specified (host:port)."
    exit 1
fi

if [[ $GGWP_TARGET != *":"* ]]; then
    GGWP_TARGET="$GGWP_TARGET:80"
fi

if [ -z "$GGWP_HOST" ]; then
    GGWP_HOST="$CLIENT_SUBDOMAIN"
fi

if [[ $GGWP_HOST == *":"* ]]; then
    CLIENT_SSH_PORT=$(echo "$GGWP_HOST" | cut -d':' -f2)
    GGWP_HOST=$(echo "$GGWP_HOST" | cut -d':' -f1)
fi

if [ -z "$CLIENT_SSH_PORT" ]; then
    CLIENT_SSH_PORT=2222
fi

echo "Opening SSH reverse tunnel from $CLIENT_SUBDOMAIN to $GGWP_TARGET..."

sshpass -p "$CLIENT_PASSWORD" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR \
    -N -R 0:$GGWP_TARGET -p $CLIENT_SSH_PORT "$CLIENT_USER@$GGWP_HOST"
