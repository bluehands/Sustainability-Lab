# Azure "Specials"
## Create AKS
Create an AKS with one server pool (System) scaled to 1 and one agent pool (User) scaled to 0.
Also configure public IP access for KubeAPI access.

## Configure local access
```bash
az aks get-credentials --resource-group [resource-group] --name [cluster-name]
```
