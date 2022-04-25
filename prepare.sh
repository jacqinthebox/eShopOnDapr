#!/usr/bin/env bash

SUBSCRIPTION=e267d216-a7aa-42e4-905a-f18316a144c4 #can be name or guid
RESOURCE_GROUP_NAME=demo01-tfstate-dev-rg
STORAGE_ACCOUNT_NAME=demo001tfstatedevstorage
APP_REGISTRATION_NAME=demo01-service-account
REPO=yulia-meijs/eShopOnDapr

echo "Plumbing to onboard an Azure subscription for Terraform and run pipelines with Github Actions."

if ! hash gh 2>/dev/null; then
    echo >&2 "gh cli is not installed"
    exit 1
fi

if ! hash az 2>/dev/null; then
    echo >&2 "az cli is not installed"
    exit 1
fi

echo "Checking Azure CLI login status..."
EXPIRED_TOKEN=$(az ad signed-in-user show --query 'objectId' -o tsv || true)

if [[ -z "$EXPIRED_TOKEN" ]]
then
    az login -o none
fi

ACCOUNT=$(az account show --query '[id,name]')
echo $ACCOUNT

az account set --subscription $SUBSCRIPTION

read -r -p "Do you want to use the above subscription? (Y/n) " response
response=${response:-Y}
case "$response" in
    [yY][eE][sS]|[yY])
        ;;
    *)
        echo "Use the \`az account set\` command to set the subscription you'd like to use and re-run this script."
        exit 0
        ;;
esac

echo "Getting Subscription Id..."
subscription_id=$(az account show --query id -o tsv)
echo "Subscription: $subscription_id"

echo "Getting Tenant Id..."
tenant_id=$(az account show --query tenantId -o tsv)
echo "Tenant: $tenant_id"

az account set --subscription $subscription_id
SECRET=$(az ad sp create-for-rbac --name $APP_REGISTRATION_NAME --role contributor --scopes /subscriptions/$subscription_id --years 10)
CLIENT_ID=$(echo $SECRET | jq -r .appId)
CLIENT_SECRET=$(echo $SECRET | jq -r .password)

ACCOUNT_INFO="{\"clientId\": \"${CLIENT_ID}\",\"clientSecret\": \"${CLIENT_SECRET}\", \"subscriptionId\": \"${subscription_id}\", \"tenantId\": \"${tenant_id}\" }"
echo $ACCOUNT_INFO | jq .

echo "Logging into GitHub CLI..."
gh auth login
echo "Logged in to Github."

read -r -p "Looks good? Add storage account secret to Github? [y/N] " response
response=${response:-N}
case "$response" in
    [yY][eE][sS]|[yY])
        echo $ACCOUNT_INFO
        gh secret set AZURE_CREDENTIALS --body "$ACCOUNT_INFO" --repo $REPO
        ;;
    *)
    echo "It didn't look good so not creating the secret"
    ;;
esac

CONTAINER_NAME=tfstate
az group create --name $RESOURCE_GROUP_NAME --location westeurope
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

read -r -p "Add secrets to Github? [y/N] " response
response=${response:-N}
case "$response" in
    [yY][eE][sS]|[yY])
    echo "Setting the Terraform secrets we can later use as environment variables"
    gh secret set ARM_CLIENT_ID -b=${CLIENT_ID} --repo $REPO
    gh secret set ARM_CLIENT_SECRET -b=${CLIENT_SECRET} --repo $REPO
    gh secret set ARM_SUBSCRIPTION_ID -b=${subscription_id} --repo $REPO
    gh secret set ARM_TENANT_ID -b=${tenant_id} --repo $REPO
    gh secret set ARM_ACCESS_KEY -b=${ACCOUNT_KEY} --repo $REPO
    gh secret set TF_VAR_BACKEND_STORAGE_ACCOUNT_NAME -b=${STORAGE_ACCOUNT_NAME} --repo $REPO
    gh secret set TF_VAR_BACKEND_RESOURCE_GROUP_NAME -b=${RESOURCE_GROUP_NAME} --repo $REPO
        ;;
    *)
    echo "Not adding the secrets"
    ;;
esac