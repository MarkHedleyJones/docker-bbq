# The image name will inherit the name of this repository
IMAGE_NAME := $(shell basename $(CURDIR))
IMAGE_TAG  := latest

ROS_DISTRO ?= noetic

# Defining the base image lets you re-use it in other build stages
BASE_IMAGE ?= osrf/ros:$(ROS_DISTRO)-desktop-full

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
	# Determine list of packages required for catkin workspace
	docker run \
		-v $(CURDIR)/workspace:$(WORKDIR) \
		--workdir=$(WORKDIR) \
		$(BASE_IMAGE) \
		/bin/bash -c "rosdep install --simulate --from-paths src --ignore-src -y" \
		| awk '{if(NR>1)print}' | cut -d ' ' -f 6 \
		> $(CURDIR)/packagelist
