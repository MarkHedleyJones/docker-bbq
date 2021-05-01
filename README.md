<h1>docker-bbq<br><img alt="docker-bbq" src="https://github.com/MarkHedleyJones/docker-bbq/raw/f9be5bba4a97187a10c95ac18a216897ad3e0466/media/bbq.svg"></h1>

A tool for rapidly cooking up new [Docker](https://www.docker.com/) projects while simplifying containerised software development.

This tool might be useful if you:
* find yourself running `docker run -it -v ...` more often than you think you should, or
* find yourself creating new Docker repositories by duplicating parts of previous ones, or
* often create scripts with names like `run.sh` to launch containers during development.

## Demonstration

<p align="center">
  <img src="https://raw.github.com/markhedleyjones/docker-bbq/master/media/demo.gif" alt="docker-bbq demonstration"/>
</p>

## Overview
There are two components to docker-bbq.
The first is `create-repo`, which can be used to make templated docker-bbq repositories.
The second is the `run` command, which makes interracting and developing your Docker project quick and easy.

### `run` - under the hood:
Executing something in your docker-bbq repository (from anywhere on the host) using `run <command>` does the following steps:
1. Determine the image/project name by crawling up the path tree to find the relevant Dockerfile.
2. Check if the target container is already running. If yes, `<command>` will be executed inside it. If not, a new one will be created.
3. Check if the repository is in the "development state". If yes, the repository's workspace will be mounted into the new container.
4. Detect the host system's display capabilities and configure forwarding of graphical programs from the container.
5. Launch a new contaner, or enter the existing one, and execute `<command>`.
6. After the container exits, ownership of files created in the container will be changed to your username.

### Templated repository structure:
The basic structure of a docker-bbq repository is as follows (although depends on the template you select)
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

The repository includes a `make`-based Makefile to simplify the build process.
There are two options for building your project:
1. `make` - Builds the development image. Allows for faster development as the image's workspace *is* the repository's workspace.
2. `make production` - Builds the production image. Ready to be shipped, the image contains its own workspace.
