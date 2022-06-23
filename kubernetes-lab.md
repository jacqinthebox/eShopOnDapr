# Monitoring

```sh
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.OperationalInsights
az feature register --name EnablePodIdentityPreview   --namespace Microsoft.ContainerService
az extension add --name aks-preview

az account set --subscription msdn01
az group create -g fedpol-dev-cluster-rg --location westeurope
az aks create -g fedpol-dev-cluster-rg -n fedpol-dev-cluster --node-count 2 --location westeurope --enable-addons monitoring --max-pods 110 --generate-ssh-keys
```

Build the cluster

```
az aks get-credentials --resource-group fedpol-dev-cluster-rg --name fedpol-dev-cluster --admin
```

Install
https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/

Install Dapr

```
wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash

# on windows

powershell -Command "iwr -useb https://raw.githubusercontent.com/dapr/cli/master/install/install.ps1 | iex"

```

```
dapr init -k
```

Install namespaces

```sh
kubectl create ns eshop
kubectl create ns monitoring
```

Install ingress

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install eshop-ingress ingress-nginx/ingress-nginx --namespace kube-ingress --create-namespace --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz
```

Install eshop

```
kubectl config set-context  --current --namespace eshop 
helm upgrade --install eshop deploy/charts/eshopondapr -f deploy/helm-values/eshop-example-values.yaml
```

add to hostfile

```
kubectl get services eshop-ingress-ingress-nginx-controller -n kube-ingress -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

```
20.31.101.115 dev.eshop.example.io
20.31.101.115 ops.eshop.example.io
```

Install prometheus

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install prometheus prometheus-community/prometheus --namespace monitoring -f ./deploy/helm-values/prometheus-example-values.yaml
```

Install metrics

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install metrics prometheus-community/kube-state-metrics
```

Install Grafana

```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install grafana grafana/grafana --namespace monitoring -f ./deploy/helm-values/grafana-example-values.yaml
```

Get the secret of your Grafana 

```
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

```

Login to grafana
username: admin
password: 

Add a new datasource with url http://prometheus-server
then import a dashboard: https://raw.githubusercontent.com/jacqinthebox/eShopOnDapr/main/deploy/grafana-dashboard.json

