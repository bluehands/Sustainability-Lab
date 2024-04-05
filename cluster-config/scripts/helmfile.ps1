#!/usr/bin/env pwsh
docker run --rm --net=host `
    -v "$env:USERPROFILE/.kube:/helm/.kube" `
    -v "$env:USERPROFILE/.config/helm:/helm/.config/helm" `
    -v "$(Get-Location):/wd" --workdir /wd `
    ghcr.io/helmfile/helmfile:v0.163.0 `
    helmfile $args
