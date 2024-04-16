# VERSION=$(shell git describe --tags --abbrev=0)-$(shell rev-parse --short HEAD)
APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=ilonamohilnikova
VERSION=v1.0.6-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64 
format:
	gofmt -s -w ./

get:
	go get


build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o tbot -ldflags "-X="github.com/Velcipher/tbot/cmd.appVersion=${VERSION}

lint:
	golint

test:
	go test -v

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf tbot


