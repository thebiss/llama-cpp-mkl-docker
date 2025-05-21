#!/bin/bash
set -euo pipefail


./docker-build-cpu-onemkl.sh
./docker-build-gpu-sycl.sh
./docker-build-gpu-vulkan.sh
