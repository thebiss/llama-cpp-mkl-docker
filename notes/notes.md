
## Current running version
    6153dacbaac2
    https://github.com/ggerganov/llama.cpp/releases/tag/b3423

#  docker build -t bbissell/llama-cpp-mkl:b3467

docker run -v $HOME/dev-in-wsl/models:/var/models -p 127.0.0.1:8080:8080 bbissell/llama-cpp-mkl:b3467 