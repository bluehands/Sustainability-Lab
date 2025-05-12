#!/usr/bin/env bash

docker run --rm --net=host \
    -v "$HOME/.kube:/helm/.kube" \
    -v "$HOME/.config/helm:/helm/.config/helm" \
    -v "$(pwd):/wd" --workdir /wd \
    ghcr.io/helmfile/helmfile:v0.163.0 \
    helmfile "$@"
