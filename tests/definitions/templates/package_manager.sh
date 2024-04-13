#!/usr/bin/env bash

name="System package installation"
printf "tinyproxy\nranger" >build/packagelist
pass make

name="System packages installed"
pass 'run tinyproxy -v | grep "tinyproxy"'

name="Packagelist intact after build"
pass 'cat build/packagelist | grep tinyproxy > /dev/null'
echo "" >build/packagelist
