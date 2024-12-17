#!/bin/bash

MAP_FILE="/etc/nginx/conf.d/tunnel_map.conf"
TMP_FILE="/tmp/tunnel_map.tmp"
NGINX_RELOAD_REQUIRED=false

MIN_UID=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)

netstat -tulnp 2>/dev/null | grep 'sshd:' | awk -v min_uid="$MIN_UID" -v domain="$GGWP_DOMAIN" '
    $1 == "tcp" && $6 == "LISTEN" && $4 ~ /0.0.0.0:/ {
        split($7, proc, "/")
        pid = proc[1]
        if (pid != "" && system("test $(ps -o uid= -p " pid ") -ge " min_uid) == 0) {
            split($4, addr, ":")
            port = addr[2]
            user = $8
            print user "." domain " 127.0.0.1:" port ";"
        }
    }
' | sort > "$TMP_FILE"

if [ ! -f "$MAP_FILE" ] || ! cmp -s "$TMP_FILE" "$MAP_FILE"; then
    mv "$TMP_FILE" "$MAP_FILE"
    NGINX_RELOAD_REQUIRED=true
fi

if [ "$NGINX_RELOAD_REQUIRED" = true ]; then
    nginx -s reload
fi
