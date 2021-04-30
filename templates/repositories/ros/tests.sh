#!/usr/bin/env bash

create-repo ros test > /dev/null 2>&1
cd test
make > /dev/null 2>&1

name="Catkin build"
pass 'cd workspace/catkin_ws && run catkin_make'
