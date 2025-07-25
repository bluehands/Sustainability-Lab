# Sustainability-Lab

## Cluster Configuration

Create a file `cluster-config/environments/secrets.yaml` with the domain set to your desired one (see `cluster-config/environments/values.yaml`).

### Quick Install

To setup a cluster with all resources for demo or playground purposes run the `setup_cluster.ps1` or `setup_cluster.sh` script inside the `scripts` directory.

## whoami

A simple web site for testing [http://whoami.aks.carbon-aware-computing.com/](http://whoami.aks.carbon-aware-computing.com/)

## Grafana

Observing the k8s cluster [http://grafana.aks.carbon-aware-computing.com/](http://grafana.aks.carbon-aware-computing.com/)

``` cmd
user: admin
pwd: admin
```

## k9s

``` powershell
$env:KUBECONFIG="./config/workshop-01.yaml"
k9s
```

## Load test for scaling

### whoami

There are some load test scripts to create load on the app. To use this scripts install [artillery](https://www.artillery.io/).

To run the load test for the WhoAmI Azure Container App execute:

``` cmd
artillery run scale-k8s-whoami.yml
```

### Message Queue

To test the message queue consumer scaling compile the project under `demand-shaping-k8s/tools/QueueTool` and run it like this:

``` cmd
queue-tool --connection-string amqp://rabbitmq:rabbitmq@localhost produce --message-count 100
queue-tool --connection-string amqp://rabbitmq:rabbitmq@131.163.30.32 produce --message-count 100
```

Remember to replace `localhost` with the name/address of your cluster.
