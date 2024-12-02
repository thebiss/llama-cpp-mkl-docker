#!/bin/bash

# Tips from: https://github.com/microsoft/wslg/issues/531
# and https://github.com/jnewb1/vgpu-docker-wslg-testing 

# Lessons learned
# - must passthrough the directx device and dri's 
# - user must be in the video group, render group not needed, does not need root
# - needs /usr/lib/wsl

# free buffers
./cleanup-wsl-cache.sh

MODELDIR="$(realpath ../models)"
MODELNAME="ibm/granite-3.0/granite-3.0-8b-instruct-Q4_K_M.gguf"

set -x
docker run -p 8080:8080 \
    --volume "${MODELDIR}:/models:ro" \
    ghcr.io/ggerganov/llama.cpp:server-intel \
    -m "/models/${MODELNAME}" \
    --host 0.0.0.0 \
    --port 8080
