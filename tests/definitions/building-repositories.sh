#!/usr/bin/env bash

bbq-create debian ${TESTREPO} > /dev/null 2>&1
cd ${TESTREPO}

name="Building development image (debian)"
pass make

name="Privileges enabled on devlopment image"
is_privileged=$(TESTING=1 run | tail -n 1 | grep -c " \-\-privileged ")
pass test ${is_privileged} -eq 1

name="Building production image (debian)"
pass make production

name="Privileges disabled on production image"
is_privileged=$(TESTING=1 run | tail -n 1 | grep -c " \-\-privileged ")
pass test ${is_privileged} -eq 0
