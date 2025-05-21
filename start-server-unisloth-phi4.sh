#! /bin/bash
##
export LLAMA_CPP_EXTRA_OPTIONS="--jinja"
./start-server.sh \
    "$HOME/models/unsloth/phi-4/phi-4-Q5_K_M.gguf"

exit 0;
