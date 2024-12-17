# ggwp

good game, well proxied

PoC of simple self-hosted & high-portability reverse proxy for HTTP requests _into docker containers_, so devs can e.g. test webhooks locally with a static domain

unsorted, uncleaned, all a bit messy. the docker-compose files are mostly for testing.

## HOST

- put your domain in the `GGWP_DOMAIN` env variable, e.g. by using `.env` file
- point your subdomain to the host, best to use a wildcard. e.g. if you put `dev.example.com` in `GGWP_DOMAIN`, point `*.dev.example.com` to the host
- start host container. it needs `SYS_PTRACE` capability (or use `--privileged`)
- open shell into container
- run `ggwp-create-user your-username`
- store the generated string or send it to your dev

## CLIENT

- put the string from above into `GGWP_AUTH` env var
- put the target domain (and port if applicable) into `GGWP_TARGET` env var
- if you want to, you can set a different host in `GGWP_HOST` (e.g. for the port)
- client needs to have access to the target, so either put the client in the same network as the target or use `--network host` and use `host.docker.internal` (see example code)

## TODO

- better security against brute force attacks (fail2ban etc)
- optional SSH key auth
- more resilient handling of dropped connections
- optional SSL
