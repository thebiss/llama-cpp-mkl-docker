
# Testing iGPU performance

## Note: this isn't a fully working setup
### `test-backend-ops` will fail on an assertion error
```
MUL_MAT(type_a=f16,type_b=f32,m=16,n=16,k=256,bs=[10,10],nr=[2,2],per=[0,1,2,3]): not supported [SYCL0]
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=1,k=256,bs=[2,3],nr=[1,1],per=[0,2,1,3]): [MUL_MAT] NMSE = 3.049388410 > 0.000500000 FAIL
  MUL_MAT(type_a=f16,type_b=f32,m=16,n=1,k=256,bs=[2,3],nr=[1,1],per=[0,1,3,2]): /home/llamauser/git/ggml/src/ggml-sycl.cpp:3176: GGML_ASSERT(src0->nb[0] <= src0->nb[1] && src0->nb[2] <= src0->nb[3]) failed
```

### `llama-bench` also fails, on a work-group size error

```
./llama-bench-granite-a400m.sh
Additional parameters from $LLAMA_BENCH_OPTS:
ggml_sycl_init: GGML_SYCL_FORCE_MMQ:   no
ggml_sycl_init: SYCL_USE_XMX: yes
ggml_sycl_init: found 1 SYCL devices:
| model                          |       size |     params | backend    | ngl |          test |                  t/s |
| ------------------------------ | ---------: | ---------: | ---------- | --: | ------------: | -------------------: |
get_memory_info: [warning] ext_intel_free_memory is not supported (export/set ZES_ENABLE_SYSMAN=1 to support), use total memory as free memory
get_memory_info: [warning] ext_intel_free_memory is not supported (export/set ZES_ENABLE_SYSMAN=1 to support), use total memory as free memory
get_memory_info: [warning] ext_intel_free_memory is not supported (export/set ZES_ENABLE_SYSMAN=1 to support), use total memory as free memory
[SYCL] call ggml_check_sycl
ggml_check_sycl: GGML_SYCL_DEBUG: 0
ggml_check_sycl: GGML_SYCL_F16: yes
found 1 SYCL devices:
|  |                   |                                       |       |Max    |        |Max  |Global |                     |
|  |                   |                                       |       |compute|Max work|sub  |mem    |                     |
|ID|        Device Type|                                   Name|Version|units  |group   |group|size   |       Driver version|
|--|-------------------|---------------------------------------|-------|-------|--------|-----|-------|---------------------|
| 0| [level_zero:gpu:0]|                Intel Graphics [0x9a49]|    1.3|     80|     512|   32| 15538M|            1.3.27642|
The number of work-items in each dimension of a work-group cannot exceed {512, 512, 512} for this device -54 (PI_ERROR_INVALID_WORK_GROUP_SIZE)Exception caught at file:/home/llamauser/git/ggml/src/ggml-sycl.cpp, line:3699
llamauser@04c6ce7aeee5:~$
```

## `llama-server` commands
- 4k context
- all layers to GPU

```bash
# from parent shell
./test-gpu.sh
# from container shell
$LLAMA_SERVER_BIN -m /var/models/ibm/granite-3.0/granite-3.0-8b-instruct-Q4_K_M.gguf -c 4096 --host 0.0.0.0 -ngl 99
```

