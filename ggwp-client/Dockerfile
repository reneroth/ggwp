FROM alpine:latest

# Install required tools: SSH, sshpass, and bash
RUN apk add --no-cache openssh-client sshpass bash

# Copy the tunnel script
COPY container/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default entrypoint
ENTRYPOINT ["/entrypoint.sh"]
