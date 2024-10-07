
#!/usr/bin/bash

# echo everything!
set -x

vainfo
glxinfo -B
vulkaninfo --summary
clinfo | grep -A 10 "Device Type"
sycl-ls

