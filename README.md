<h1>docker-bbq<br><img alt="docker-bbq" src="https://github.com/MarkHedleyJones/docker-bbq/raw/d71aa959ea69b5ced85b670ea92dcc4cd11f87f1/media/bbq.svg"></h1>

A tool for rapidly cooking up new [Docker](https://www.docker.com/) projects while simplifying containerised software development. Free yourself from writing and optimising dockerfiles and focus on development.

This tool might be useful if you:
1. become frustrated from manually running `docker run -it -v ...`, or
1. work across many Docker-based repositories and want more consistency, or
1. are rebuilding your images after modifying source-code.

## Demonstration

<p align="center">
  <img src="https://raw.github.com/markhedleyjones/docker-bbq/master/media/demo.gif" alt="docker-bbq demonstration"/>
</p>

## Features
* Executing containerised code becomes frictionless with the `run` command.
* Create new repositories with `create-repo`. They're instantly buildable and have a consistent layout.
* Workspace linking during development means changes to source-code appear instantly inside containers.
* Write your dependencies in lists and they'll be installed automatically at build-time:
  - System packages (`build/packagelist`)
  - Python-pip packages (`build/pip-requirements.txt`), or specify the pip version with `pipX-requirements.txt`
  - Downloadable resources (`buiid/urilist`)
* All templates use a consistent architecture, ensuring they're still familiar when you return in future.
* All templates have a special *production* build-mode which creates stand-alone, distributable images.


## Overview
There are two components to docker-bbq.
The first is `create-repo`, which can be used to make templated docker-bbq repositories.
The second is the `run` command, which makes interacting and developing your Docker project quick and easy.

### `run` - under the hood:
Executing something in your docker-bbq repository (from anywhere on the host) using `run <command>` does the following steps:
1. Determine the image/project name by crawling up the path tree to find the relevant Dockerfile.
2. Check if the target container is already running. If yes, `<command>` will be executed inside it. If not, a new one will be created.
3. Check if the repository is in the "development state". If yes, the repository's workspace will be mounted into the new container.
4. Detect the host system's display capabilities and configure forwarding of graphical programs from the container.
5. Launch a new container, or enter the existing one, and execute `<command>`.
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

---

docker-bbq logo made with vector graphics from [svgrepo.com](https://www.svgrepo.com/svg/288987/fire) (creative-commons license), with modifications.
