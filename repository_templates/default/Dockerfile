ARG BASE_IMAGE
FROM $BASE_IMAGE AS base

# Allow the workspace variable to be used during build
ARG WORKDIR

# Install required packages for this project
COPY packagelist /
RUN packagelist="$(cat /packagelist | xargs)" && \
if [ "${packagelist}" != "" ] ; then \
    apt-get update \
    && apt-get install --yes --no-install-recommends "${packagelist}" \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Workspace package(s) installed" ; \
else \
    echo "Packagelist is empty" ; \
fi

# Run any configuration or build tasks here

WORKDIR $WORKDIR

# Convenience function to set ownership of paths within workspace to host user
RUN echo """#!/usr/bin/env bash\n\
chown --recursive --from=\$(id -u):\$(id -g) $(id -u):$(id -g) ${WORKDIR}\n\
""" > /usr/local/bin/fix-permissions \
    && chmod +x /usr/local/bin/fix-permissions


#######################
# PRODUCTION TARGET
#######################
FROM base AS production
COPY workspace $WORKDIR
