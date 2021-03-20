ARG BASE_REPO
ARG BASE_TAG

# The base image is passed in from the Makefile
FROM $BASE_REPO:$BASE_TAG

# Allow the workspace variable to be used during build
ARG WORKDIR

# Install required packages for this project
# RUN apt-get update \
#   && apt-get install --yes --no-install-recommends \
#     ... \
#   && echo "Workspace package(s) installed."

# Run any configuration or build tasks here

WORKDIR $WORKDIR

# Enable bash history inside this container
ENV HISTFILE=$WORKDIR/.bash_history
