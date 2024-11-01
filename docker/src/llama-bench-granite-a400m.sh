#!/bin/bash
set +x
./git/build/bin/llama-bench -p 10 -n 10 -r 10 -m /var/models/ibm/granite-3.0/granite-3.0-1b-a400m-instruct-Q8_0.gguf
