#!/usr/bin/env bash

name='Valid template exits success'
pass 'create-repo debian ${TESTREPO}'

name='Template directory created'
pass 'find . -type d | grep ${TESTREPO}'

name='Dont overwrite existing repo'
fail 'create-repo debian ${TESTREPO}'

# Remove previously created repo
rm -rf ${TESTREPO}

name='Invalid template exits with failure'
fail 'create-repo non-existant-template ${TESTREPO}'
