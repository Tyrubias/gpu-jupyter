# Uses trick from https://stackoverflow.com/a/20671804
JUPYTER_PASSWORD ?= $(shell stty -echo; read -p "Password: " pwd; stty echo; echo $$pwd)
STACKS_COMMIT_HASH ?= latest
BUILD_DIR := ./.build/

export DOCKER_BUILDKIT := 1

.PHONY: config

build: $(shell find $(BUILD_DIR) -maxdepth 1 -type f)
	docker build --rm --force-rm -t ghcr.io/tyrubias/gpu-playground:latest ./.build/

# Uses trick from https://stackoverflow.com/a/33594470
config: $(BUILD_DIR)

$(BUILD_DIR): $(shell find ./src/ -type f)
	./generate-Dockerfile.sh -c $(STACKS_COMMIT_HASH) --password $(JUPYTER_PASSWORD)

clean:
	docker rmi gpu-playground:latest

cleanall:
	rm -rf $(BUILD_DIR)

pushall:
	docker push --all-tags ghcr.io/tyrubias/gpu-playground
