#!/usr/bin/env bash

bbq-create ros test > /dev/null 2>&1
cd test
make > /dev/null 2>&1

name="Catkin build"
pass 'cd catkin_ws && run catkin_make'
