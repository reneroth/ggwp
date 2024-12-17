FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
  openssh-server \
  nginx \
  bash \
  curl \
  net-tools \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash ggwp

COPY container/sshd_config /etc/ssh/sshd_config
RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd

COPY container/update_nginx_tunnel_map.sh /update_nginx_tunnel_map.sh
RUN chmod +x /update_nginx_tunnel_map.sh

COPY container/nginx.conf.template /etc/nginx/nginx.conf.template
RUN touch /etc/nginx/conf.d/tunnel_map.conf

COPY container/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY container/create-user.sh /usr/local/bin/ggwp-create-user
RUN chmod +x /usr/local/bin/ggwp-create-user

RUN mkdir -p /var/ggwp/data

ENTRYPOINT ["/entrypoint.sh"]
