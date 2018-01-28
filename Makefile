# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gzmx android ios gzmx-cross swarm evm all test clean
.PHONY: gzmx-linux gzmx-linux-386 gzmx-linux-amd64 gzmx-linux-mips64 gzmx-linux-mips64le
.PHONY: gzmx-linux-arm gzmx-linux-arm-5 gzmx-linux-arm-6 gzmx-linux-arm-7 gzmx-linux-arm64
.PHONY: gzmx-darwin gzmx-darwin-386 gzmx-darwin-amd64
.PHONY: gzmx-windows gzmx-windows-386 gzmx-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

gzmx:
	build/env.sh go run build/ci.go install ./cmd/gzmx
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gzmx\" to launch gzmx."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gzmx.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gzmx.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

gzmx-cross: gzmx-linux gzmx-darwin gzmx-windows gzmx-android gzmx-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-*

gzmx-linux: gzmx-linux-386 gzmx-linux-amd64 gzmx-linux-arm gzmx-linux-mips64 gzmx-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-linux-*

gzmx-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/gzmx
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-linux-* | grep 386

gzmx-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gzmx
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-linux-* | grep amd64

gzmx-linux-arm: gzmx-linux-arm-5 gzmx-linux-arm-6 gzmx-linux-arm-7 gzmx-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-linux-* | grep arm

gzmx-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/gzmx
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-linux-* | grep arm-5

gzmx-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/gzmx
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-linux-* | grep arm-6

gzmx-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/gzmx
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-linux-* | grep arm-7

gzmx-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/gzmx
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-linux-* | grep arm64

gzmx-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/gzmx
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-linux-* | grep mips

gzmx-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/gzmx
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-linux-* | grep mipsle

gzmx-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/gzmx
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-linux-* | grep mips64

gzmx-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/gzmx
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-linux-* | grep mips64le

gzmx-darwin: gzmx-darwin-386 gzmx-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-darwin-*

gzmx-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/gzmx
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-darwin-* | grep 386

gzmx-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gzmx
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-darwin-* | grep amd64

gzmx-windows: gzmx-windows-386 gzmx-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-windows-*

gzmx-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/gzmx
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-windows-* | grep 386

gzmx-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/gzmx
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gzmx-windows-* | grep amd64
