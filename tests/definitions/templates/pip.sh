#!/usr/bin/env bash

name="PIP package installation"
printf "meowsay\ndinosay" >build/pip3-requirements.txt
pass make
rm build/pip3-requirements.txt

name="PIP package installed"
pass 'run dinosay -d trice "Dinosaurs" | grep "Dinosaurs"'