## Output
```
llamauser@04c6ce7aeee5:~$ $LLAMA_SERVER_BIN -m /var/models/ibm/granite-3.0/granite-3.0-8b-instruct-Q4_K_M.gguf -c 4096 --host 0.0.0.0 -ngl
99
ggml_sycl_init: GGML_SYCL_FORCE_MMQ:   no
ggml_sycl_init: SYCL_USE_XMX: yes
ggml_sycl_init: found 1 SYCL devices:
build: 1 (b0cefea) with Intel(R) oneAPI DPC++/C++ Compiler 2024.2.1 (2024.2.1.20240711) for x86_64-unknown-linux-gnu
system info: n_threads = 4, n_threads_batch = 4, total_threads = 8

system_info: n_threads = 4 (n_threads_batch = 4) / 8 | AVX = 1 | AVX_VNNI = 0 | AVX2 = 1 | AVX512 = 1 | AVX512_VBMI = 1 | AVX512_VNNI = 1 | AVX512_BF16 = 0 | AMX_INT8 = 0 | FMA = 1 | NEON = 0 | SVE = 0 | ARM_FMA = 0 | F16C = 1 | FP16_VA = 0 | RISCV_VECT = 0 | WASM_SIMD = 0 | BLAS = 1 | SSE3 = 1 | SSSE3 = 1 | VSX = 0 | MATMUL_INT8 = 0 | LLAMAFILE = 1 |

main: HTTP server is listening, hostname: 0.0.0.0, port: 8080, http threads: 7
main: loading model
get_memory_info: [warning] ext_intel_free_memory is not supported (export/set ZES_ENABLE_SYSMAN=1 to support), use total memory as free memory
llama_load_model_from_file: using device SYCL0 (Intel(R) Graphics [0x9a49]) - 14818 MiB free
llama_model_loader: loaded meta data with 36 key-value pairs and 362 tensors from /var/models/ibm/granite-3.0/granite-3.0-8b-instruct-Q4_K_M.gguf (version GGUF V3 (latest))
llama_model_loader: Dumping metadata keys/values. Note: KV overrides do not apply in this output.
llama_model_loader: - kv   0:                       general.architecture str              = granite
llama_model_loader: - kv   1:                               general.type str              = model
llama_model_loader: - kv   2:                               general.name str              = Granite 3.0 8b Instruct
llama_model_loader: - kv   3:                           general.finetune str              = instruct
llama_model_loader: - kv   4:                           general.basename str              = granite-3.0
llama_model_loader: - kv   5:                         general.size_label str              = 8B
llama_model_loader: - kv   6:                            general.license str              = apache-2.0
llama_model_loader: - kv   7:                               general.tags arr[str,3]       = ["language", "granite-3.0", "text-gen...
llama_model_loader: - kv   8:                        granite.block_count u32              = 40
llama_model_loader: - kv   9:                     granite.context_length u32              = 4096
llama_model_loader: - kv  10:                   granite.embedding_length u32              = 4096
llama_model_loader: - kv  11:                granite.feed_forward_length u32              = 12800
llama_model_loader: - kv  12:               granite.attention.head_count u32              = 32
llama_model_loader: - kv  13:            granite.attention.head_count_kv u32              = 8
llama_model_loader: - kv  14:                     granite.rope.freq_base f32              = 10000.000000
llama_model_loader: - kv  15:   granite.attention.layer_norm_rms_epsilon f32              = 0.000010
llama_model_loader: - kv  16:                          general.file_type u32              = 15
llama_model_loader: - kv  17:                         granite.vocab_size u32              = 49155
llama_model_loader: - kv  18:               granite.rope.dimension_count u32              = 128
llama_model_loader: - kv  19:            tokenizer.ggml.add_space_prefix bool             = false
llama_model_loader: - kv  20:                    granite.attention.scale f32              = 0.007812
llama_model_loader: - kv  21:                    granite.embedding_scale f32              = 12.000000
llama_model_loader: - kv  22:                     granite.residual_scale f32              = 0.220000
llama_model_loader: - kv  23:                        granite.logit_scale f32              = 16.000000
llama_model_loader: - kv  24:                       tokenizer.ggml.model str              = gpt2
llama_model_loader: - kv  25:                         tokenizer.ggml.pre str              = refact
llama_model_loader: - kv  26:                      tokenizer.ggml.tokens arr[str,49155]   = ["<|end_of_text|>", "<fim_prefix>", "...
llama_model_loader: - kv  27:                  tokenizer.ggml.token_type arr[i32,49155]   = [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, ...
llama_model_loader: - kv  28:                      tokenizer.ggml.merges arr[str,48891]   = ["Ġ Ġ", "ĠĠ ĠĠ", "ĠĠĠĠ ĠĠ...
llama_model_loader: - kv  29:                tokenizer.ggml.bos_token_id u32              = 0
llama_model_loader: - kv  30:                tokenizer.ggml.eos_token_id u32              = 0
llama_model_loader: - kv  31:            tokenizer.ggml.unknown_token_id u32              = 0
llama_model_loader: - kv  32:            tokenizer.ggml.padding_token_id u32              = 0
llama_model_loader: - kv  33:               tokenizer.ggml.add_bos_token bool             = false
llama_model_loader: - kv  34:                    tokenizer.chat_template str              = {%- if tools %}\n    {{- '<|start_of_r...
llama_model_loader: - kv  35:               general.quantization_version u32              = 2
llama_model_loader: - type  f32:   81 tensors
llama_model_loader: - type q4_K:  240 tensors
llama_model_loader: - type q6_K:   41 tensors
llm_load_vocab: special_eos_id is not in special_eog_ids - the tokenizer config may be incorrect
llm_load_vocab: special tokens cache size = 22
get_memory_info: [warning] ext_intel_free_memory is not supported (export/set ZES_ENABLE_SYSMAN=1 to support), use total memory as free memory
llm_load_vocab: token to piece cache size = 0.2826 MB
llm_load_print_meta: format           = GGUF V3 (latest)
llm_load_print_meta: arch             = granite
llm_load_print_meta: vocab type       = BPE
llm_load_print_meta: n_vocab          = 49155
llm_load_print_meta: n_merges         = 48891
llm_load_print_meta: vocab_only       = 0
llm_load_print_meta: n_ctx_train      = 4096
llm_load_print_meta: n_embd           = 4096
llm_load_print_meta: n_layer          = 40
llm_load_print_meta: n_head           = 32
llm_load_print_meta: n_head_kv        = 8
llm_load_print_meta: n_rot            = 128
llm_load_print_meta: n_swa            = 0
llm_load_print_meta: n_embd_head_k    = 128
llm_load_print_meta: n_embd_head_v    = 128
llm_load_print_meta: n_gqa            = 4
llm_load_print_meta: n_embd_k_gqa     = 1024
llm_load_print_meta: n_embd_v_gqa     = 1024
llm_load_print_meta: f_norm_eps       = 0.0e+00
llm_load_print_meta: f_norm_rms_eps   = 1.0e-05
llm_load_print_meta: f_clamp_kqv      = 0.0e+00
llm_load_print_meta: f_max_alibi_bias = 0.0e+00
llm_load_print_meta: f_logit_scale    = 1.6e+01
llm_load_print_meta: n_ff             = 12800
llm_load_print_meta: n_expert         = 0
llm_load_print_meta: n_expert_used    = 0
llm_load_print_meta: causal attn      = 1
llm_load_print_meta: pooling type     = 0
llm_load_print_meta: rope type        = 0
llm_load_print_meta: rope scaling     = linear
llm_load_print_meta: freq_base_train  = 10000.0
llm_load_print_meta: freq_scale_train = 1
llm_load_print_meta: n_ctx_orig_yarn  = 4096
llm_load_print_meta: rope_finetuned   = unknown
llm_load_print_meta: ssm_d_conv       = 0
llm_load_print_meta: ssm_d_inner      = 0
llm_load_print_meta: ssm_d_state      = 0
llm_load_print_meta: ssm_dt_rank      = 0
llm_load_print_meta: ssm_dt_b_c_rms   = 0
llm_load_print_meta: model type       = 3B
llm_load_print_meta: model ftype      = Q4_K - Medium
llm_load_print_meta: model params     = 8.17 B
llm_load_print_meta: model size       = 4.60 GiB (4.84 BPW)
llm_load_print_meta: general.name     = Granite 3.0 8b Instruct
llm_load_print_meta: BOS token        = 0 '<|end_of_text|>'
llm_load_print_meta: EOS token        = 0 '<|end_of_text|>'
llm_load_print_meta: UNK token        = 0 '<|end_of_text|>'
llm_load_print_meta: PAD token        = 0 '<|end_of_text|>'
llm_load_print_meta: LF token         = 145 'Ä'
llm_load_print_meta: EOG token        = 0 '<|end_of_text|>'
llm_load_print_meta: max token length = 512
llm_load_print_meta: f_embedding_scale = 12.000000
llm_load_print_meta: f_residual_scale  = 0.220000
llm_load_print_meta: f_attention_scale = 0.007812
get_memory_info: [warning] ext_intel_free_memory is not supported (export/set ZES_ENABLE_SYSMAN=1 to support), use total memory as free memory
llm_load_tensors: offloading 40 repeating layers to GPU
llm_load_tensors: offloading output layer to GPU
llm_load_tensors: offloaded 41/41 layers to GPU
llm_load_tensors:   CPU_Mapped model buffer size =   157.51 MiB
llm_load_tensors:        SYCL0 model buffer size =  4712.21 MiB
................................................................................................
llama_new_context_with_model: n_seq_max     = 1
llama_new_context_with_model: n_ctx         = 4096
llama_new_context_with_model: n_ctx_per_seq = 4096
llama_new_context_with_model: n_batch       = 2048
llama_new_context_with_model: n_ubatch      = 512
llama_new_context_with_model: flash_attn    = 0
llama_new_context_with_model: freq_base     = 10000.0
llama_new_context_with_model: freq_scale    = 1
[SYCL] call ggml_check_sycl
ggml_check_sycl: GGML_SYCL_DEBUG: 0
ggml_check_sycl: GGML_SYCL_F16: yes
found 1 SYCL devices:
|  |                   |                                       |       |Max    |        |Max  |Global |                     |
|  |                   |                                       |       |compute|Max work|sub  |mem    |                     |
|ID|        Device Type|                                   Name|Version|units  |group   |group|size   |       Driver version|
|--|-------------------|---------------------------------------|-------|-------|--------|-----|-------|---------------------|
| 0| [level_zero:gpu:0]|                Intel Graphics [0x9a49]|    1.3|     80|     512|   32| 15538M|            1.3.27642|
llama_kv_cache_init:      SYCL0 KV buffer size =   640.00 MiB
llama_new_context_with_model: KV self size  =  640.00 MiB, K (f16):  320.00 MiB, V (f16):  320.00 MiB
llama_new_context_with_model:  SYCL_Host  output buffer size =     0.19 MiB
llama_new_context_with_model:      SYCL0 compute buffer size =   296.00 MiB
llama_new_context_with_model:  SYCL_Host compute buffer size =    16.01 MiB
llama_new_context_with_model: graph nodes  = 1368
llama_new_context_with_model: graph splits = 2
common_init_from_params: warming up the model with an empty run - please wait ... (--no-warmup to disable)
srv          init: initializing slots, n_slots = 1
slot         init: id  0 | task -1 | new slot n_ctx_slot = 4096
main: model loaded
main: chat template, built_in: 1, chat_example: '<|start_of_role|>system<|end_of_role|>You are a helpful assistant<|end_of_text|>
<|start_of_role|>user<|end_of_role|>Hello<|end_of_text|>
<|start_of_role|>assistant<|end_of_role|>Hi there<|end_of_text|>
<|start_of_role|>user<|end_of_role|>How are you?<|end_of_text|>
<|start_of_role|>assistant<|end_of_role|>
'
main: server is listening on http://0.0.0.0:8080 - starting the main loop
srv  update_slots: all slots are idle
slot launch_slot_: id  0 | task 0 | processing task
slot update_slots: id  0 | task 0 | new prompt, n_ctx_slot = 4096, n_keep = 0, n_prompt_tokens = 177
slot update_slots: id  0 | task 0 | kv cache rm [0, end)
slot update_slots: id  0 | task 0 | prompt processing progress, n_past = 177, n_tokens = 177, progress = 1.000000
slot update_slots: id  0 | task 0 | prompt done, n_past = 177, n_tokens = 177
slot      release: id  0 | task 0 | stop processing: n_past = 450, truncated = 0
slot print_timing: id  0 | task 0 |
prompt eval time =    7250.69 ms /   177 tokens (   40.96 ms per token,    24.41 tokens per second)
       eval time =   92121.16 ms /   274 tokens (  336.21 ms per token,     2.97 tokens per second)
      total time =   99371.85 ms /   451 tokens
srv  update_slots: all slots are idle
llamauser@04c6ce7aeee5:~$ 
```