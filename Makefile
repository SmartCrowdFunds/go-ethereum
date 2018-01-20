# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gscf android ios gscf-cross swarm evm all test clean
.PHONY: gscf-linux gscf-linux-386 gscf-linux-amd64 gscf-linux-mips64 gscf-linux-mips64le
.PHONY: gscf-linux-arm gscf-linux-arm-5 gscf-linux-arm-6 gscf-linux-arm-7 gscf-linux-arm64
.PHONY: gscf-darwin gscf-darwin-386 gscf-darwin-amd64
.PHONY: gscf-windows gscf-windows-386 gscf-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

gscf:
	build/env.sh go run build/ci.go install ./cmd/gscf
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gscf\" to launch gscf."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gscf.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Gscf.framework\" to use the library."

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

gscf-cross: gscf-linux gscf-darwin gscf-windows gscf-android gscf-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/gscf-*

gscf-linux: gscf-linux-386 gscf-linux-amd64 gscf-linux-arm gscf-linux-mips64 gscf-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/gscf-linux-*

gscf-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/gscf
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/gscf-linux-* | grep 386

gscf-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gscf
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gscf-linux-* | grep amd64

gscf-linux-arm: gscf-linux-arm-5 gscf-linux-arm-6 gscf-linux-arm-7 gscf-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/gscf-linux-* | grep arm

gscf-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/gscf
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/gscf-linux-* | grep arm-5

gscf-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/gscf
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/gscf-linux-* | grep arm-6

gscf-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/gscf
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/gscf-linux-* | grep arm-7

gscf-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/gscf
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/gscf-linux-* | grep arm64

gscf-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/gscf
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/gscf-linux-* | grep mips

gscf-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/gscf
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/gscf-linux-* | grep mipsle

gscf-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/gscf
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/gscf-linux-* | grep mips64

gscf-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/gscf
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/gscf-linux-* | grep mips64le

gscf-darwin: gscf-darwin-386 gscf-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/gscf-darwin-*

gscf-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/gscf
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/gscf-darwin-* | grep 386

gscf-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gscf
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gscf-darwin-* | grep amd64

gscf-windows: gscf-windows-386 gscf-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/gscf-windows-*

gscf-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/gscf
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/gscf-windows-* | grep 386

gscf-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/gscf
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gscf-windows-* | grep amd64
