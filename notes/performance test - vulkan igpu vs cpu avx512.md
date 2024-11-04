# 2024-11-01

## CPU, AVX512
```
+ docker run -it --rm --name test-llama-cpp-intelmkl --volume /home/bbissell/dev-in-wsl/models:/var/models:ro bbissell/llama-cpp-mkl:latest /bin/bash
```

| model                          |       size |     params | backend    | threads |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | ------: | ------------: | -------------------: |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | BLAS       |       4 |          pp10 |        133.01 ± 7.40 |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | BLAS       |       4 |          tg10 |         55.54 ± 1.60 |

build: 958367b (1)


## GPU, but likely CPU
```
+ docker run -it --rm --device=/dev/dxg --device=/dev/dri/card0 --device=/dev/dri/renderD128 --group-add video --env DISPLAY --env WAYLAND_DISPLAY --env XDG_RUNTIME_DIR --env LD_LIBRARY_PATH=/usr/lib/wsl/lib --env LIBVA_DRIVER_NAME=d3d12 -v /tmp/.X11-unix:/tmp/.X11-unix -v /mnt/wslg:/mnt/wslg -v /usr/lib/wsl:/usr/lib/wsl -v /usr/lib/x86_64-linux-gnu/dri:/usr/lib/x86_64-linux-gnu/dri --volume /home/bbissell/dev-in-wsl/models:/var/models:ro bbissell/llama-cpp-mkl-gpu:latest /bin/bash
```

| model                          |       size |     params | backend    | threads |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | ------: | ------------: | -------------------: |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | BLAS       |       4 |          pp10 |        133.03 ± 9.35 |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | BLAS       |       4 |          tg10 |         55.60 ± 3.55 |

build: 958367b (1)

## VULKAN to GPU
```
++ docker run -it --rm --device=/dev/dxg --device=/dev/dri/card0 --device=/dev/dri/renderD128 --group-add video --env DISPLAY --env WAYLAND_DISPLAY --env XDG_RUNTIME_DIR --env LD_LIBRARY_PATH=/usr/lib/wsl/lib --env LIBVA_DRIVER_NAME=d3d12 -v /tmp/.X11-unix:/tmp/.X11-unix -v /mnt/wslg:/mnt/wslg -v /usr/lib/wsl:/usr/lib/wsl -v /usr/lib/x86_64-linux-gnu/dri:/usr/lib/x86_64-linux-gnu/dri --volume /home/bbissell/dev-in-wsl/models:/var/models:ro --name test-llamacpp-vulkan bbissell/llama-cpp-vulkan:latest /bin/bash
```

```
WARNING: dzn is not a conformant Vulkan implementation, testing use only.
ggml_vulkan: Found 1 Vulkan devices:
Vulkan0: Microsoft Direct3D12 (Intel(R) Iris(R) Xe Graphics) (Dozen) | uma: 1 | fp16: 1 | warp size: 16
```
| model                          |       size |     params | backend    | ngl |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | ------------: | -------------------: |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | Vulkan     |  99 |          pp10 |          8.37 ± 0.64 |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | Vulkan     |  99 |          tg10 |         27.66 ± 0.62 |

build: 958367b (1)

# 2024-11-04

Clearly vulkan is slower - speed increases while the number of layers routed to GPU decrease.

## 99 layers to GPU
```
llamauser@66f96b5ed32a:~$ more llama-bench-granite-a400m.sh
#!/bin/bash
set +x
LLAMA_BENCH_OPTS="${LLAMA_BENCH_OPTS:-}"
echo "Additional parameters from \$LLAMA_BENCH_OPTS: ${LLAMA_BENCH_OPTS}"
./git/build/bin/llama-bench -p 10 -n 10 -r 10 -m /var/models/ibm/granite-3.0/granite-3.0-1b-a400m-instruct-Q8_0.gguf ${L
LAMA_BENCH_OPTS}
llamauser@66f96b5ed32a:~$ ./llama-bench-granite-a400m.sh
Additional parameters from $LLAMA_BENCH_OPTS:
WARNING: dzn is not a conformant Vulkan implementation, testing use only.
ggml_vulkan: Found 1 Vulkan devices:
Vulkan0: Microsoft Direct3D12 (Intel(R) Iris(R) Xe Graphics) (Dozen) | uma: 1 | fp16: 1 | warp size: 16
| model                          |       size |     params | backend    | ngl |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | ------------: | -------------------: |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | Vulkan     |  99 |          pp10 |          9.10 ± 0.59 |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | Vulkan     |  99 |          tg10 |         28.56 ± 0.55 |

build: 8f275a7 (1)
```

