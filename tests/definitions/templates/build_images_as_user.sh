#!/usr/bin/env bash

name="Build development image as user"
pass 'USER_NAME=user make'

name="Build production image as user"
pass 'USER_NAME=user make production'
