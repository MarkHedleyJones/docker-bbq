#!/usr/bin/env bash

create-repo debian ${TESTREPO} > /dev/null 2>&1
cd ${TESTREPO}

name="Building development image (debian)"
pass make

name="Building production image (debian)"
pass make production
