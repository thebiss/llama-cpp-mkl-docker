#!/bin/bash

# Tips from: https://github.com/microsoft/wslg/issues/531
# and https://github.com/jnewb1/vgpu-docker-wslg-testing 

# Lessons learned
# - must passthrough the directx device and dri's 
# - user must be in the video group, render group not needed, does not need root
# - needs /usr/lib/wsl

# free buffers
../cleanup-wsl-cache.sh

source test-settings.sh
export LLAMA_ARG_MODEL="/models/${MODELNAME}"

set -x
docker run -p 8080:8080 \
    --host 0.0.0.0 \
    --port 8080 \
    \
    --volume "${MODELDIR}:/models:ro" \
    --env "LLAMA_BENCH_OPTS" \
    --env "LLAMA_ARG_MODEL" \
    --name "test-llamacpp-gg" \
    ghcr.io/ggerganov/llama.cpp:server-intel
