#!/bin/bash

LINKFLAGS=${LINKFLAGS:-"-extldflags -static -s"} CGO_ENABLED=0 go build -ldflags "-X github.com/rancher/k3os/pkg/version.Version=$VERSION $LINKFLAGS" 
