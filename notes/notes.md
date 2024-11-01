## Vulkan Support

### RUNS: Granite 3.0 1B, A400M Q8
MoE model
```
/home/llamauser/git/build/bin/llama-server --threads 8 --host 0.0.0.0 --port 8080 --keep -1 --predict -1 --temp 0.4 --top-k 40 --top-p 0.95 --min-p 0.05 --repeat-penalty 256 -ngl 99 -m /var/models/granite-3.0-1b-a400m-instruct-Q8_0.gguf
```

```
llm_load_tensors: ggml ctx size =    0.22 MiB
llm_load_tensors: offloading 24 repeating layers to GPU
llm_load_tensors: offloading non-repeating layers to GPU
llm_load_tensors: offloaded 25/25 layers to GPU
llm_load_tensors:    Vulkan0 buffer size =  1354.69 MiB
llm_load_tensors:        CPU buffer size =    51.00 MiB
...............................................................................
llama_new_context_with_model: n_ctx      = 4096
llama_new_context_with_model: n_batch    = 2048
llama_new_context_with_model: n_ubatch   = 512
llama_new_context_with_model: flash_attn = 0
llama_new_context_with_model: freq_base  = 10000.0
llama_new_context_with_model: freq_scale = 1
llama_kv_cache_init:    Vulkan0 KV buffer size =   192.00 MiB
llama_new_context_with_model: KV self size  =  192.00 MiB, K (f16):   96.00 MiB, V (f16):   96.00 MiB
llama_new_context_with_model: Vulkan_Host  output buffer size =     0.38 MiB
llama_new_context_with_model:    Vulkan0 compute buffer size =   144.00 MiB
llama_new_context_with_model: Vulkan_Host compute buffer size =    10.01 MiB
llama_new_context_with_model: graph nodes  = 1472
llama_new_context_with_model: graph splits = 2
common_init_from_params: warming up the model with an empty run - please wait ... (--no-warmup to disable)
srv          init: initializing slots, n_slots = 1
slot         init: id  0 | task -1 | new slot n_ctx_slot = 4096
main: model loaded
```

### FAILS: Granite 3B, q8 

```
/home/llamauser/git/build/bin/llama-server --threads 8 --host 0.0.0.0 --port 8080 --keep -1 --predict -1 --temp 0.4 --top-k 40 --top-p 0.95 --min-p 0.05 --repeat-penalty 256 -ngl 99 -m /var/models/granite-3b-code-instruct.Q8_0.gguf
```

```
...............................................................................................
llama_new_context_with_model: n_ctx      = 2048
llama_new_context_with_model: n_batch    = 2048
llama_new_context_with_model: n_ubatch   = 512
llama_new_context_with_model: flash_attn = 0
llama_new_context_with_model: freq_base  = 10000.0
llama_new_context_with_model: freq_scale = 1
llama_kv_cache_init:    Vulkan0 KV buffer size =   640.00 MiB
llama_new_context_with_model: KV self size  =  640.00 MiB, K (f16):  320.00 MiB, V (f16):  320.00 MiB
llama_new_context_with_model: Vulkan_Host  output buffer size =     0.38 MiB
llama_new_context_with_model:    Vulkan0 compute buffer size =   152.00 MiB
llama_new_context_with_model: Vulkan_Host compute buffer size =     9.01 MiB
llama_new_context_with_model: graph nodes  = 1254
llama_new_context_with_model: graph splits = 2
common_init_from_params: warming up the model with an empty run - please wait ... (--no-warmup to disable)
D3D12: Removing Device.
terminate called after throwing an instance of 'vk::OutOfDeviceMemoryError'
  what():  vk::Device::createDescriptorPool: ErrorOutOfDeviceMemory
```


## Current running version
    6153dacbaac2
    https://github.com/ggerganov/llama.cpp/releases/tag/b3423

#  docker build -t bbissell/llama-cpp-mkl:b3467

docker run -v $HOME/dev-in-wsl/models:/var/models -p 127.0.0.1:8080:8080 bbissell/llama-cpp-mkl:b3467 