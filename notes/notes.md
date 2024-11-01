## Vulkan Support

### RUNS: Granite 3.0 1B, A400M Q8 MoE model

CLI
```
/home/llamauser/git/build/bin/llama-server --threads 8 --host 0.0.0.0 --port 8080 --keep -1 --predict -1 --temp 0.4 --top-k 40 --top-p 0.95 --min-p 0.05 --repeat-penalty 256 -ngl 99 -m /var/models/granite-3.0-1b-a400m-instruct-Q8_0.gguf
```

llama.cpp output
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

### FAILS on VULKA - OOM: Granite 3B-code-instruct, q8 , non MOE
CLI
```
/home/llamauser/git/build/bin/llama-server --threads 8 --host 0.0.0.0 --port 8080 --keep -1 --predict -1 --temp 0.4 --top-k 40 --top-p 0.95 --min-p 0.05 --repeat-penalty 256 -ngl 99 -m /var/models/granite-3b-code-instruct.Q8_0.gguf
```

llama.cpp output
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



# Accelerate builds by caching APT results
## 1 - save keys
### error
``` 
> [6/9] RUN apt update -y:
0.430
0.430 WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
0.430
0.525 Hit:1 http://security.ubuntu.com/ubuntu jammy-security InRelease
0.656 Hit:2 http://archive.ubuntu.com/ubuntu jammy InRelease
0.687 Get:3 https://packages.lunarg.com/vulkan jammy InRelease
0.729 Hit:4 http://archive.ubuntu.com/ubuntu jammy-updates InRelease
0.809 Hit:5 http://archive.ubuntu.com/ubuntu jammy-backports InRelease
0.821 Err:3 https://packages.lunarg.com/vulkan jammy InRelease
0.821   The following signatures couldn't be verified because the public key is not available: NO_PUBKEY AA8452080E383F7E
0.869 Hit:6 https://ppa.launchpadcontent.net/kisak/kisak-mesa/ubuntu jammy InRelease
1.024 Reading package lists...
1.692 W: http://security.ubuntu.com/ubuntu/dists/jammy-security/InRelease: The key(s) in the keyring /etc/apt/trusted.gpg.d/lunarg-signing-key-pub.asc are ignored as the file is not readable by user '_apt' executing apt-key.
1.692 W: http://archive.ubuntu.com/ubuntu/dists/jammy/InRelease: The key(s) in the keyring /etc/apt/trusted.gpg.d/lunarg-signing-key-pub.asc are ignored as the file is not readable by user '_apt' executing apt-key.
1.692 W: https://packages.lunarg.com/vulkan/dists/jammy/InRelease: The key(s) in the keyring /etc/apt/trusted.gpg.d/lunarg-signing-key-pub.asc are ignored as the file is not readable by user '_apt' executing apt-key.
1.692 W: GPG error: https://packages.lunarg.com/vulkan jammy InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY AA8452080E383F7E
1.692 E: The repository 'https://packages.lunarg.com/vulkan jammy InRelease' is not signed.
1.692 W: http://archive.ubuntu.com/ubuntu/dists/jammy-updates/InRelease: The key(s) in the keyring /etc/apt/trusted.gpg.d/lunarg-signing-key-pub.asc are ignored as the file is not readable by user '_apt' executing apt-key.
1.692 W: http://archive.ubuntu.com/ubuntu/dists/jammy-backports/InRelease: The key(s) in the keyring /etc/apt/trusted.gpg.d/lunarg-signing-key-pub.asc are ignored as the file is not readable by user '_apt' executing apt-key.
1.692 W: https://ppa.launchpadcontent.net/kisak/kisak-mesa/ubuntu/dists/jammy/InRelease: The key(s) in the keyring /etc/apt/trusted.gpg.d/lunarg-signing-key-pub.asc are ignored as the file is not readable by user '_apt' executing apt-key.
```
### fix
- `ADD --chmod=644 ...`


## 2. Use a cache mount for APT runs, > 50% speedup!
### Prep
- 1. Delete docker clean from base image

```
root@410074afa493:/etc/apt/apt.conf.d# ls -l
-rw-r--r-- 1 root root  318 Sep 11 14:07 docker-clean
```

