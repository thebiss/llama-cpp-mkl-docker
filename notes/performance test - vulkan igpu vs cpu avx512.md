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

# CPU Thread increases
## 4 threads (default)
```
 ./test-cpu.sh
1
+ docker run -it --rm --name test-llama-cpp-intelmkl --volume /home/bbissell/dev-in-wsl/models:/var/models:ro bbissell/llama-cpp-mkl:latest /bin/bash
llamauser@498d40168967:~$ ./llama-bench-granite-a400m.sh
Additional parameters from $LLAMA_BENCH_OPTS:
| model                          |       size |     params | backend    | threads |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | ------: | ------------: | -------------------: |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | BLAS       |       4 |          pp10 |       140.92 ± 22.27 |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | BLAS       |       4 |          tg10 |         64.13 ± 2.73 |

build: 8f275a7 (1)
```

## 8 threads (4 cores x 2 threads per core) - FASTEST
```
llamauser@498d40168967:~$ LLAMA_BENCH_OPTS="-t 8" ./llama-bench-granite-a400m.sh
Additional parameters from $LLAMA_BENCH_OPTS: -t 8
| model                          |       size |     params | backend    | threads |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | ------: | ------------: | -------------------: |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | BLAS       |       8 |          pp10 |       171.60 ± 40.16 |
| granitemoe ?B Q8_0             |   1.37 GiB |     1.38 B | BLAS       |       8 |          tg10 |         64.94 ± 8.09 |

build: 8f275a7 (1)
llamauser@498d40168967:~$
```


# GPU performance 
## `test-backend-ops perf` benchmark

