#! /bin/bash
##
## Runs the containerized llama-3.1, with a reduced context
##

env LLAMA_ARG_CTX_SIZE=44000 \
    ./start-server.sh \
    "$HOME/models/meta/llama-3.1/Meta-Llama-3.1-8B-Instruct-Q6_K.gguf"

exit 0;
