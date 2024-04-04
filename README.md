<h1>docker-bbq<br><img alt="docker-bbq" src="https://raw.githubusercontent.com/MarkHedleyJones/docker-bbq/master/media/logo.webp"></h1>

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
* Building your image is as simple running `make` from within your workspace.
* Create dependency lists and they'll be installed automatically at build-time:
  - System packages - `build/packagelist`
  - Python-pip packages  - `build/pip-requirements.txt` (specify pip version e.g. `pip3-requirements.txt`)
  - Downloadable resources - `build/urilist`
* When it's time to deploy, running `make production` builds the final stand-alone, distributable image.

## Overview
There are two components to docker-bbq.
The first is `create-repo`, which can be used to make templated docker-bbq repositories.
The second is the `run` command, which makes interacting and developing your Docker project quick and easy.

### The 'run' command:
The `run` command lets you seamlessly execute things in your repository's workspace seamlessly. As an example, when running something like `run ~/my-bbq-repo/workspace/hello_world.py`, `run` does the following:
1. Determines the required image based on the command or your location (the repo and image names always match, so in this case it's *my-bbq-repo:latest*).
2. Checks if the required container is already running. If yes, the command will be executed inside it. If not, a new one will be created.
3. Checks if the repository is in the "development state". If yes, the repository's workspace will be mounted into the new container.
4. Detects the host system's display capabilities and configures the container accordingly.
5. Launches a new container, or enters the existing one, and executes `hello_world.py`.
6. After the container exits, ownership of files created in the container will be changed to your username.

### Repository structure:
The basic structure of a docker-bbq repository is as follows (although depends on the template you select)
```
<project-name>
│
├─► build
│   │
│   ├─ packagelist                # List of system packages to install
│   │
│   └─ <build-related-files>      # For example, pip-requirements.txt
│
├─► workspace
│   │
│   └─ <your-project>             # Everything related to your project
│
├─ Dockerfile
│
├─ Makefile                       # Make-based build helper
│
└─ README.md                      # Pre-populated with build instructions
```

The repository includes a `make`-based Makefile to simplify the build process.
There are two options for building your project:
1. `make` - Builds the development image. Allows for faster development as the image's workspace *is* the repository's workspace.
2. `make production` - Builds the production image. Ready to be shipped, the image contains its own workspace.

---

docker-bbq logo made with vector graphics from [svgrepo.com](https://www.svgrepo.com/svg/288987/fire) (creative-commons license), with modifications.
