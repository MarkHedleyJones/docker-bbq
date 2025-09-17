#!/usr/bin/env bash

# Get the workspace name from .docker-bbq file
workspace_name=$(grep "WORKSPACE_NAME=" .docker-bbq | cut -d= -f2)
repo_path=$(pwd)

# Only run detailed workspace tests for non-default workspace names
# (default workspace is already tested in run-command.sh)
if [[ "${workspace_name}" != "workspace" ]]; then
    name="Host workspace path has ${workspace_name}"
    pass "run printenv DOCKER_BBQ_HOST_WORKSPACE_PATH | grep -E '/${workspace_name}$'"

    name="Container workspace path has ${workspace_name}"
    pass "run printenv DOCKER_BBQ_CONTAINER_WORKSPACE_PATH | grep -E '/${workspace_name}$'"

    # Test that workspace variables exist and match workspace name
    name="Workspace paths match ${workspace_name}"
    pass "run printenv | grep DOCKER_BBQ | grep ${workspace_name} | wc -l | grep -E '^2$'"
fi
