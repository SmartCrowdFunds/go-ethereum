.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/Zamolxes-ZMX/go-zmx/cmd/swarm
	go build -o bin/gzmx     github.com/Zamolxes-ZMX/go-zmx/cmd/gzmx
	go build -o bin/bootnode github.com/Zamolxes-ZMX/go-zmx/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/Zamolxes-ZMX/go-zmx/swarm/...
