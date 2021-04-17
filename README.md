# docker-flow

A templated workflow to help develop software designed to run inside Docker containers.

This tool might be useful if you:
* find yourself creating new Docker projects by duplicating parts of previous ones, or
* often create scripts with names like `run.sh` to launch containers during development, or
* find yourself running `docker run -it -v ...` more often than you think you should have to.

## Demonstration

<p align="center">
  <img src="https://raw.github.com/markhedleyjones/docker-flow/master/media/demo.gif" alt="docker-flow demonstration"/>
</p>

## Overview
There are two components to docker-flow.
The first is `create-repo`, which can be used to make templated docker-flow repositories.
The second is the `run` command, which makes interracting and developing your Docker project quick and easy.

### `run` - under the hood:
Executing something in your docker-flow repository (from anywhere on the host) using `run <command>` does the following steps:
1. Determine the image/project name by crawling up the path tree to find the relevant Dockerfile.
2. Check if the target container is already running. If yes, `<command>` will be executed inside it. If not, a new one will be created.
3. Check if the repository is in the "development state". If yes, the repository's workspace will be mounted into the new container.
4. Detect the host system's display capabilities and configure forwarding of graphical programs from the container.
5. Launch a new contaner, or enter the existing one, and execute `<command>`.
6. After the container exits, ownership of files created in the container will be changed to your username.

### Templated repository structure:
The basic structure of a docker-flow repository is as follows (although depends on the template you select)
```
<project-name>
│
├─► build
│   │
│   ├─ packagelist                # List of system packages to install
│   │
│   └─ <build-reated-files>       # For example, pip-requirements.txt
│
├─► workspace
│   │
│   └─ <your-project>             # Everything related to your project
│
├─ Dockerfile
│
├─ Makefile                       # make-based build helper
│
└─ README.md                      # Pre-populated with build instructions
```
