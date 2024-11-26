#!/bin/bash
set -euo pipefail


./docker-build-onemkl-cpu.sh
./docker-build-sycl-gpu.sh
./docker-build-vulkan.sh
