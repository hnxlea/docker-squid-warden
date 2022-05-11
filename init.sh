#!/bin/bash

# Deploy container-web-tty in remote servers
# https://github.com/wrfly/container-web-tty#using-local---remote-grpc

bash -c docker run -dti --restart always --name container-web-tty \
    -p 80:8080 \
    -p 8090:8090 \
    -e WEB_TTY_GRPC_PORT="$WEB_TTY_GRPC_PORT" \
    -e WEB_TTY_GRPC_AUTH="$WEB_TTY_GRPC_AUTH" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    wrfly/container-web-tty

# Deploy squid-container 
# https://hub.docker.com/r/ubuntu/squid

bash -c docker run -d --name squid-container \
    -e TZ=UTC \
    -p 3128:3128 \
    ubuntu/squid

## pevious deploy command
## slight edit to the command invoking the interactive shell (which can be found in Testing/Debugging):
## $ docker exec -it squid-container /bin/bash

# bash -c squid-container /bin/bash
