# The image name will inherit the name of this repository
IMAGE_NAME := $(shell basename $(CURDIR))
IMAGE_TAG  := latest

ROS_DISTRO ?= noetic

# Defining the base image lets you re-use it in other build stages
BASE_IMAGE ?= osrf/ros:$(ROS_DISTRO)-desktop-full

WORKDIR    := /workspace

.PHONY: post-build
post-build: build
  # Add your post-build stages here
	@echo "No post-build stages, build competed!"

.PHONY: build
build: pre-build
	docker build \
		--build-arg BASE_IMAGE=$(BASE_IMAGE) \
		--build-arg WORKDIR=$(WORKDIR) \
		--tag $(IMAGE_NAME):$(IMAGE_TAG) \
		.

.PHONY: pre-build
pre-build:
	# Add your pre-build stages here
	@echo "No pre-build stages, building ... "
