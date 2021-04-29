#!/usr/bin/env bash

name='Valid template exits success'
pass 'create-repo debian test'

name='Template directory created'
pass 'find . -type d | grep test'

name='Dont overwrite existing repo'
fail 'create-repo debian test'

# Remove previously created repo
rm -rf test

name='Invalid template exits with failure'
fail 'create-repo non-existant-template test'
