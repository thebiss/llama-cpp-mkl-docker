#! /bin/bash
##
## Runs the containerized llama-3.1, with a reduced context
##

env LLAMA_ARG_CTX_SIZE=44000 \
    ./start-server.sh \
    "$HOME/models/meta/llama-3.2/llama-3.2-3b-instruct-q8_0.gguf"

exit 0;
