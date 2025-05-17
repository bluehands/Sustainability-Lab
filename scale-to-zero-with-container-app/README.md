# Sustainability-Lab

## Load test for scaling

There are some load test scripts to create load on the app. To use this scripts install [artillery](https://www.artillery.io/).
To run the load test for the WhoAmI Azure Container App execute:

``` cmd
cd ./scale-to-zero-with-container-app
artillery run scale-container-app-whoami.yml
```