- 2. Add RUN --mount=type=cache lines to dockfile APT calls.



### Test 1 - Empty Cache, 126.8 sec

```
bbissell@IBM-PF2RW5PM:~/dev-in-wsl/llama.cpp.mkl/docker$ docker build . --file test-prep.Dockerfile --tag bbissell/test-prep
[+] Building 126.8s (18/18) FINISHED                                                                                                                                                                                             docker:default
 => [internal] load build definition from test-prep.Dockerfile                                                                                                                                                                             0.0s
 => => transferring dockerfile: 2.31kB                                                                                                                                                                                                     0.0s
 => [internal] load metadata for docker.io/library/ubuntu:jammy                                                                                                                                                                            0.3s
 => [internal] load .dockerignore                                                                                                                                                                                                          0.0s
 => => transferring context: 2B                                                                                                                                                                                                            0.0s
 => [internal] load build context                                                                                                                                                                                                          0.0s
 => => transferring context: 73B                                                                                                                                                                                                           0.0s
 => CACHED [build  1/11] FROM docker.io/library/ubuntu:jammy@sha256:0e5e4a57c2499249aafc3b40fcd541e9a456aab7296681a3994d631587203f97                                                                                                       0.0s
 => => resolve docker.io/library/ubuntu:jammy@sha256:0e5e4a57c2499249aafc3b40fcd541e9a456aab7296681a3994d631587203f97                                                                                                                      0.0s
 => CACHED [build  4/11] ADD --chmod=644 https://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list /etc/apt/sources.list.d/                                                                                                              0.2s
 => CACHED [build  5/11] ADD --chmod=644 https://packages.lunarg.com/lunarg-signing-key-pub.asc /etc/apt/trusted.gpg.d/                                                                                                                    0.2s
 => [build  2/11] RUN rm -f /etc/apt/apt.conf.d/docker-clean                                                                                                                                                                               0.3s
 => [build  3/11] RUN --mount=type=cache,target=/var/cache/apt,sharing=locked     --mount=type=cache,target=/var/lib/apt,sharing=locked     apt update -y &&     apt install -y     software-properties-common                            19.6s
 => [build  4/11] ADD --chmod=644 https://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list /etc/apt/sources.list.d/                                                                                                                     0.0s
 => [build  5/11] ADD --chmod=644 https://packages.lunarg.com/lunarg-signing-key-pub.asc /etc/apt/trusted.gpg.d/                                                                                                                           0.0s
 => [build  6/11] RUN --mount=type=cache,target=/var/cache/apt,sharing=locked     --mount=type=cache,target=/var/lib/apt,sharing=locked     add-apt-repository ppa:kisak/kisak-mesa                                                        4.1s
 => [build  7/11] RUN --mount=type=cache,target=/var/cache/apt,sharing=locked     --mount=type=cache,target=/var/lib/apt,sharing=locked     apt update -y                                                                                  2.2s
 => [build  8/11] RUN --mount=type=cache,target=/var/cache/apt,sharing=locked     --mount=type=cache,target=/var/lib/apt,sharing=locked     apt install -y         git         build-essential         cmake                              10.0s
 => [build  9/11] RUN --mount=type=cache,target=/var/cache/apt,sharing=locked     --mount=type=cache,target=/var/lib/apt,sharing=locked     apt-get install -y         vulkan-sdk         libcurl4-openssl-dev         curl         pciu  84.9s
 => [build 10/11] RUN --mount=type=cache,target=/var/cache/apt,sharing=locked     --mount=type=cache,target=/var/lib/apt,sharing=locked     apt-get install -y         clinfo         strace         vainfo         sudo                   2.8s
 => [build 11/11] COPY llama-server-start.sh gpuinfo.sh ./                                                                                                                                                                                 0.2s
 => exporting to image                                                                                                                                                                                                                     2.1s
 => => exporting layers                                                                                                                                                                                                                    2.1s
 => => writing image sha256:f1a9449402f01c165add331b93a89322870bbee2ef302ecaf275598646ccfe9e                                                                                                                                               0.0s
 => => naming to docker.io/bbissell/test-prep                                                                                                                                                                                              0.0s


```

