#!/bin/bash
set -euo pipefail


./docker-build-cpu-onemkl.sh
./docker-build-gpu-sycl.sh

# unused, save the time and space
# ./docker-build-gpu-vulkan.sh
