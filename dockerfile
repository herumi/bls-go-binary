FROM ubuntu:22.04 as bls-go-binary-build

RUN apt update && apt -y install curl nasm build-essential llvm clang-14
RUN if [ "$(uname -m)" = "x86_64" ] ; then curl -L -o go1.20.4.tar.gz https://go.dev/dl/go1.20.4.linux-amd64.tar.gz ; else curl -L -o go1.20.4.tar.gz https://go.dev/dl/go1.20.4.linux-arm64.tar.gz ; fi
RUN tar -C /usr/local -xzf go1.20.4.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin
ENV PATH=$PATH:/usr/local/go/bin
RUN go version

RUN update-alternatives --verbose \
      --install /usr/bin/clang                 clang                 /usr/bin/clang-14 100 \
      --slave   /usr/bin/clang++               clang++               /usr/bin/clang++-14  \
      --slave   /usr/bin/clang-cpp             clang-cpp             /usr/bin/clang-cpp-14

WORKDIR /usr/local/bls-go-binary

# Download the dependencies:
# Will be cached if we don't change mod/sum files
COPY ./go.mod ./go.sum ./
RUN go mod download

COPY .  .


RUN make clean
RUN mkdir -p ./bls/lib/linux/

RUN make CXX=clang++ ARCH=x86_64
RUN make CXX=clang++ ARCH=amd64

FROM scratch AS bls-go-binary-export
COPY --from=bls-go-binary-build /usr/local/bls-go-binary/bls/lib/linux/ /bls/lib/linux/