# Note: This is a learning exercise  

You probably want the [dockerfiles in the llama.cpp devops tools.](https://github.com/ggerganov/llama.cpp/tree/master/.devops)


# Build Containerized LLAMA.CPP for Intel CPUs with MKL, "From Scratch"

Builds [llama.cpp](https://github.com/ggerganov/llama.cpp) using the [containerized Intel OneAPI MKL library](https://www.intel.com/content/www/us/en/developer/articles/technical/how-to-guide-for-docker-wsl-oneapi-workloads.html) for optimized operation on CPU-only machines. 

Once warm, Mistral achieves ~6.8 tokens/second on Intel Core(TM) i5-1135G7 @ 2.40GHz, with 32GB ram.

## Step 1: Build the container

Run `docker-build.sh`, where the `LLAMACPP_VER` variable is set to the preferred release tag. 

### Option 1: Use the default commit
```bash
 ./docker-build.sh
```

### Option 2: Use a specific commit
```bash
export LLAMACPP_VER=b3472 && ./docker-build.sh
```


## Step 2: Run container

### Option 1: Use a specific model
```bash
export LLAMA_MODEL_GGUF=/var/model/llama3.gguf && ./start-server.sh
```

### Option 2: Use the default models
```bash
./start-server.sh
```

### Assumptions

These scripts use defaults set for me:
- Models are in folder `~/dev-in-wsl/models`
- `mistral-7b-instruct-v0.2.Q5_K_M.gguf` is available
- CPU has 8 threads, assigns all 8



# Known Issue & Fix - WSL Buffer/Cache Exhausted
Under WSL2, running then stopping this container multiple times will cause WSL to stop the VM, due to kernel buffer/cache quickly exceeding the memory limits for WSL.

This is because each model is 6-8 GB, and [WSL "doesn't free the page cache until the Linux frees it." (Microsoft)](https://devblogs.microsoft.com/commandline/memory-reclaim-in-the-windows-subsystem-for-linux-2/)

The work around is to [force it to be freed. (Kernel docs)](https://www.kernel.org/doc/Documentation/sysctl/vm.txt#:~:text=%3D%3D-,drop_caches,-Writing%20to%20this)

### Fix part one: Increase the WSL memory limit
- Edit `%USERPROFILE%/.wslconfig`
- Set it to 24GB - or whatever your system allows.
- Restart WSL.

### Fix part two: Drop caches between runs
- Run: `echo 1 | sudo tee /proc/sys/vm/drop_caches` after _every  run_.

