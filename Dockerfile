

#
# docker build -t bbissell/llama-cpp-mkl:b3467
#
FROM intel/oneapi-basekit:latest AS build

RUN useradd -m --uid 1010 llamauser
USER 1010:1010
WORKDIR /home/llamauser

ARG LLAMACPP_VERSION_TAG=b3467
ENV LLAMACPP_VERSION=${LLAMACPP_VERSION_TAG}

RUN git clone --depth 1 --branch "${LLAMACPP_VERSION_TAG}" https://github.com/ggerganov/llama.cpp.git git

# ADD 
# RUN git clone https://github.com/ggerganov/llama.cpp.git#b3467 git
# COPY b3467.zip .
# RUN tar -xvf b3467.zip

RUN ls -al
WORKDIR /home/llamauser/git/
RUN ls -al

# source /opt/intel/oneapi/setvars.sh # You can skip this step if  in oneapi-basekit docker image, only required for manual installation
RUN cmake -B build -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=Intel10_64lp -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx -DGGML_NATIVE=ON
RUN cmake --build build --config Release

## Volumes
VOLUME [ "/var/models" ]

## Run phase
WORKDIR /home/llamauser/git/build/bin
EXPOSE 8080

COPY lf.sh .
CMD ./lf.sh
