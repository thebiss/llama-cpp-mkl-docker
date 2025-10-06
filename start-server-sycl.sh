#! /bin/bash
##
##
## Runs the containerized llama-server using a specified or default model
##
##
set -euo pipefail

# Run the container
DOCKER_RUN_ARGS="\
    --device=/dev/dxg \
    --group-add video \
    --volume /mnt/wslg:/mnt/wslg \
    --volume /usr/lib/wsl:/usr/lib/wsl \
    --volume /usr/lib/x86_64-linux-gnu/dri:/usr/lib/x86_64-linux-gnu/dri"
   
DOCKER_IMAGE_NAME="localhost/thebiss/llama-cpp-mkl-gpu:latest"

source ./start-server.sh
