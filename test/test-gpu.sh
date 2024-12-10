#!/bin/bash

# Tips from: https://github.com/microsoft/wslg/issues/531
# and https://github.com/jnewb1/vgpu-docker-wslg-testing 

# Lessons learned
# - must passthrough the directx device and dri's 
# - user must be in the video group, render group not needed, does not need root
# - needs /usr/lib/wsl

# free buffers
../cleanup-wsl-cache.sh

MODELDIR="$(realpath ../../models)"

# 7 Nov -remove extraneous mounts and vars

# Run the container
set -x
docker run -it --rm \
    --device=/dev/dxg \
    --device=/dev/dri/card0 \
    --device=/dev/dri/renderD128 \
    -v /usr/lib/wsl:/usr/lib/wsl \
    \
    --publish 8080:8080 \
    --volume "${MODELDIR}:/var/models:ro" \
    bbissell/llama-cpp-mkl-gpu:latest \
    /bin/bash

    # -v /usr/lib/x86_64-linux-gnu/dri:/usr/lib/x86_64-linux-gnu/dri \