## 80 layers to GPU
```
llamauser@66f96b5ed32a:~$ LLAMA_BENCH_OPTS=-ngl 80 ./llama-bench-granite-a400m.sh
bash: 80: command not found
llamauser@66f96b5ed32a:~$ LLAMA_BENCH_OPTS="-ngl 80" ./llama-bench-granite-a400m.sh
Additional parameters from $LLAMA_BENCH_OPTS: -ngl 80
WARNING: dzn is not a conformant Vulkan implementation, testing use only.
ggml_vulkan: Found 1 Vulkan devices:
Vulkan0: Microsoft Direct3D12 (Intel(R) Iris(R) Xe Graphics) (Dozen) | uma: 1 | fp16: 1 | warp size: 16
| model                          |       size |     params | backend    | ngl |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | ------------: | -------------------: |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | Vulkan     |  80 |          pp10 |          9.00 ± 0.62 |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | Vulkan     |  80 |          tg10 |         28.20 ± 0.50 |

build: 8f275a7 (1)
```

## 8 layers to GPU
```
llamauser@66f96b5ed32a:~$ LLAMA_BENCH_OPTS="-ngl 8" ./llama-bench-granite-a400m.sh
Additional parameters from $LLAMA_BENCH_OPTS: -ngl 8
WARNING: dzn is not a conformant Vulkan implementation, testing use only.
ggml_vulkan: Found 1 Vulkan devices:
Vulkan0: Microsoft Direct3D12 (Intel(R) Iris(R) Xe Graphics) (Dozen) | uma: 1 | fp16: 1 | warp size: 16
| model                          |       size |     params | backend    | ngl |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | ------------: | -------------------: |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | Vulkan     |   8 |          pp10 |         25.55 ± 2.54 |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | Vulkan     |   8 |          tg10 |         44.05 ± 3.62 |

build: 8f275a7 (1)
```

## 1 layers to GPU
```
llamauser@66f96b5ed32a:~$ LLAMA_BENCH_OPTS="-ngl 1" ./llama-bench-granite-a400m.sh
Additional parameters from $LLAMA_BENCH_OPTS: -ngl 1
WARNING: dzn is not a conformant Vulkan implementation, testing use only.
ggml_vulkan: Found 1 Vulkan devices:
Vulkan0: Microsoft Direct3D12 (Intel(R) Iris(R) Xe Graphics) (Dozen) | uma: 1 | fp16: 1 | warp size: 16
| model                          |       size |     params | backend    | ngl |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | ------------: | -------------------: |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | Vulkan     |   1 |          pp10 |         88.81 ± 3.38 |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | Vulkan     |   1 |          tg10 |         53.65 ± 6.13 |

build: 8f275a7 (1)
```

## 0 layers to GPU
```
llamauser@66f96b5ed32a:~$ LLAMA_BENCH_OPTS="-ngl 0" ./llama-bench-granite-a400m.sh
Additional parameters from $LLAMA_BENCH_OPTS: -ngl 0
WARNING: dzn is not a conformant Vulkan implementation, testing use only.
ggml_vulkan: Found 1 Vulkan devices:
Vulkan0: Microsoft Direct3D12 (Intel(R) Iris(R) Xe Graphics) (Dozen) | uma: 1 | fp16: 1 | warp size: 16
| model                          |       size |     params | backend    | ngl |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | ------------: | -------------------: |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | Vulkan     |   0 |          pp10 |       127.02 ± 27.15 |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | Vulkan     |   0 |          tg10 |         64.94 ± 2.31 |

build: 8f275a7 (1)
llamauser@66f96b5ed32a:~$
```