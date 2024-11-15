#!/usr/bin/bash

# vainfo 2>&1 | sed -e 's/^/vainfo:\t/'
glxinfo -B 2>&1 | sed -e 's/^/glxinfo:\t/'
vulkaninfo --summary 2>&1 | sed -e 's/^/vulkaninfo:\t/'
clinfo 2>&1 | grep -A 10 "Device Type" | sed -e 's/^/clinfo:\t/'
sycl-ls 2>&1 | sed -e 's/^/sycl-ls:\t/'
./git/build/bin/llama-ls-sycl-device 2>&1 | sed -e 's/^/llama-ls-sycl-device:\t/'
