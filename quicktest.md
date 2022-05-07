## Quick & dirty aks deployment

create cluster
```sh
az account set --subscription demo01
az group create -g eshop-dev-cluster-rg --location westeurope
az aks create -g eshop-dev-cluster-rg -n eshop-dev-cluster --node-count 1 --location westeurope
```

add creds to kubeconfig

```shell
az aks get-credentials --resource-group eshop-dev-cluster-rg --name eshop-dev-cluster
```

install dapr cli

```shell
wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash
```

install dapr on aks

```shell
dapr init -k
```

install ingress controller

```shell
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install eshop-new ingress-nginx/ingress-nginx  --namespace kube-ingress --create-namespace
```

check what is your external ip

```shell
kubectl get svc -A | awk {'print $5'} | grep -v none
```


deploy

```shell
helm upgrade --install myshop deploy/charts/eshop 
```

Finally, change the ip address in DNS zone.

