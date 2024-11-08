#!/bin/bash
set -euo pipefail

./docker-build-intel-mkl.sh \
    && ./docker-build-gpu.sh \
    && ./docker-build-vulkan.sh
