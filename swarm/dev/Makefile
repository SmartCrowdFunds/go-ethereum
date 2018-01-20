.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/SmartCrowdFunds/smartcrowdfunds-blockchain/cmd/swarm
	go build -o bin/gscf     github.com/SmartCrowdFunds/smartcrowdfunds-blockchain/cmd/gscf
	go build -o bin/bootnode github.com/SmartCrowdFunds/smartcrowdfunds-blockchain/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/SmartCrowdFunds/smartcrowdfunds-blockchain/swarm/...
