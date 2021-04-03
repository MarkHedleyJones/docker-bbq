# The image name will inherit the name of this repository
IMAGE_NAME := $(shell basename $(CURDIR))
IMAGE_TAG  := latest

# Defining the base image lets you re-use it in other build stages
BASE_IMAGE ?= debian:buster-slim

WORKDIR    := /workspace

# A standard build does not include the workspace - for development
.PHONY: build
build: pre-build
	docker build \
		--target base \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg WORKDIR=$(WORKDIR) \
		--tag $(IMAGE_NAME):$(IMAGE_TAG) \
		.

# A production build includes the workspace in the final image
.PHONY: production
production: pre-build
	docker build \
		--target production \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg WORKDIR=$(WORKDIR) \
		--tag $(IMAGE_NAME):$(IMAGE_TAG) \
		.

.PHONY: pre-build
pre-build:
	# Add your pre-build stages here
	@echo "No pre-build stages, building ... "
