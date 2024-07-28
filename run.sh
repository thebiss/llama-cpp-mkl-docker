#! /bin/bash
docker run \
    -it \
    -v $HOME/dev-in-wsl/models:/var/models \
    -p 8080:8080 \
    bbissell/llama-cpp-mkl:b3467 
