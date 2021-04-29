#!/usr/bin/env bash

create-repo debian test > /dev/null 2>&1
cd test

name="Building development image (debian)"
pass make

name="Building production image (debian)"
pass make production
