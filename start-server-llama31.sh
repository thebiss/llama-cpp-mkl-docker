#! /bin/bash
##
## Runs the containerized llama-3.1, with a reduced context
##
set -x
env LLAMA_ARG_CTX_SIZE=50000 \
    ./start-server.sh ../models/Meta-Llama-3.1-8B-Instruct-Q5_K_M.gguf

exit 0;
