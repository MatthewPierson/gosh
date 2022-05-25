SRC := go.sum $(shell git ls-files -cmo --exclude-standard -- "*.go")
TESTABLE := ./...


bin/golangci-lint: GOARCH =
bin/golangci-lint: GOOS =
bin/golangci-lint: go.sum
	@go build -o $@ github.com/golangci/golangci-lint/cmd/golangci-lint

bin/go-acc: GOARCH =
bin/go-acc: GOOS =
bin/go-acc: go.sum
	@go build -o $@ github.com/ory/go-acc

lint: CGO_ENABLED = 1
lint: GOARCH =
lint: GOOS =
lint: bin/golangci-lint $(SRC)
	$< run

tidy:
	go mod tidy

dirty: tidy
	git status --porcelain
	@[ -z "$$(git status --porcelain)" ]

vet: GOARCH =
vet: GOOS =
vet: CGO_ENABLED =
vet: bin/go-acc $(SRC)
	$< --covermode=atomic $(TESTABLE) -- -race -v