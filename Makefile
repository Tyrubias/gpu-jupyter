# Uses trick from https://stackoverflow.com/a/20671804
JUPYTER_PASSWORD ?= $(shell stty -echo; read -p "Password: " pwd; stty echo; echo $$pwd)
STACKS_COMMIT_HASH ?= latest

BUILD_DIR := ./.build/
REPOSITORY := ghcr.io/tyrubias/gpu-playground
TAG ?= latest

export DOCKER_BUILDKIT := 1

.PHONY: config clean cleanall

build: $(shell find $(BUILD_DIR) -maxdepth 1 -type f)
	docker build --rm --force-rm -t $(REPOSITORY):$(TAG) ./.build/

# Uses trick from https://stackoverflow.com/a/33594470
config: $(BUILD_DIR)

$(BUILD_DIR): DARGS?=
$(BUILD_DIR): $(shell find ./src/ -type f)
	./generate-Dockerfile.sh -c $(STACKS_COMMIT_HASH) --password $(JUPYTER_PASSWORD) $(DARGS)
	cp src/.dockerignore $(BUILD_DIR)

clean:
	-docker rmi $(REPOSITORY):$(TAG)

cleanall: clean
	-rm -rf $(BUILD_DIR)

pushall:
	docker push --all-tags $(REPOSITORY)
