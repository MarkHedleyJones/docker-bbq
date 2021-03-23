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

# Convenience function to set ownership of paths within workspace to host user
RUN echo """#!/usr/bin/env bash\n\
chown --recursive --from=\$(id -u):\$(id -g) $(id -u):$(id -g) ${WORKDIR}\n\
""" > /usr/local/bin/fix-permissions \
    && chmod +x /usr/local/bin/fix-permissions
