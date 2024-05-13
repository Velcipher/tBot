APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=ghcr.io/velcipher
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64 


UNAME_P := $(shell uname -p)
ifeq ($(UNAME_P),unknown)
	UNAME_P:=$(shell uname -m)
endif
ifeq ($(UNAME_P),x86_64)
	TARGETARCH=amd64
endif
ifneq ($(filter arm%,$(UNAME_P)),)
	TARGETARCH:=arm64
endif

format:
	gofmt -s -w ./

get:
	go get


build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o tbot -ldflags "-X="github.com/velcipher/tbot/cmd.appVersion=${VERSION}

lint:
	golint

test:
	go test -v

image:
	@echo ${TARGETARCH}
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	(docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} || true) && (rm -rf tbot || true)

linux: 
	make TARGETOS=linux TARGETARCH=amd64 build

windows:
	make TARGETOS=windows TARGETARCH=amd64 build

arm:
	make TARGETOS=linux TARGETARCH=arm64 build

macos:
	make TARGETOS=darwin build


