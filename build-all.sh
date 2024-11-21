#!/bin/bash
set -euo pipefail

[ -z "$(which figlet)" ] || figlet CPU - Intel OneAPI MKL
./docker-build-onemkl-cpu.sh

[ -z "$(which figlet)" ] || figlet GPU - Intel OneAPI SYCL
./docker-build-sycl-gpu.sh

[ -z "$(which figlet)" ] || figlet GPU - Vulkan
./docker-build-vulkan.sh
