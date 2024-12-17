#!/bin/bash

DATA_DIR="/var/ggwp/data"
USER_FILE="$DATA_DIR/users.txt"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME=$1

if [ "$USERNAME" = "root" ]; then
    echo "Invalid username."
    exit 1
fi

mkdir -p "$DATA_DIR"
touch "$USER_FILE"

if id "$USERNAME" >/dev/null 2>&1; then
    echo "$USERNAME already exists. Reset auth? (y/n)"
    read -r RESET
    if [ "$RESET" != "y" ]; then
        exit 0
    fi
else
    useradd -m -s /usr/sbin/nologin "$USERNAME"
fi

PASSWORD=$(openssl rand -hex 16)
echo "$USERNAME:$PASSWORD" | chpasswd

if grep -q "^$USERNAME:" "$USER_FILE"; then
    sed -i "s|^$USERNAME:.*|$USERNAME:$PASSWORD|" "$USER_FILE"
else
    echo "$USERNAME:$PASSWORD" >> "$USER_FILE"
fi

echo "Auth Code:"
echo "$USERNAME.$GGWP_DOMAIN:$PASSWORD"
