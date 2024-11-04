#


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