```
llamauser@51353f548f6d:~$ ./git/build/bin/test-backend-ops perf
ggml_sycl_init: GGML_SYCL_FORCE_MMQ:   no
ggml_sycl_init: SYCL_USE_XMX: yes
ggml_sycl_init: found 1 SYCL devices:
Testing 2 devices

Backend 1/2: SYCL0
[SYCL] call ggml_check_sycl
ggml_check_sycl: GGML_SYCL_DEBUG: 0
ggml_check_sycl: GGML_SYCL_F16: yes
found 1 SYCL devices:
|  |                   |                                       |       |Max    |        |Max  |Global |                     |
|  |                   |                                       |       |compute|Max work|sub  |mem    |                     |
|ID|        Device Type|                                   Name|Version|units  |group   |group|size   |       Driver version|
|--|-------------------|---------------------------------------|-------|-------|--------|-----|-------|---------------------|
| 0| [level_zero:gpu:0]|                Intel Graphics [0x9a49]|    1.3|     80|     512|   32| 15538M|            1.3.27642|
  Device description: Intel(R) Graphics [0x9a49]
get_memory_info: [warning] ext_intel_free_memory is not supported (export/set ZES_ENABLE_SYSMAN=1 to support), use total memory as free memory
  Device memory: 14818 MB (14818 MB free)

  ADD(type=f32,ne=[4096,1,1,1],nr=[1,1,1,1]):                 171990 runs -     5.83 us/run -       48 kB/run -    0.37 GB/s
  ADD(type=f32,ne=[4096,1,1,1],nr=[1,512,1,1]):                 2732 runs -   413.23 us/run -    24576 kB/run -   28.37 GB/s
  MUL_MAT(type_a=f32,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                     852 runs - 12960.43 us/run - 117.44 MFLOP/run -   9.06 GFLOPS
  MUL_MAT(type_a=f16,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                     852 runs -  6093.61 us/run - 117.44 MFLOP/run -  19.27 GFLOPS
  MUL_MAT(type_a=bf16,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]): not supported
  MUL_MAT(type_a=q4_0,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                    852 runs -  2129.73 us/run - 117.44 MFLOP/run -  55.14 GFLOPS
  MUL_MAT(type_a=q4_1,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                    852 runs -  2144.95 us/run - 117.44 MFLOP/run -  54.75 GFLOPS
  MUL_MAT(type_a=q5_0,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                    852 runs -  2607.42 us/run - 117.44 MFLOP/run -  45.04 GFLOPS
  MUL_MAT(type_a=q5_1,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                    852 runs -  2559.69 us/run - 117.44 MFLOP/run -  45.88 GFLOPS
  MUL_MAT(type_a=q8_0,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                    852 runs -  3293.70 us/run - 117.44 MFLOP/run -  35.66 GFLOPS
  MUL_MAT(type_a=q2_K,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   1704 runs -  1158.33 us/run - 117.44 MFLOP/run - 101.39 GFLOPS
  MUL_MAT(type_a=q3_K,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                    852 runs -  1942.92 us/run - 117.44 MFLOP/run -  60.45 GFLOPS
  MUL_MAT(type_a=q4_K,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                    852 runs -  1379.11 us/run - 117.44 MFLOP/run -  85.16 GFLOPS
  MUL_MAT(type_a=q5_K,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                    852 runs -  2666.07 us/run - 117.44 MFLOP/run -  44.05 GFLOPS
  MUL_MAT(type_a=q6_K,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                    852 runs -  2843.95 us/run - 117.44 MFLOP/run -  41.29 GFLOPS
  MUL_MAT(type_a=iq2_xxs,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                 852 runs -  3048.70 us/run - 117.44 MFLOP/run -  38.52 GFLOPS
  MUL_MAT(type_a=iq2_xs,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                  852 runs -  4089.12 us/run - 117.44 MFLOP/run -  28.72 GFLOPS
  MUL_MAT(type_a=iq2_s,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   852 runs -  2660.76 us/run - 117.44 MFLOP/run -  44.14 GFLOPS
  MUL_MAT(type_a=iq3_xxs,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                 852 runs -  5374.60 us/run - 117.44 MFLOP/run -  21.85 GFLOPS
  MUL_MAT(type_a=iq1_s,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   852 runs -  2675.44 us/run - 117.44 MFLOP/run -  43.90 GFLOPS
  MUL_MAT(type_a=iq1_m,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   852 runs -  2758.58 us/run - 117.44 MFLOP/run -  42.57 GFLOPS
  MUL_MAT(type_a=iq4_nl,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                  852 runs -  3976.88 us/run - 117.44 MFLOP/run -  29.53 GFLOPS
  MUL_MAT(type_a=iq3_s,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   852 runs -  5251.48 us/run - 117.44 MFLOP/run -  22.36 GFLOPS
  MUL_MAT(type_a=iq4_xs,type_b=f32,m=4096,n=1,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                  852 runs -  4179.45 us/run - 117.44 MFLOP/run -  28.10 GFLOPS
  MUL_MAT(type_a=f32,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                    22 runs - 46218.91 us/run -  60.13 GFLOP/run -   1.30 TFLOPS
  MUL_MAT(type_a=f16,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                    16 runs - 63400.50 us/run -  60.13 GFLOP/run - 948.41 GFLOPS
  MUL_MAT(type_a=bf16,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]): not supported
  MUL_MAT(type_a=q4_0,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   16 runs - 68581.31 us/run -  60.13 GFLOP/run - 876.76 GFLOPS
  MUL_MAT(type_a=q4_1,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   16 runs - 69396.75 us/run -  60.13 GFLOP/run - 866.46 GFLOPS
  MUL_MAT(type_a=q5_0,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   16 runs - 68641.44 us/run -  60.13 GFLOP/run - 875.99 GFLOPS
  MUL_MAT(type_a=q5_1,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   16 runs - 68661.88 us/run -  60.13 GFLOP/run - 875.73 GFLOPS
  MUL_MAT(type_a=q8_0,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   16 runs - 69134.69 us/run -  60.13 GFLOP/run - 869.74 GFLOPS
  MUL_MAT(type_a=q2_K,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   16 runs - 68752.31 us/run -  60.13 GFLOP/run - 874.58 GFLOPS
  MUL_MAT(type_a=q3_K,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   16 runs - 68618.75 us/run -  60.13 GFLOP/run - 876.28 GFLOPS
  MUL_MAT(type_a=q4_K,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   16 runs - 68864.44 us/run -  60.13 GFLOP/run - 873.16 GFLOPS
  MUL_MAT(type_a=q5_K,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   16 runs - 68865.56 us/run -  60.13 GFLOP/run - 873.14 GFLOPS
  MUL_MAT(type_a=q6_K,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                   16 runs - 68825.31 us/run -  60.13 GFLOP/run - 873.65 GFLOPS
  MUL_MAT(type_a=iq2_xxs,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                14 runs - 71706.79 us/run -  60.13 GFLOP/run - 838.55 GFLOPS
  MUL_MAT(type_a=iq2_xs,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                 14 runs - 72496.14 us/run -  60.13 GFLOP/run - 829.42 GFLOPS
  MUL_MAT(type_a=iq2_s,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                  16 runs - 71278.88 us/run -  60.13 GFLOP/run - 843.58 GFLOPS
  MUL_MAT(type_a=iq3_xxs,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                14 runs - 75975.36 us/run -  60.13 GFLOP/run - 791.43 GFLOPS
  MUL_MAT(type_a=iq1_s,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                  14 runs - 71726.36 us/run -  60.13 GFLOP/run - 838.32 GFLOPS
  MUL_MAT(type_a=iq1_m,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                  16 runs - 71387.31 us/run -  60.13 GFLOP/run - 842.30 GFLOPS
  MUL_MAT(type_a=iq4_nl,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                 14 runs - 72304.50 us/run -  60.13 GFLOP/run - 831.62 GFLOPS
  MUL_MAT(type_a=iq3_s,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                  14 runs - 74324.71 us/run -  60.13 GFLOP/run - 809.01 GFLOPS
  MUL_MAT(type_a=iq4_xs,type_b=f32,m=4096,n=512,k=14336,bs=[1,1],nr=[1,1],per=[0,1,2,3]):                 14 runs - 72537.64 us/run -  60.13 GFLOP/run - 828.94 GFLOPS
  Backend SYCL0: OK

Backend 2/2: CPU
  Skipping CPU backend
2/2 backends passed
OK
llamauser@51353f548f6d:~$
```