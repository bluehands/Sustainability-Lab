# Sustainability-Lab

## Cluster Configuration

Create a file `cluster-config/environments/secrets.yaml` with the domain set to your desired one (see `cluster-config/environments/values.yaml`).

## Load test for scaling

There are some load test scripts to create load on the app. To use this scripts install [artillery](https://www.artillery.io/).

To run the load test for the WhoAmI Azure Container App execute:

``` cmd
artillery run scale-container-app-whoami.yml
artillery run scale-k8s-whoami.yml
```
