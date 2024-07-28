## Build Containerized LLAMA.CPP for Intel CPUs with MKL, "From Scratch"

Builds [llama.cpp](https://github.com/ggerganov/llama.cpp) using the [containerized Intel OneAPI MKL library](https://www.intel.com/content/www/us/en/developer/articles/technical/how-to-guide-for-docker-wsl-oneapi-workloads.html) for optimized operation on CPU-only machines. 


Mistral achieves ~7 tokens/second on Intel Core(TM) i5-1135G7 @ 2.40GHz, with 32GB ram.

## Step 1: Build the container

Run `build.sh`, where the `LLAMACPP_VER` variable is set to the preferred release tag. 

### Option 1: Use the default commit
Uses commit tagged `#b3467` by default
```bash
 ./build.sh
```

### Option 2: Use a specific commit
```bash
export LLAMACPP_VER=b3472 && ./build.sh
```


## Step 2: Run container

### Option 1: Use a specific model
```bash
export LLAMA_MODEL_GGUF=/var/model/llama3.gguf && ./run.sh
```

### Option 2: Use the default models
```bash
./run.sh
```

Defaults are set for me, and assumes:
- Models are in folder `~/dev-in-wsl/models`
- `mistral-7b-instruct-v0.2.Q5_K_M.gguf` is available
- CPU has 8 threads, assigns 7

