FROM golang:1.17.6-bullseye as builder

ARG S3_BUCKET_NAME
ARG S3_REGION
ARG S3_REGION_ENDPOINT
ENV PATH $PATH:/usr/local/go/bin
ENV GO111MODULE on
ENV CGO_ENABLED=0
ENV IPFS_PATH /workspace/.ipfs
WORKDIR /workspace

COPY . .

# Install instructions from https://github.com/ipfs/go-ds-s3#bundling
RUN git clone --depth 1 --branch v0.11.0 https://github.com/ipfs/go-ipfs && \
    cd go-ipfs && \
    go get github.com/ipfs/go-ds-s3/plugin@1ad440b && \
    cd $GOPATH/pkg/mod/github.com/ipfs/go-ds-s3@v0.8.0 && \
    git apply /workspace/remove_path_style.diff && \
    cd /workspace/go-ipfs && \
    go install github.com/ipfs/go-ds-s3/plugin && \
    cp ../preload_list plugin/loader/preload_list && \
    make build && go mod tidy && make build

RUN cp /workspace/go-ipfs/cmd/ipfs/ipfs /usr/local/bin/

RUN go-ipfs/cmd/ipfs/ipfs init && \
    python3 configure.py --base-dir=/workspace/.ipfs \
        --bucket=$S3_BUCKET_NAME \
        --region=$S3_REGION \
        --region-endpoint=$S3_REGION_ENDPOINT && \
    ipfs config --bool Experimental.AcceleratedDHTClient true && \
    ipfs config Reprovider.Strategy roots && \
    ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001 && \
    ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080

FROM ubuntu:20.04

WORKDIR /app
ENV IPFS_PATH /app/.ipfs
EXPOSE 4001/tcp
EXPOSE 4001/udp
EXPOSE 5001/tcp
EXPOSE 8080/tcp

COPY --from=builder /etc/ssl/ /etc/ssl
COPY --from=builder /workspace/go-ipfs/cmd/ipfs/ipfs /usr/local/bin/
COPY --from=builder /workspace/.ipfs/ /app/.ipfs

ENTRYPOINT ["ipfs", "daemon"]
