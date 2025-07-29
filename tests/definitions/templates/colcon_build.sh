#!/usr/bin/env bash

name="Colcon build (system)"
pass 'cd ros2_ws && run colcon build'

name="Colcon build (custom cb script)"
# Test cb script from project root - it should work from any directory
pass 'cd .. && run cb'