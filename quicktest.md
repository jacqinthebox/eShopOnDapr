## Quick & dirty aks deployment

register features

```sh
az feature register --name EnablePodIdentityPreview   --namespace Microsoft.ContainerService
az extension add --name aks-preview
```

create cluster
```sh
az account set --subscription demo01
az group create -g eshop-dev-cluster-rg --location westeurope
az aks create -g eshop-dev-cluster-rg -n eshop-dev-cluster --node-count 1 --location westeurope --enable-pod-identity --network-plugin azure

(optional add --generate-ssh-keys)
```

add creds to kubeconfig

```shell
az aks get-credentials --resource-group kube-dev-cluster-rg --name kube-dev-cluster  
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

install prometheus and grafana (which ns should we use?)

```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

helm install prometheus prometheus-community/prometheus
helm install grafana grafana/grafana
```

install k8s dashboard

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
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

## Optional: managed identity

add a managed identity to access sql server

```shell
group=eshop-dev-cluster-rg
cluster=eshop-dev-cluster
az identity create --name sql-managed-identity --resource-group $group 
```

retrieve the resource id, and then add a pod identity to the cluster. 

```shell
RESOURCEID=$(az identity show --name sql-managed-identity --resource-group $group --query id -o tsv)
az aks pod-identity add --resource-group $group --cluster-name $cluster --namespace default --name sql-managed-identity --identity-resource-id $RESOURCEID
```

grant the managed identity db_owner (or less permissions)
for this you need to log in with an AD admin, not a local sql account.

```sql
USE dbname
CREATE USER [sql-managed-identity] FROM EXTERNAL PROVIDER;
ALTER ROLE db_owner ADD MEMBER [sql-managed-identity];
```

## HTTPS

Install cert-manager

https://cert-manager.io/docs/installation/

```shell
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.yaml
```

Create the issuers (change the email address):

```shell
kubectl create --edit -f https://raw.githubusercontent.com/cert-manager/website/master/content/docs/tutorials/acme/example/staging-issuer.yaml
kubectl create --edit -f https://raw.githubusercontent.com/cert-manager/website/master/content/docs/tutorials/acme/example/production-issuer.yaml
```

Now set certManager.enabled to true and certManager.environment to staging in values.yaml, and reapply the helm chart.
If you do `kubectl get certificates` and they all are READY, you can set certManager.environment to prod and reapply the helm chart.

Delete the certificates:

```shell
kubectl get certificate -o name | xargs kubectl delete

```


## With pipeline

environments:
* sbx (sandbox)
* npd (non prod)
* dev (development)
* prd (production)

kube-<environment>-<id>