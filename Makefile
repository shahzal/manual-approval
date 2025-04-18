IMAGE_REPO=ghcr.io/shahzal/manual-approval
TARGET_PLATFORM=linux/amd64

.PHONY: build
build:
	@if [ -z "$$VERSION" ]; then \
		echo "VERSION is required"; \
		exit 1; \
	fi
	docker build --no-cache --platform $(TARGET_PLATFORM) -t $(IMAGE_REPO):$$VERSION .

.PHONY: push
push:
	@if [ -z "$$VERSION" ]; then \
		echo "VERSION is required"; \
		exit 1; \
	fi
	docker login ghcr.io -u $$GITHUB_ACTOR -p $$GITHUB_TOKEN
	docker tag $(IMAGE_REPO):$$VERSION $(IMAGE_REPO):latest
	docker push $(IMAGE_REPO):$$VERSION
	docker push $(IMAGE_REPO):latest

.PHONY: test
test:
	go test -v .

.PHONY: lint
lint:
	docker run --rm -v $$(pwd):/app -w /app golangci/golangci-lint:v1.46.2 golangci-lint run -v
