# s3-ipfs
IPFS with go-ds-s3 plugin for S3 datastore.


## How to run

1. Install Docker. (docker-compose is optional)
2. Create an s3 bucket with acceleration endpoint enabled.
3. Set the following environment variables for building image: `S3_BUCKET`, `S3_REGION`, `S3_REGION_ENDPOINT`.
4. Run `bash build.sh` to build the image.
5. Set the following environment variables for running the container: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`.
6. Run with `docker run --restart always -dt -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY s3-ipfs:latest`. Alternatively, run with `docker-compose up -d`.

Example container log when successfully running the container:

```
Initializing daemon...
go-ipfs version: 0.11.0-67220ed-dirty
Repo version: 11
System version: amd64/linux
Golang version: go1.17.6
2022/01/18 19:13:28 failed to sufficiently increase receive buffer size (was: 208 kiB, wanted: 2048 kiB, got: 416 kiB). See https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size for details.
Swarm listening on /ip4/127.0.0.1/tcp/4001
Swarm listening on /ip4/127.0.0.1/udp/4001/quic
Swarm listening on /ip4/172.17.0.2/tcp/4001
Swarm listening on /ip4/172.17.0.2/udp/4001/quic
Swarm listening on /p2p-circuit
Swarm announcing /ip4/127.0.0.1/tcp/4001
Swarm announcing /ip4/127.0.0.1/udp/4001/quic
Swarm announcing /ip4/172.17.0.2/tcp/4001
Swarm announcing /ip4/172.17.0.2/udp/4001/quic
Swarm announcing /ip4/54.205.148.172/udp/4001/quic
API server listening on /ip4/0.0.0.0/tcp/5001
WebUI: http://0.0.0.0:5001/webui
Gateway (readonly) server listening on /ip4/0.0.0.0/tcp/8080
Daemon is ready
```
