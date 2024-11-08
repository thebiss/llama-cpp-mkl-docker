
## GPU Support

### llama-bench fails with `The number of work-items in each dimension of a work-group cannot exceed {512, 512, 512} for this device`
```
llamauser@c458bd71e284:~$ ./llama-bench-granite-a400m.sh
Additional parameters from $LLAMA_BENCH_OPTS: -ngl 33
ggml_sycl_init: GGML_SYCL_FORCE_MMQ:   no
ggml_sycl_init: SYCL_USE_XMX: yes
ggml_sycl_init: found 1 SYCL devices:
| model                          |       size |     params | backend    | ngl |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | ------------: | -------------------: |
get_memory_info: [warning] ext_intel_free_memory is not supported (export/set ZES_ENABLE_SYSMAN=1 to support), use total memory as free memory
get_memory_info: [warning] ext_intel_free_memory is not supported (export/set ZES_ENABLE_SYSMAN=1 to support), use total memory as free memory
get_memory_info: [warning] ext_intel_free_memory is not supported (export/set ZES_ENABLE_SYSMAN=1 to support), use total memory as free memory
[SYCL] call ggml_check_sycl
ggml_check_sycl: GGML_SYCL_DEBUG: 1
ggml_check_sycl: GGML_SYCL_F16: yes
[SYCL] call ggml_backend_sycl_print_sycl_devices
found 1 SYCL devices:
|  |                   |                                       |       |Max    |        |Max  |Global |                     |
|  |                   |                                       |       |compute|Max work|sub  |mem    |                     |
|ID|        Device Type|                                   Name|Version|units  |group   |group|size   |       Driver version|
|--|-------------------|---------------------------------------|-------|-------|--------|-----|-------|---------------------|
| 0| [level_zero:gpu:0]|                Intel Graphics [0x9a49]|    1.3|     80|     512|   32| 15538M|            1.3.27642|
[SYCL] call ggml_backend_sycl_host_buffer_type
[SYCL] call ggml_backend_sycl_buffer_type
[SYCL] call ggml_backend_sycl_get_device_count
[SYCL] call ggml_backend_sycl_host_buffer_type
call ggml_sycl_rms_norm
call ggml_sycl_rms_norm done
call ggml_sycl_mul
call ggml_sycl_mul done
call ggml_sycl_add
call ggml_sycl_add done
call ggml_sycl_rms_norm
call ggml_sycl_rms_norm done
call ggml_sycl_mul
call ggml_sycl_mul done
The number of work-items in each dimension of a work-group cannot exceed {512, 512, 512} for this device -54 (PI_ERROR_INVALID_WORK_GROUP_SIZE)Exception caught at file:/home/llamauser/git/ggml/src/ggml-sycl.cpp, line:4566
llamauser@c458bd71e284:~$
```

Fails in this function: https://github.com/ggerganov/llama.cpp/blob/401558b7ba7a08175c153cd3607230f63c8a528e/ggml/src/ggml-sycl.cpp#L4560
...within one of the `ggml_copy_f*` calls

### test-backed-ops fails with GPU: `ggml-sycl.cpp:4025: GGML_ASSERT(src0->nb[0] <= src0->nb[1] && src0->nb[2] <= src0->nb[3]) failed`

