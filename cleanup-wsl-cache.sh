#!/bin/bash
# Force the kernel to empty the buff/cache
# Without this on WSL (currently kernel 5.15.153.1)
# large files will fill the buffer OOM crashes the VM.

# free -h
echo 1 | sudo tee /proc/sys/vm/drop_caches > /dev/null
# free -h
