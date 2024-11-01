#!/usr/bin/bash

vainfo 2>&1 | sed -e 's/^/vainfo:\t/'
glxinfo -B 2>&1 | sed -e 's/^/glxinfo:\t/'
vulkaninfo --summary 2>&1 | sed -e 's/^/vulkaninfo:\t/'
clinfo 2>&1 | grep -A 10 "Device Type" | sed -e 's/^/clinfo:\t/'
sycl-ls 2>&1 | sed -e 's/^/syscl-ls:\t/'
