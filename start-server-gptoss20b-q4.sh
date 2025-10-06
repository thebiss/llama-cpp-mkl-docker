#! /bin/bash
##

# Unsloth and OpenAPI reccomended settings 
# from https://docs.unsloth.ai/basics/gpt-oss-how-to-run-and-fine-tune#run-gpt-oss-20b
export LLAMA_CPP_EXTRA_OPTIONS="--jinja --threads -2 --temp 1.0 --top-p 1.0 --top-k 0"

./start-server.sh \
    "$HOME/models/unsloth/gpt-oss/gpt-oss-20b-Q4_K_M.gguf"

exit 0;
