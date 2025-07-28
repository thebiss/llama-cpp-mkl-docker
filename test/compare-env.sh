#!
podman run -it localhost/thebiss/llama-cpp-mkl-gpu:latest /bin/bash -c env | sort > env.mkl-gpu.log
podman run -it localhost/thebiss/llama-cpp-mkl:latest /bin/bash -c env | sort > env.mkl.log
