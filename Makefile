GOBIN ?= ${GOPATH}/bin
IMG   ?= tackle2-addon-windup:latest
CONTAINER_RUNTIME := $(shell command -v podman 2> /dev/null || echo docker)

all: cmd

fmt:
	go fmt ./...

vet:
	go vet ./...

test:
	# Go test ./...
	echo "not implemented" && false

build-image:
	${CONTAINER_RUNTIME} build -t ${IMG} .

cmd: fmt vet
	go build -ldflags="-w -s" -o bin/addon github.com/konveyor/tackle2-addon-windup/cmd

.PHONY: start-minikube
START_MINIKUBE = ./bin/start-minikube.sh
start-minikube:
ifeq (,$(wildcard $(START_MINIKUBE)))
	@{ \
	set -e ;\
	mkdir -p $(dir $(START_MINIKUBE)) ;\
	curl -sSLo $(START_MINIKUBE) https://raw.githubusercontent.com/konveyor/tackle2-operator/main/hack/start-minikube.sh ;\
	chmod +x $(START_MINIKUBE) ;\
	}
endif
	$(START_MINIKUBE)
