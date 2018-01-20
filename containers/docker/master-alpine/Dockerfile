FROM alpine:3.7

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 --branch release/1.7 https://github.com/SmartCrowdFunds/smartcrowdfunds-blockchain && \
  (cd go-ethereum && make gscf) && \
  cp go-ethereum/build/bin/gscf /gscf && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-ethereum && rm -rf /var/cache/apk/*

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/gscf"]