```
OK
llamauser@51353f548f6d:~$ ./git/build/bin/test-backend-ops test
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

  ABS(type=f32,ne_a=[128,2,2,2],v=0): not supported [SYCL0]
  ABS(type=f32,ne_a=[5,7,11,13],v=0): not supported [SYCL0]
  SGN(type=f32,ne_a=[128,2,2,2],v=0): not supported [SYCL0]
  SGN(type=f32,ne_a=[5,7,11,13],v=0): not supported [SYCL0]
  NEG(type=f32,ne_a=[128,2,2,2],v=0): not supported [SYCL0]
  NEG(type=f32,ne_a=[5,7,11,13],v=0): not supported [SYCL0]
  STEP(type=f32,ne_a=[128,2,2,2],v=0): not supported [SYCL0]
  STEP(type=f32,ne_a=[5,7,11,13],v=0): not supported [SYCL0]
  TANH(type=f32,ne_a=[128,2,2,2],v=0): OK
  TANH(type=f32,ne_a=[5,7,11,13],v=0): OK
  ELU(type=f32,ne_a=[128,2,2,2],v=0): not supported [SYCL0]
  ELU(type=f32,ne_a=[5,7,11,13],v=0): not supported [SYCL0]
  RELU(type=f32,ne_a=[128,2,2,2],v=0): OK
  RELU(type=f32,ne_a=[5,7,11,13],v=0): OK
  SIGMOID(type=f32,ne_a=[128,2,2,2],v=0): not supported [SYCL0]
  SIGMOID(type=f32,ne_a=[5,7,11,13],v=0): not supported [SYCL0]
  GELU(type=f32,ne_a=[128,2,2,2],v=0): OK
  GELU(type=f32,ne_a=[5,7,11,13],v=0): OK
  GELU_QUICK(type=f32,ne_a=[128,2,2,2],v=0): OK
  GELU_QUICK(type=f32,ne_a=[5,7,11,13],v=0): OK
  SILU(type=f32,ne_a=[128,2,2,2],v=0): OK
  SILU(type=f32,ne_a=[5,7,11,13],v=0): OK
  HARDSWISH(type=f32,ne_a=[128,2,2,2],v=0): OK
  HARDSWISH(type=f32,ne_a=[5,7,11,13],v=0): OK
  HARDSIGMOID(type=f32,ne_a=[128,2,2,2],v=0): OK
  HARDSIGMOID(type=f32,ne_a=[5,7,11,13],v=0): OK
  EXP(type=f32,ne_a=[128,2,2,2],v=0): not supported [SYCL0]
  EXP(type=f32,ne_a=[5,7,11,13],v=0): not supported [SYCL0]
  ABS(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  ABS(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  SGN(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  SGN(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  NEG(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  NEG(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  STEP(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  STEP(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  TANH(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  TANH(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  ELU(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  ELU(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  RELU(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  RELU(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  SIGMOID(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  SIGMOID(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  GELU(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  GELU(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  GELU_QUICK(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  GELU_QUICK(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  SILU(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  SILU(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  HARDSWISH(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  HARDSWISH(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  HARDSIGMOID(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  HARDSIGMOID(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  EXP(type=f32,ne_a=[128,2,2,2],v=1): not supported [SYCL0]
  EXP(type=f32,ne_a=[5,7,11,13],v=1): not supported [SYCL0]
  GET_ROWS(type=f32,n=1,m=8,r=2,b=1,v=0): OK
  GET_ROWS(type=f32,n=256,m=5,r=4,b=1,v=0): OK
  GET_ROWS(type=f32,n=256,m=5,r=4,b=1,v=1): OK
  GET_ROWS(type=f32,n=256,m=5,r=4,b=7,v=0): OK
  GET_ROWS(type=f32,n=256,m=5,r=4,b=7,v=1): OK
  GET_ROWS(type=f16,n=256,m=5,r=4,b=1,v=0): OK
  GET_ROWS(type=f16,n=256,m=5,r=4,b=1,v=1): OK
  GET_ROWS(type=f16,n=256,m=5,r=4,b=7,v=0): OK
  GET_ROWS(type=f16,n=256,m=5,r=4,b=7,v=1): OK
  GET_ROWS(type=bf16,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=bf16,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=bf16,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=bf16,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=q4_0,n=256,m=5,r=4,b=1,v=0): OK
  GET_ROWS(type=q4_0,n=256,m=5,r=4,b=1,v=1): OK
  GET_ROWS(type=q4_0,n=256,m=5,r=4,b=7,v=0): OK
  GET_ROWS(type=q4_0,n=256,m=5,r=4,b=7,v=1): OK
  GET_ROWS(type=q4_1,n=256,m=5,r=4,b=1,v=0): OK
  GET_ROWS(type=q4_1,n=256,m=5,r=4,b=1,v=1): OK
  GET_ROWS(type=q4_1,n=256,m=5,r=4,b=7,v=0): OK
  GET_ROWS(type=q4_1,n=256,m=5,r=4,b=7,v=1): OK
  GET_ROWS(type=q5_0,n=256,m=5,r=4,b=1,v=0): OK
  GET_ROWS(type=q5_0,n=256,m=5,r=4,b=1,v=1): OK
  GET_ROWS(type=q5_0,n=256,m=5,r=4,b=7,v=0): OK
  GET_ROWS(type=q5_0,n=256,m=5,r=4,b=7,v=1): OK
  GET_ROWS(type=q5_1,n=256,m=5,r=4,b=1,v=0): OK
  GET_ROWS(type=q5_1,n=256,m=5,r=4,b=1,v=1): OK
  GET_ROWS(type=q5_1,n=256,m=5,r=4,b=7,v=0): OK
  GET_ROWS(type=q5_1,n=256,m=5,r=4,b=7,v=1): OK
  GET_ROWS(type=q8_0,n=256,m=5,r=4,b=1,v=0): OK
  GET_ROWS(type=q8_0,n=256,m=5,r=4,b=1,v=1): OK
  GET_ROWS(type=q8_0,n=256,m=5,r=4,b=7,v=0): OK
  GET_ROWS(type=q8_0,n=256,m=5,r=4,b=7,v=1): OK
  GET_ROWS(type=q2_K,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=q2_K,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=q2_K,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=q2_K,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=q3_K,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=q3_K,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=q3_K,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=q3_K,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=q4_K,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=q4_K,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=q4_K,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=q4_K,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=q5_K,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=q5_K,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=q5_K,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=q5_K,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=q6_K,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=q6_K,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=q6_K,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=q6_K,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=iq2_xxs,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=iq2_xxs,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=iq2_xxs,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=iq2_xxs,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=iq2_xs,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=iq2_xs,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=iq2_xs,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=iq2_xs,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=iq2_s,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=iq2_s,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=iq2_s,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=iq2_s,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=iq3_xxs,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=iq3_xxs,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=iq3_xxs,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=iq3_xxs,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=iq1_s,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=iq1_s,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=iq1_s,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=iq1_s,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=iq1_m,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=iq1_m,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=iq1_m,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=iq1_m,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=iq4_nl,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=iq4_nl,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=iq4_nl,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=iq4_nl,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=iq3_s,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=iq3_s,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=iq3_s,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=iq3_s,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=iq4_xs,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=iq4_xs,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=iq4_xs,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=iq4_xs,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  GET_ROWS(type=i32,n=256,m=5,r=4,b=1,v=0): not supported [SYCL0]
  GET_ROWS(type=i32,n=256,m=5,r=4,b=1,v=1): not supported [SYCL0]
  GET_ROWS(type=i32,n=256,m=5,r=4,b=7,v=0): not supported [SYCL0]
  GET_ROWS(type=i32,n=256,m=5,r=4,b=7,v=1): not supported [SYCL0]
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=avg,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=1,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=1,s0=2,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=1,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=1,k1=3,s0=2,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=1,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=1,s0=2,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=1,s1=2,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=1,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=1,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=1,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=1,p0=1,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=2,p0=0,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=2,p0=0,p1=1): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=2,p0=1,p1=0): OK
  POOL_2D(pool_type=max,type_input=f32,ne_input=[10,10,3,1],k0=3,k1=3,s0=2,s1=2,p0=1,p1=1): OK
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[3000,128,1,1],ne_kernel=[3,128,1280,1],s0=1,s1=0,p0=1,p1=0,d0=1,d1=0,is_2D=0): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f16,dst_type=f32,ne_input=[3000,128,1,1],ne_kernel=[3,128,1280,1],s0=1,s1=0,p0=1,p1=0,d0=1,d1=0,is_2D=0): OK
  IM2COL(type_input=f32,type_kernel=f16,dst_type=f16,ne_input=[3000,128,1,1],ne_kernel=[3,128,1280,1],s0=1,s1=0,p0=1,p1=0,d0=1,d1=0,is_2D=0): OK
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,2,2,1],ne_kernel=[3,2,2,1],s0=1,s1=0,p0=0,p1=0,d0=1,d1=0,is_2D=0): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,2,2,1],ne_kernel=[3,2,2,1],s0=1,s1=0,p0=0,p1=0,d0=3,d1=0,is_2D=0): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,2,2,1],ne_kernel=[3,2,2,1],s0=1,s1=0,p0=3,p1=0,d0=1,d1=0,is_2D=0): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,2,2,1],ne_kernel=[3,2,2,1],s0=1,s1=0,p0=3,p1=0,d0=3,d1=0,is_2D=0): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,2,2,1],ne_kernel=[3,2,2,1],s0=3,s1=0,p0=0,p1=0,d0=1,d1=0,is_2D=0): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,2,2,1],ne_kernel=[3,2,2,1],s0=3,s1=0,p0=0,p1=0,d0=3,d1=0,is_2D=0): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,2,2,1],ne_kernel=[3,2,2,1],s0=3,s1=0,p0=3,p1=0,d0=1,d1=0,is_2D=0): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,2,2,1],ne_kernel=[3,2,2,1],s0=3,s1=0,p0=3,p1=0,d0=3,d1=0,is_2D=0): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[10,10,3,1],ne_kernel=[3,3,3,1],s0=1,s1=1,p0=1,p1=1,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f16,dst_type=f32,ne_input=[10,10,3,1],ne_kernel=[3,3,3,1],s0=1,s1=1,p0=1,p1=1,d0=1,d1=1,is_2D=1): OK
  IM2COL(type_input=f32,type_kernel=f16,dst_type=f16,ne_input=[10,10,3,1],ne_kernel=[3,3,3,1],s0=1,s1=1,p0=1,p1=1,d0=1,d1=1,is_2D=1): OK
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=0,p1=0,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=0,p1=0,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=0,p1=0,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=0,p1=0,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=0,p1=3,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=0,p1=3,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=0,p1=3,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=0,p1=3,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=3,p1=0,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=3,p1=0,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=3,p1=0,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=3,p1=0,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=3,p1=3,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=3,p1=3,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=3,p1=3,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=1,p0=3,p1=3,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=0,p1=0,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=0,p1=0,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=0,p1=0,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=0,p1=0,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=0,p1=3,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=0,p1=3,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=0,p1=3,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=0,p1=3,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=3,p1=0,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=3,p1=0,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=3,p1=0,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=3,p1=0,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=3,p1=3,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=3,p1=3,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=3,p1=3,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=1,s1=3,p0=3,p1=3,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=0,p1=0,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=0,p1=0,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=0,p1=0,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=0,p1=0,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=0,p1=3,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=0,p1=3,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=0,p1=3,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=0,p1=3,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=3,p1=0,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=3,p1=0,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=3,p1=0,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=3,p1=0,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=3,p1=3,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=3,p1=3,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=3,p1=3,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=1,p0=3,p1=3,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=0,p1=0,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=0,p1=0,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=0,p1=0,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=0,p1=0,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=0,p1=3,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=0,p1=3,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=0,p1=3,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=0,p1=3,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=3,p1=0,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=3,p1=0,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=3,p1=0,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=3,p1=0,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=3,p1=3,d0=1,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=3,p1=3,d0=1,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=3,p1=3,d0=3,d1=1,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f32,dst_type=f32,ne_input=[20,20,2,2],ne_kernel=[3,3,2,2],s0=3,s1=3,p0=3,p1=3,d0=3,d1=3,is_2D=1): not supported [SYCL0]
  IM2COL(type_input=f32,type_kernel=f16,dst_type=f16,ne_input=[12,12,1,32],ne_kernel=[3,3,1,32],s0=1,s1=1,p0=1,p1=1,d0=1,d1=1,is_2D=1): OK
  IM2COL(type_input=f32,type_kernel=f16,dst_type=f16,ne_input=[12,12,2,32],ne_kernel=[3,3,2,32],s0=1,s1=1,p0=1,p1=1,d0=1,d1=1,is_2D=1): OK
  IM2COL(type_input=f32,type_kernel=f16,dst_type=f16,ne_input=[12,12,1,1024],ne_kernel=[3,3,1,1024],s0=1,s1=1,p0=1,p1=1,d0=1,d1=1,is_2D=1): OK
  IM2COL(type_input=f32,type_kernel=f16,dst_type=f16,ne_input=[12,12,2,1024],ne_kernel=[3,3,2,1024],s0=1,s1=1,p0=1,p1=1,d0=1,d1=1,is_2D=1): OK
  IM2COL(type_input=f32,type_kernel=f16,dst_type=f16,ne_input=[12,12,1,2048],ne_kernel=[3,3,1,2048],s0=1,s1=1,p0=1,p1=1,d0=1,d1=1,is_2D=1): OK
  IM2COL(type_input=f32,type_kernel=f16,dst_type=f16,ne_input=[12,12,2,2048],ne_kernel=[3,3,2,2048],s0=1,s1=1,p0=1,p1=1,d0=1,d1=1,is_2D=1): OK
  IM2COL(type_input=f32,type_kernel=f16,dst_type=f16,ne_input=[12,12,1,2560],ne_kernel=[3,3,1,2560],s0=1,s1=1,p0=1,p1=1,d0=1,d1=1,is_2D=1): OK
  IM2COL(type_input=f32,type_kernel=f16,dst_type=f16,ne_input=[12,12,2,2560],ne_kernel=[3,3,2,2560],s0=1,s1=1,p0=1,p1=1,d0=1,d1=1,is_2D=1): OK
  CONV_TRANSPOSE_1D(ne_input=[197,32,1,1],ne_kernel=[16,32,32,1],s0=1,p0=0,d0=1): OK
  CONV_TRANSPOSE_1D(ne_input=[3,2,1,1],ne_kernel=[2,3,2,1],s0=3,p0=0,d0=1): OK
  CONV_TRANSPOSE_1D(ne_input=[3,2,1,1],ne_kernel=[2,3,2,1],s0=2,p0=0,d0=1): OK
  CONV_TRANSPOSE_1D(ne_input=[3,2,1,1],ne_kernel=[2,3,2,1],s0=1,p0=0,d0=1): OK
  CONV_TRANSPOSE_1D(ne_input=[3,2,1,1],ne_kernel=[3,2,2,1],s0=2,p0=0,d0=1): OK
  CONV_TRANSPOSE_1D(ne_input=[3,2,1,1],ne_kernel=[3,2,2,1],s0=1,p0=0,d0=1): OK
  CONV_TRANSPOSE_1D(ne_input=[3,2,1,1],ne_kernel=[3,1,2,1],s0=1,p0=0,d0=1): OK
  CONV_TRANSPOSE_1D(ne_input=[2,1,1,1],ne_kernel=[3,1,1,1],s0=1,p0=0,d0=1): OK
  ARGMAX(type=f32,ne=[10,100,1,1]): not supported [SYCL0]
  COUNT_EQUAL(type=f32,ne=[4,500,1,1]): not supported [SYCL0]
  REPEAT(type=f32,ne=[10,5,4,1],nr=[1,1,1,1]): OK
  REPEAT(type=f32,ne=[10,5,4,1],nr=[2,1,1,1]): OK
  REPEAT(type=f32,ne=[10,5,4,1],nr=[1,2,1,1]): OK
  REPEAT(type=f32,ne=[10,5,4,1],nr=[1,1,2,1]): OK
  REPEAT(type=f32,ne=[10,5,4,1],nr=[1,1,1,2]): OK
  REPEAT(type=i32,ne=[10,5,4,1],nr=[2,1,1,1]): OK
  REPEAT(type=i16,ne=[10,5,4,1],nr=[1,1,1,2]): OK
  REPEAT(type=f32,ne=[10,5,4,3],nr=[1,1,1,1]): OK
  REPEAT(type=f32,ne=[10,5,4,3],nr=[2,1,1,1]): OK
  REPEAT(type=f32,ne=[10,5,4,3],nr=[1,2,1,1]): OK
  REPEAT(type=f32,ne=[10,5,4,3],nr=[1,1,2,1]): OK
  REPEAT(type=f32,ne=[10,5,4,3],nr=[1,1,1,2]): OK
  REPEAT(type=i32,ne=[10,5,4,3],nr=[2,1,1,1]): OK
  REPEAT(type=i16,ne=[10,5,4,3],nr=[1,1,1,2]): OK
  DUP(type=f32,ne=[10,10,20,1]): OK
  DUP(type=f16,ne=[10,10,20,1]): OK
  DUP(type=i32,ne=[10,10,20,1]): OK
  DUP(type=i16,ne=[10,10,20,1]): OK
  DUP(type=f32,ne=[10,10,5,1],permute=[0,2,1,3]): OK
  DUP(type=f16,ne=[10,10,5,1],permute=[0,2,1,3]): OK
  DUP(type=f32,ne=[10,10,5,1],permute=[1,0,2,3]): OK
  DUP(type=f16,ne=[10,10,5,1],permute=[1,0,2,3]): OK
  DUP(type=i16,ne=[10,8,3,1],permute=[0,2,1,3]): OK
  DUP(type=i16,ne=[10,8,3,1],permute=[1,2,0,3]): OK
  SET(type_src=f32,type_dst=f32,ne=[6,5,4,3],dim=1): not supported [SYCL0]
  SET(type_src=f32,type_dst=f32,ne=[6,5,4,3],dim=2): not supported [SYCL0]
  SET(type_src=f32,type_dst=f32,ne=[6,5,4,3],dim=3): not supported [SYCL0]
  CPY(type_src=f16,type_dst=f32,ne=[256,4,4,4],permute=[0,0,0,0]): OK
  CPY(type_src=f16,type_dst=f32,ne=[256,2,3,4],permute=[0,2,1,3]): OK
  CPY(type_src=f16,type_dst=f16,ne=[256,4,4,4],permute=[0,0,0,0]): OK
  CPY(type_src=f16,type_dst=f16,ne=[256,2,3,4],permute=[0,2,1,3]): OK
  CPY(type_src=f16,type_dst=bf16,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=bf16,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q4_0,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q4_0,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q4_1,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q4_1,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q5_0,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q5_0,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q5_1,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q5_1,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q8_0,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q8_0,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q2_K,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q2_K,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q3_K,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q3_K,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q4_K,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q4_K,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q5_K,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q5_K,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q6_K,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=q6_K,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=iq2_xxs,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f16,type_dst=iq2_xxs,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f16,type_dst=iq2_xs,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f16,type_dst=iq2_xs,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f16,type_dst=iq2_s,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=iq2_s,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=iq3_xxs,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=iq3_xxs,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=iq1_s,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f16,type_dst=iq1_s,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f16,type_dst=iq1_m,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f16,type_dst=iq1_m,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f16,type_dst=iq4_nl,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=iq4_nl,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=iq3_s,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=iq3_s,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=iq4_xs,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=iq4_xs,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=f32,ne=[256,4,4,4],permute=[0,0,0,0]): OK
  CPY(type_src=f32,type_dst=f32,ne=[256,2,3,4],permute=[0,2,1,3]): OK
  CPY(type_src=f32,type_dst=f16,ne=[256,4,4,4],permute=[0,0,0,0]): OK
  CPY(type_src=f32,type_dst=f16,ne=[256,2,3,4],permute=[0,2,1,3]): OK
  CPY(type_src=f32,type_dst=bf16,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=bf16,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q4_0,ne=[256,4,4,4],permute=[0,0,0,0]): OK
  CPY(type_src=f32,type_dst=q4_0,ne=[256,2,3,4],permute=[0,2,1,3]): OK
  CPY(type_src=f32,type_dst=q4_1,ne=[256,4,4,4],permute=[0,0,0,0]): OK
  CPY(type_src=f32,type_dst=q4_1,ne=[256,2,3,4],permute=[0,2,1,3]): OK
  CPY(type_src=f32,type_dst=q5_0,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q5_0,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q5_1,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q5_1,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q8_0,ne=[256,4,4,4],permute=[0,0,0,0]): OK
  CPY(type_src=f32,type_dst=q8_0,ne=[256,2,3,4],permute=[0,2,1,3]): OK
  CPY(type_src=f32,type_dst=q2_K,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q2_K,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q3_K,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q3_K,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q4_K,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q4_K,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q5_K,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q5_K,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q6_K,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=q6_K,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=iq2_xxs,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f32,type_dst=iq2_xxs,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f32,type_dst=iq2_xs,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f32,type_dst=iq2_xs,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f32,type_dst=iq2_s,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=iq2_s,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=iq3_xxs,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=iq3_xxs,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=iq1_s,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f32,type_dst=iq1_s,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f32,type_dst=iq1_m,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f32,type_dst=iq1_m,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0] not supported [CPU]
  CPY(type_src=f32,type_dst=iq4_nl,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=iq4_nl,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=iq3_s,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=iq3_s,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=iq4_xs,ne=[256,4,4,4],permute=[0,0,0,0]): not supported [SYCL0]
  CPY(type_src=f32,type_dst=iq4_xs,ne=[256,2,3,4],permute=[0,2,1,3]): not supported [SYCL0]
  CPY(type_src=f16,type_dst=f16,ne=[256,2,3,4],permute=[1,0,2,3]): OK
  CPY(type_src=f16,type_dst=f32,ne=[256,2,3,4],permute=[1,0,2,3]): OK
  CPY(type_src=f32,type_dst=f16,ne=[256,2,3,4],permute=[1,0,2,3]): OK
  CPY(type_src=f32,type_dst=f32,ne=[256,2,3,4],permute=[1,0,2,3]): OK
  CONT(type=f32,ne=[10,10,10,1]): OK
  CONT(type=f32,ne=[2,1,1,1]): OK
  CONT(type=f32,ne=[2,1,3,5]): OK
  CONT(type=f32,ne=[2,3,5,7]): OK
  CONT(type=f16,ne=[2,1,1,1]): OK
  CONT(type=f16,ne=[2,1,3,5]): OK
  CONT(type=f16,ne=[2,3,5,7]): OK
  CONT(type=bf16,ne=[2,1,1,1]): not supported [SYCL0]
  CONT(type=bf16,ne=[2,1,3,5]): not supported [SYCL0]
  CONT(type=bf16,ne=[2,3,5,7]): not supported [SYCL0]
  ADD(type=f32,ne=[1,1,8,1],nr=[1,1,1,1]): OK
  MUL(type=f32,ne=[1,1,8,1],nr=[1,1,1,1]): OK
  DIV(type=f32,ne=[1,1,8,1],nr=[1,1,1,1]): OK
  ADD(type=f32,ne=[1,1,1,1],nr=[32,1,1,1]): OK
  MUL(type=f32,ne=[1,1,1,1],nr=[32,1,1,1]): OK
  DIV(type=f32,ne=[1,1,1,1],nr=[32,1,1,1]): OK
  ADD(type=f32,ne=[1,1,320,320],nr=[1,1,1,1]): OK
  MUL(type=f32,ne=[1,1,320,320],nr=[1,1,1,1]): OK
  DIV(type=f32,ne=[1,1,320,320],nr=[1,1,1,1]): OK
  ADD(type=f32,ne=[10,5,1,1],nr=[1,1,1,1]): OK
  MUL(type=f32,ne=[10,5,1,1],nr=[1,1,1,1]): OK
  DIV(type=f32,ne=[10,5,1,1],nr=[1,1,1,1]): OK
  ADD(type=f32,ne=[10,5,4,1],nr=[1,1,1,1]): OK
  MUL(type=f32,ne=[10,5,4,1],nr=[1,1,1,1]): OK
  DIV(type=f32,ne=[10,5,4,1],nr=[1,1,1,1]): OK
  ADD(type=f32,ne=[10,5,4,3],nr=[1,1,1,1]): OK
  MUL(type=f32,ne=[10,5,4,3],nr=[1,1,1,1]): OK
  DIV(type=f32,ne=[10,5,4,3],nr=[1,1,1,1]): OK
  ADD(type=f32,ne=[10,5,4,3],nr=[2,1,1,1]): OK
  MUL(type=f32,ne=[10,5,4,3],nr=[2,1,1,1]): OK
  DIV(type=f32,ne=[10,5,4,3],nr=[2,1,1,1]): OK
  ADD(type=f32,ne=[10,5,4,3],nr=[1,2,1,1]): OK
  MUL(type=f32,ne=[10,5,4,3],nr=[1,2,1,1]): OK
  DIV(type=f32,ne=[10,5,4,3],nr=[1,2,1,1]): OK
  ADD(type=f32,ne=[10,5,4,3],nr=[1,1,2,1]): OK
  MUL(type=f32,ne=[10,5,4,3],nr=[1,1,2,1]): OK
  DIV(type=f32,ne=[10,5,4,3],nr=[1,1,2,1]): OK
  ADD(type=f32,ne=[10,5,4,3],nr=[1,1,1,2]): OK
  MUL(type=f32,ne=[10,5,4,3],nr=[1,1,1,2]): OK
  DIV(type=f32,ne=[10,5,4,3],nr=[1,1,1,2]): OK
  ADD(type=f32,ne=[10,5,4,3],nr=[1,1,2,2]): OK
  MUL(type=f32,ne=[10,5,4,3],nr=[1,1,2,2]): OK
  DIV(type=f32,ne=[10,5,4,3],nr=[1,1,2,2]): OK
  ADD(type=f32,ne=[10,5,4,3],nr=[1,2,2,2]): OK
  MUL(type=f32,ne=[10,5,4,3],nr=[1,2,2,2]): OK
  DIV(type=f32,ne=[10,5,4,3],nr=[1,2,2,2]): OK
  ADD(type=f32,ne=[10,5,4,3],nr=[2,2,2,2]): OK
  MUL(type=f32,ne=[10,5,4,3],nr=[2,2,2,2]): OK
  DIV(type=f32,ne=[10,5,4,3],nr=[2,2,2,2]): OK
  ADD(type=f32,ne=[1280,1,1,1],nr=[1,1,1,1]): OK
  MUL(type=f32,ne=[1280,1,1,1],nr=[1,1,1,1]): OK
  DIV(type=f32,ne=[1280,1,1,1],nr=[1,1,1,1]): OK
  ADD(type=f32,ne=[1280,1,1,1],nr=[1,16,16,1]): OK
  MUL(type=f32,ne=[1280,1,1,1],nr=[1,16,16,1]): OK
  DIV(type=f32,ne=[1280,1,1,1],nr=[1,16,16,1]): OK
  ADD(type=f32,ne=[1280,16,16,1],nr=[1,1,1,1]): OK
  MUL(type=f32,ne=[1280,16,16,1],nr=[1,1,1,1]): OK
  DIV(type=f32,ne=[1280,16,16,1],nr=[1,1,1,1]): OK
  ADD(type=f32,ne=[1280,1,1,1],nr=[1,256,1,1]): OK
  MUL(type=f32,ne=[1280,1,1,1],nr=[1,256,1,1]): OK
  DIV(type=f32,ne=[1280,1,1,1],nr=[1,256,1,1]): OK
  ADD(type=f32,ne=[1,1,1280,1],nr=[16,16,1,1]): OK
  MUL(type=f32,ne=[1,1,1280,1],nr=[16,16,1,1]): OK
  DIV(type=f32,ne=[1,1,1280,1],nr=[16,16,1,1]): OK
  ADD(type=f32,ne=[16,16,1280,1],nr=[1,1,1,1]): OK
  MUL(type=f32,ne=[16,16,1280,1],nr=[1,1,1,1]): OK
  DIV(type=f32,ne=[16,16,1280,1],nr=[1,1,1,1]): OK
  ADD(type=f32,ne=[1,1,1920,1],nr=[16,16,1,1]): OK
  MUL(type=f32,ne=[1,1,1920,1],nr=[16,16,1,1]): OK
  DIV(type=f32,ne=[1,1,1920,1],nr=[16,16,1,1]): OK
  ADD(type=f32,ne=[1,1,2560,1],nr=[16,16,1,1]): OK
  MUL(type=f32,ne=[1,1,2560,1],nr=[16,16,1,1]): OK
  DIV(type=f32,ne=[1,1,2560,1],nr=[16,16,1,1]): OK
  ADD(type=f32,ne=[1,1,1280,1],nr=[32,32,1,1]): OK
  MUL(type=f32,ne=[1,1,1280,1],nr=[32,32,1,1]): OK
  DIV(type=f32,ne=[1,1,1280,1],nr=[32,32,1,1]): OK
  ADD(type=f32,ne=[1,1,1920,1],nr=[32,32,1,1]): OK
  MUL(type=f32,ne=[1,1,1920,1],nr=[32,32,1,1]): OK
  DIV(type=f32,ne=[1,1,1920,1],nr=[32,32,1,1]): OK
  ADD(type=f32,ne=[1,1,640,1],nr=[32,32,1,1]): OK
  MUL(type=f32,ne=[1,1,640,1],nr=[32,32,1,1]): OK
  DIV(type=f32,ne=[1,1,640,1],nr=[32,32,1,1]): OK
  ADD(type=f32,ne=[5120,1,1,1],nr=[1,256,1,1]): OK
  MUL(type=f32,ne=[5120,1,1,1],nr=[1,256,1,1]): OK
  DIV(type=f32,ne=[5120,1,1,1],nr=[1,256,1,1]): OK
  ADD(type=f32,ne=[640,1,1,1],nr=[1,1,1,1]): OK
  MUL(type=f32,ne=[640,1,1,1],nr=[1,1,1,1]): OK
  DIV(type=f32,ne=[640,1,1,1],nr=[1,1,1,1]): OK
  ADD1(type=f32,ne=[10,5,4,3]): not supported [SYCL0]
  SCALE(type=f32,ne=[10,10,10,10],scale=2.000000): OK
  NORM(type=f32,ne=[64,5,4,3],eps=0.000001): OK
  RMS_NORM(type=f32,ne=[64,5,4,3],eps=0.000001): OK
  NORM(type=f32,ne=[64,5,4,3],eps=0.000010): OK
  RMS_NORM(type=f32,ne=[64,5,4,3],eps=0.000010): OK
  NORM(type=f32,ne=[64,5,4,3],eps=0.001000): OK
  RMS_NORM(type=f32,ne=[64,5,4,3],eps=0.001000): OK
  NORM(type=f32,ne=[64,5,4,3],eps=0.100000): OK
  RMS_NORM(type=f32,ne=[64,5,4,3],eps=0.100000): OK
  SSM_CONV(type=f32,ne_a=[4,1536,1,1],ne_b=[4,1536,1,1]): not supported [SYCL0]
  SSM_CONV(type=f32,ne_a=[8,1536,1,1],ne_b=[4,1536,1,1]): not supported [SYCL0]
  SSM_CONV(type=f32,ne_a=[4,1536,4,1],ne_b=[4,1536,1,1]): not supported [SYCL0]
  SSM_SCAN(type=f32,d_state=16,d_inner=1024,n_seq_tokens=32,n_seqs=4): not supported [SYCL0]
  RWKV_WKV(type=f32,head_count=32,head_size=64,n_seq_tokens=1,n_seqs=1): not supported [SYCL0]
  RWKV_WKV(type=f32,head_count=32,head_size=64,n_seq_tokens=32,n_seqs=1): not supported [SYCL0]
  RWKV_WKV(type=f32,head_count=32,head_size=64,n_seq_tokens=32,n_seqs=4): not supported [SYCL0]
  RWKV_WKV(type=f32,head_count=32,head_size=64,n_seq_tokens=128,n_seqs=4): not supported [SYCL0]
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=1,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=1,k=256,bs=[10,1],nr=[1,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=1,k=256,bs=[10,1],nr=[2,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=1,k=256,bs=[10,10],nr=[1,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=1,k=256,bs=[10,10],nr=[2,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=1,k=256,bs=[10,10],nr=[1,2],per=[0,1,2,3]): not supported [SYCL0]
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=1,k=256,bs=[10,10],nr=[2,2],per=[0,1,2,3]): not supported [SYCL0]
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=256,bs=[10,1],nr=[1,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=256,bs=[10,1],nr=[2,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=256,bs=[10,10],nr=[1,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=256,bs=[10,10],nr=[2,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=256,bs=[10,10],nr=[1,2],per=[0,1,2,3]): not supported [SYCL0]
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=256,bs=[10,10],nr=[2,2],per=[0,1,2,3]): not supported [SYCL0]
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=1,k=256,bs=[2,3],nr=[1,1],per=[0,2,1,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=1,k=256,bs=[2,3],nr=[1,1],per=[0,1,3,2]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=1,k=256,bs=[2,3],nr=[1,1],per=[0,3,2,1]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=8,k=256,bs=[2,3],nr=[1,1],per=[0,2,1,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=8,k=256,bs=[2,3],nr=[1,1],per=[0,1,3,2]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=8,k=256,bs=[2,3],nr=[1,1],per=[0,3,2,1]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=256,bs=[2,3],nr=[1,1],per=[0,2,1,3]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=256,bs=[2,3],nr=[1,1],per=[0,1,3,2]): OK
  MUL_MAT(type_a=f32,type_b=f32,m=16,n=16,k=256,bs=[2,3],nr=[1,1],per=[0,3,2,1]): OK
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=1,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=1,k=256,bs=[10,1],nr=[1,1],per=[0,1,2,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=1,k=256,bs=[10,1],nr=[2,1],per=[0,1,2,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=1,k=256,bs=[10,10],nr=[1,1],per=[0,1,2,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=1,k=256,bs=[10,10],nr=[2,1],per=[0,1,2,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=1,k=256,bs=[10,10],nr=[1,2],per=[0,1,2,3]): not supported [SYCL0] not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=1,k=256,bs=[10,10],nr=[2,2],per=[0,1,2,3]): not supported [SYCL0] not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=16,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=16,k=256,bs=[10,1],nr=[1,1],per=[0,1,2,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=16,k=256,bs=[10,1],nr=[2,1],per=[0,1,2,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=16,k=256,bs=[10,10],nr=[1,1],per=[0,1,2,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=16,k=256,bs=[10,10],nr=[2,1],per=[0,1,2,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=16,k=256,bs=[10,10],nr=[1,2],per=[0,1,2,3]): not supported [SYCL0] not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=16,k=256,bs=[10,10],nr=[2,2],per=[0,1,2,3]): not supported [SYCL0] not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=1,k=256,bs=[2,3],nr=[1,1],per=[0,2,1,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=1,k=256,bs=[2,3],nr=[1,1],per=[0,1,3,2]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=1,k=256,bs=[2,3],nr=[1,1],per=[0,3,2,1]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=8,k=256,bs=[2,3],nr=[1,1],per=[0,2,1,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=8,k=256,bs=[2,3],nr=[1,1],per=[0,1,3,2]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=8,k=256,bs=[2,3],nr=[1,1],per=[0,3,2,1]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=16,k=256,bs=[2,3],nr=[1,1],per=[0,2,1,3]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=16,k=256,bs=[2,3],nr=[1,1],per=[0,1,3,2]): not supported [CPU]
  MUL_MAT(type_a=f32,type_b=f16,m=16,n=16,k=256,bs=[2,3],nr=[1,1],per=[0,3,2,1]): not supported [CPU]
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=1,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=1,k=256,bs=[10,1],nr=[1,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=1,k=256,bs=[10,1],nr=[2,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=1,k=256,bs=[10,10],nr=[1,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=1,k=256,bs=[10,10],nr=[2,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=1,k=256,bs=[10,10],nr=[1,2],per=[0,1,2,3]): not supported [SYCL0]
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=1,k=256,bs=[10,10],nr=[2,2],per=[0,1,2,3]): not supported [SYCL0]
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=16,k=256,bs=[1,1],nr=[1,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=16,k=256,bs=[10,1],nr=[1,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=16,k=256,bs=[10,1],nr=[2,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=16,k=256,bs=[10,10],nr=[1,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=16,k=256,bs=[10,10],nr=[2,1],per=[0,1,2,3]): OK
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=16,k=256,bs=[10,10],nr=[1,2],per=[0,1,2,3]): not supported [SYCL0]
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=16,k=256,bs=[10,10],nr=[2,2],per=[0,1,2,3]): not supported [SYCL0]
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=1,k=256,bs=[2,3],nr=[1,1],per=[0,2,1,3]): [MUL_MAT] NMSE = 2.010223759 > 0.000500000 FAIL
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=1,k=256,bs=[2,3],nr=[1,1],per=[0,1,3,2]): /home/llamauser/git/ggml/src/ggml-sycl.cpp:4025: GGML_ASSERT(src0->nb[0] <= src0->nb[1] && src0->nb[2] <= src0->nb[3]) failed
```



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


