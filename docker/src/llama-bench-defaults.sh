#!/bin/bash

LLAMA_BENCH_OPTS="${LLAMA_BENCH_OPTS:-}"
echo "Additional parameters from \$LLAMA_BENCH_OPTS: ${LLAMA_BENCH_OPTS}"

# llama-bench -p 10 -n 10 -r 10 -fa 1 ${LLAMA_BENCH_OPTS}
# noticed gg requested this test in #10455
set -x
llama-bench -p 1,1,2,3,4,5,6,7,8,12,16,32 -n 0 -r 20 -fa 1 ${LLAMA_BENCH_OPTS} -m ${LLAMA_ARG_MODEL}

