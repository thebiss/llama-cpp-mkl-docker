#!/bin/bash
# free -h
echo 1 | sudo tee /proc/sys/vm/drop_caches
# free -h
