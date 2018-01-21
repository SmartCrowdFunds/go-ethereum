FROM alpine:3.7

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 https://github.com/SmartCrowdFunds/go-scft && \
  (cd go-scft && make gscf) && \
  cp go-scft/build/bin/gscf /gscf && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-scft && rm -rf /var/cache/apk/*

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/gscf"]
