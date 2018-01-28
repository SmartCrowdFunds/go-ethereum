FROM alpine:3.7

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 https://github.com/Zamolxes-ZMX/go-zmx && \
  (cd go-zmx && make gzmx) && \
  cp go-zmx/build/bin/gzmx /gzmx && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-zmx && rm -rf /var/cache/apk/*

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/gzmx"]
