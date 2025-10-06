#!/usr/bin/bash

which -s glxinfo    && glxinfo -B 2>&1 | sed -e 's/^/glxinfo:\t/'
which -s vulkaninfo && vulkaninfo --summary 2>&1 | sed -e 's/^/vulkaninfo:\t/'
which -s clinfo     && clinfo 2>&1 | grep -A 10 "Device Type" | sed -e 's/^/clinfo:\t/'
which -s syscl-ls   && sycl-ls 2>&1 | sed -e 's/^/sycl-ls:\t/'