### Test 2 - Warm Cache, 56.5 sec
```
bbissell@IBM-PF2RW5PM:~/dev-in-wsl/llama.cpp.mkl/docker$ docker build . --file test-prep.Dockerfile --tag bbissell/test-prep
[+] Building 56.5s (19/19) FINISHED                                                                                                                                                                                              docker:default
 => [internal] load build definition from test-prep.Dockerfile                                                                                                                                                                             0.0s
 => => transferring dockerfile: 2.34kB                                                                                                                                                                                                     0.0s
 => [internal] load metadata for docker.io/library/ubuntu:jammy                                                                                                                                                                            0.1s
 => [internal] load .dockerignore                                                                                                                                                                                                          0.0s
 => => transferring context: 2B                                                                                                                                                                                                            0.0s
 => [build  1/12] FROM docker.io/library/ubuntu:jammy@sha256:0e5e4a57c2499249aafc3b40fcd541e9a456aab7296681a3994d631587203f97                                                                                                              0.0s
 => => resolve docker.io/library/ubuntu:jammy@sha256:0e5e4a57c2499249aafc3b40fcd541e9a456aab7296681a3994d631587203f97                                                                                                                      0.0s
 => CACHED [build  5/12] ADD --chmod=644 https://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list /etc/apt/sources.list.d/                                                                                                              0.1s
 => CACHED [build  6/12] ADD --chmod=644 https://packages.lunarg.com/lunarg-signing-key-pub.asc /etc/apt/trusted.gpg.d/                                                                                                                    0.1s
 => [internal] load build context                                                                                                                                                                                                          0.0s
 => => transferring context: 73B                                                                                                                                                                                                           0.0s
 => CACHED [build  2/12] RUN rm -f /etc/apt/apt.conf.d/docker-clean                                                                                                                                                                        0.0s
 => [build  3/12] RUN touch /var/touchedfile                                                                                                                                                                                               0.2s
 => [build  4/12] RUN --mount=type=cache,target=/var/cache/apt,sharing=locked     --mount=type=cache,target=/var/lib/apt,sharing=locked     apt update -y &&     apt install -y     software-properties-common                            19.8s
 => [build  5/12] ADD --chmod=644 https://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list /etc/apt/sources.list.d/                                                                                                                     0.0s
 => [build  6/12] ADD --chmod=644 https://packages.lunarg.com/lunarg-signing-key-pub.asc /etc/apt/trusted.gpg.d/                                                                                                                           0.0s
 => [build  7/12] RUN --mount=type=cache,target=/var/cache/apt,sharing=locked     --mount=type=cache,target=/var/lib/apt,sharing=locked     add-apt-repository ppa:kisak/kisak-mesa                                                        4.1s
 => [build  8/12] RUN --mount=type=cache,target=/var/cache/apt,sharing=locked     --mount=type=cache,target=/var/lib/apt,sharing=locked     apt update -y                                                                                  2.1s
 => [build  9/12] RUN --mount=type=cache,target=/var/cache/apt,sharing=locked     --mount=type=cache,target=/var/lib/apt,sharing=locked     apt install -y         git         build-essential         cmake                              10.6s
 => [build 10/12] RUN --mount=type=cache,target=/var/cache/apt,sharing=locked     --mount=type=cache,target=/var/lib/apt,sharing=locked     apt-get install -y         vulkan-sdk         libcurl4-openssl-dev         curl         pciu  15.3s
 => [build 11/12] RUN --mount=type=cache,target=/var/cache/apt,sharing=locked     --mount=type=cache,target=/var/lib/apt,sharing=locked     apt-get install -y         clinfo         strace         vainfo         sudo                   1.7s
 => [build 12/12] COPY llama-server-start.sh gpuinfo.sh ./                                                                                                                                                                                 0.2s
 => exporting to image                                                                                                                                                                                                                     2.2s
 => => exporting layers                                                                                                                                                                                                                    2.2s
 => => writing image sha256:fed085e9557d842b31dad92034b8319102cef566c5162df04484895cf9936f7e                                                                                                                                               0.0s
 => => naming to docker.io/bbissell/test-prep                                                                                                                                                                                              0.0s
bbissell@IBM-PF2RW5PM:~/dev-in-wsl/llama.cpp.mkl/docker$

```