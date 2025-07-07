#!/usr/bin/env pwsh

Push-Location $PSScriptRoot/..

./scripts/setup_crds.ps1
./scripts/helmfile.ps1 apply -f ./10_setup.helmfile.yaml.gotmpl
./scripts/helmfile.ps1 apply -f ./20_scaling.helmfile.yaml.gotmpl
./scripts/helmfile.ps1 apply -f ./25_scaling.helmfile.yaml.gotmpl
./scripts/helmfile.ps1 apply -f ./30_kepler.helmfile.yaml.gotmpl
./scripts/helmfile.ps1 apply -f ./40_demand_shaping.helmfile.yaml.gotmpl
./scripts/helmfile.ps1 apply -f ./45_demand_shaping.helmfile.yaml.gotmpl

Pop-Location
