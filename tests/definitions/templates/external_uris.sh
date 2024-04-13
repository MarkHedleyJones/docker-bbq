#!/usr/bin/env bash

name="Downloading external URIs"
base_url="https://raw.githubusercontent.com/MarkHedleyJones/docker-bbq/main"
printf "${base_url}/LICENSE\n${base_url}/README.md\n" >build/urilist
pass make
rm build/urilist

name="Downloaded URI is in image"
pass "run 'cat /build/resources/LICENSE | grep \"MIT License\" && \
        cat /build/resources/README.md | grep \"docker-bbq\" && \
        /workspace/target.sh'"
