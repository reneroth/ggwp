#!/bin/bash
USER_FILE="/var/ggwp/data/users.txt"

[ -f "$USER_FILE" ] && while IFS=: read -r USERNAME PASSWORD; do
    id "$USERNAME" >/dev/null 2>&1 || useradd -m -s /usr/sbin/nologin "$USERNAME" && echo "$USERNAME:$PASSWORD" | chpasswd
done < "$USER_FILE"

sed "s/\${DOMAIN}/$GGWP_DOMAIN/g" /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

while true; do
    /update_nginx_tunnel_map.sh
    sleep 5
done &

/usr/sbin/sshd -D -e &
nginx -g "daemon off;"
