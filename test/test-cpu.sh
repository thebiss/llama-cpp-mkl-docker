#!/bin/bash

# free buffers
../cleanup-wsl-cache.sh

MODELDIR="$(realpath $HOME/models)"

# Run the container
set -x
docker run -it --rm \
    --name "test-llama-cpp-intelmkl" \
    --volume "${MODELDIR}:/var/models:ro" \
    --env LLAMA_BENCH_OPTS="--threads 8" \
    thebiss/llama-cpp-mkl:latest \
    /bin/bash

