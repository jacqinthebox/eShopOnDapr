Example of umbrella helm chart, uses global values. 

Dependency charts coud be enabled/disabled.

To deploy subchart use: e.g.:
helm upgrade --install identity-api --values=./eshop/values.yaml eshop/charts/identity-api
