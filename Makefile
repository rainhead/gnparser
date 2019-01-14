GOCMD=go
GOBUILD=$(GOCMD) build
GOINSTALL=$(GOCMD) install
GOCLEAN=$(GOCMD) clean
GOGET=$(GOCMD) get -u
FLAG_MODULE=GO111MODULE=on
FLAGS_SHARED=${FLAG_MODULE} CGO_ENABLED=0 GOARCH=amd64
FLAGS_LINUX=${FLAGS_SHARED} GOOS=linux
FLAGS_MAC=${FLAGS_SHARED} GOOS=darwin
FLAGS_WIN=${FLAGS_SHARED} GOOS=windows

VERSION=`git describe --tags`
VER=`git describe --tags --abbrev=0`
DATE=`date -u '+%Y-%m-%d_%H:%M:%S%Z'`

all: install

test:
	${FLAG_MODULE} go test ./...

init:
	${FLAG_MODULE} $(GOGET) github.com/pointlander/peg@fa48cc2; \
	${FLAG_MODULE} $(GOGET) github.com/shurcooL/vfsgen@6a9ea43; \
	${FLAG_MODULE} $(GOGET) github.com/spf13/cobra/cobra@7547e83; \
	${FLAG_MODULE} $(GOGET) github.com/onsi/ginkgo/ginkgo@505cc35; \
	${FLAG_MODULE} $(GOGET) github.com/onsi/gomega@ce690c5; \
  ${FLAG_MODULE} $(GOGET) golang.org/x/tools/cmd/goimports

version:
	echo "package output\n\nconst Version = \"$(VERSION)\"\nconst Build = \"$(DATE)\"\n" \
	> output/version.go

peg:
	cd grammar; \
	peg grammar.peg; \
	goimports -w grammar.peg.go; \

asset:
	cd dict; \
	go run -tags=dev assets_gen.go

build: version peg
	cd gnparser; \
	$(GOCLEAN); \
	${FLAGS_SHARED} $(GOBUILD)

install: version peg
	cd gnparser; \
	$(GOCLEAN); \
	${FLAGS_SHARED} $(GOINSTALL)

release: version peg asset
	cd gnparser; \
	$(GOCLEAN); \
	${FLAGS_LINUX} $(GOBUILD) ${LDFLAGS}; \
	tar zcvf /tmp/parser-${VER}-linux.tar.gz gnparser; \
	$(GOCLEAN); \
	${FLAGS_WIN} $(GOBUILD) ${LDFLAGS}; \
	tar zcvf /tmp/gnparser-${VER}-mac.tar.gz gnparser; \
	$(GOCLEAN); \
	${FLAGS_WIN} $(GOBUILD) ${LDFLAGS}; \
	zip -9 /tmp/gnparser-${VER}-win-64.zip gnparser; \
	$(GOCLEAN);

