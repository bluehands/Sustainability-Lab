#!/usr/bin/env bash

pushd "$(dirname "$0")/.."

./scripts/setup_crds.sh
./scripts/helmfile.sh apply -f ./10_setup.helmfile.yaml.gotmpl
./scripts/helmfile.sh apply -f ./20_scaling.helmfile.yaml.gotmpl
./scripts/helmfile.sh apply -f ./25_scaling.helmfile.yaml.gotmpl
./scripts/helmfile.sh apply -f ./30_kepler.helmfile.yaml.gotmpl
./scripts/helmfile.sh apply -f ./40_demand_shaping.helmfile.yaml.gotmpl
./scripts/helmfile.sh apply -f ./45_demand_shaping.helmfile.yaml.gotmpl

popd
