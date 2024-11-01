#!/bin/bash

# free buffers
./cleanup-wsl-cache.sh

MODELDIR="$(realpath ../models)"

# Run the container
set -x
docker run -it --rm \
    --name "test-llama-cpp-intelmkl" \
    --volume "${MODELDIR}:/var/models:ro" \
    bbissell/llama-cpp-mkl:latest \
    /bin/bash

exit 0;
