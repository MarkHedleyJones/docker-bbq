#!/usr/bin/env bash

name="Build development image as root"
pass 'USER_NAME=root USER_UID=0 USER_GID=0 make'

name="Build production image as root"
pass 'USER_NAME=root USER_UID=0 USER_GID=0 make production'