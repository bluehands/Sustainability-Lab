# Azure "Specials"
## Configure SSH access
Configure an inbound NAT rule for SSH access in the Load Balancer e.g. from port 50000 onwards. In the NSG you also need to add an appropriate inbound rule.

## Configure outbound rule in Load Balance
To allow internet access you need to configure outbound rules in the associated Load Balancer.

# Kubernetes
## Install K3s
```bash
curl -sfL https://get.k3s.io | sudo sh - 
```

## Install K9s
```bash
wget https://github.com/derailed/k9s/releases/download/v0.32.4/k9s_linux_amd64.deb
sudo apt install ./k9s_linux_amd64.deb
```

> As root
```bash
cp /var/lib/rancher/k3s/server/cred/admin.kubeconfig ~/.kube/config
k9s
```

## Configure Local Admin Access
> On server node
```bash
mkdir k8s-admin
sudo cp /var/lib/rancher/k3s/server/cred/admin.kubeconfig ./k8s-admin/
sudo cp /var/lib/rancher/k3s/server/tls/server-ca.crt ./k8s-admin/
sudo cp /var/lib/rancher/k3s/server/tls/client-admin.crt ./k8s-admin/
sudo cp /var/lib/rancher/k3s/server/tls/client-admin.key ./k8s-admin/
sudo chown -R azureuser:azureuser ./k8s-admin
```

> On local computer
```bash
scp -p 50000 -r azureuser@[ip]:~/k8s-admin ./.kube
```

> Copy and adapt configuration and paths in admin.kubeconfig and copy it to ~/.kube/config

Open tunnel to Kubernetes API to use in local Kubernetes tools
```bash
ssh -L 6444:localhost:6444 -p 50000 azureuser@[ip]
```
