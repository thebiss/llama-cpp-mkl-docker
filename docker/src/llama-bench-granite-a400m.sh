#!/bin/bash
set -x
LLAMA_BENCH_OPTS="${LLAMA_BENCH_OPTS:-}"
echo "Additional parameters from \$LLAMA_BENCH_OPTS: ${LLAMA_BENCH_OPTS}"
MODEL="/var/models/ibm/granite-3.0/granite-3.0-1b-a400m-instruct-Q8_0.gguf"
./git/build/bin/llama-bench -p 10 -n 10 -r 10 -m ${MODEL} ${LLAMA_BENCH_OPTS}
# noticed gg requested this test in #10455
./git/build/bin/llama-bench -p 1,1,2,3,4,5,6,7,8,12,16,32 -n 0 -r 20 -m ${MODEL} -fa 1 ${LLAMA_BENCH_OPTS}

