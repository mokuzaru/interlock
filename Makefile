SHELL = /bin/bash
GO ?= go
GO_VERSION = $(shell ${GO} version | cut -d' ' -f 3)
BUILD_GOPATH = $(CURDIR)
BUILD_TAGS = ""
BUILD_USER = $(shell whoami)
BUILD_HOST = $(shell hostname)
BUILD_DATE = $(shell /bin/date -u "+%Y-%m-%d %H:%M:%S")
BUILD = ${BUILD_USER}@${BUILD_HOST} on ${BUILD_DATE}
REV = $(shell git rev-parse --short HEAD 2> /dev/null)

all: build

build:
	@echo "compiling INTERLOCK ${REV} (${BUILD} with ${GO_VERSION})"
	@if test "$(shell echo -e "${GO_VERSION}\ngo1.5" | sort -V | tail -n 1)" != "go1.5"; then \
		echo "detected go version >= 1.5"; \
		cd src && GOPATH="${BUILD_GOPATH}" $(GO) build -v -tags ${BUILD_TAGS} -ldflags "-s -w -X 'main.INTERLOCKBuild=${BUILD} ${BUILD_TAGS}' -X 'main.INTERLOCKRevision=${REV}'" -o ../interlock; \
	else \
		echo "detected go version < 1.5"; \
		cd src && GOPATH="${BUILD_GOPATH}" $(GO) build -v -tags ${BUILD_TAGS} -ldflags "-s -w -X main.INTERLOCKBuild \"${BUILD} ${BUILD_TAGS}\" -X main.INTERLOCKRevision \"${REV}\"" -o ../interlock; \
	fi
	@echo "done compiling INTERLOCK"

with_signal: BUILD_GOPATH = "$(CURDIR):${GOPATH}"
with_signal: BUILD_TAGS = "signal"
with_signal: build
