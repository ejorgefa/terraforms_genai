#!/bin/bash

env=$1
process=$2

if [ -z "$env" ]; then
    env="dev"  # Set the default value here
fi

if [ -z "$process" ]; then
    process="plan"  # Set the default value here
	echo " ⚠️ Running Terraform Plan and Terraform Init Only!"
fi

# Read the JSON file into a variable
json_input=$(cat terraform/vars/$env/$env.json)

# Parse the JSON input and assign variables
subscription_id=$(echo "$json_input" | jq -r '.subscription_id')
tenantId=$(echo "$json_input" | jq -r '.tenantId')
AZURE_AD_CLIENT_ID=$(echo "$json_input" | jq -r '.azure_ad_client_id')
AZURE_AD_CLIENT_SECRET=$(echo "$json_input" | jq -r '.azure_ad_client_secret')
stage=$env
resource_group=$(echo "$json_input" | jq -r '.resource_group')
location=$(echo "$json_input" | jq -r '.location')
short_location=$(echo "$json_input" | jq -r '.short_location')
client_name=$(echo "$json_input" | jq -r '.client_name')
project_name=$(echo "$json_input" | jq -r '.project_name')
TF_resource_group=$(echo "$json_input" | jq -r '.TF_resource_group')
TF_storage_account=$(echo "$json_input" | jq -r '.TF_storage_account')
TF_backend_key=$(echo "$json_input" | jq -r '.TF_backend_key')
TF_backend_container="terraform"$stage
acr_server=$(echo "$json_input" | jq -r '.acr_server')
acr_subscription_id=$(echo "$json_input" | jq -r '.acr_subscription_id')
NEXTAUTH_SECRET=$(openssl rand -base64 32)


# Print the assigned variables (you can customize this part)
echo "Subscription ID: $subscription_id"
echo "Tenant ID: $tenantId"
echo "Stage: $stage"
echo "Resource Group: $resource_group"
echo "Location: $location"
echo "Short Location: $short_location"
echo "Client Name: $client_name"
echo "Application Name: $project_name"
echo "Terraform Resource Group: $TF_resource_group"
echo "Terraform Storage Account: $TF_storage_account"
echo "Terraform Backend Container: $TF_backend_container"
echo "Terraform Backend Key: $TF_backend_key"


cd ./terraform
# az account set -s ${subscription_id}
# az account list


echo ""
echo "-------------------------------------"
RESOURCE_GROUP_NAME=rg-$client_name-$project_name-$env
STORAGE_ACCOUNT_NAME=sta$client_name$project_name$env
CONTAINER_NAME=tfstate

if [ $process == "destroy" ]; then
	echo ""
	echo "⚠️  WARNING: This script will delete any related Azure inside the \"$RESOURCE_GROUP_NAME\" resource group."
	echo ""
	read -p "To continue please type 'yes' to continue: " CONFIRM
	if [ $CONFIRM != "yes" ]; then
	echo "Exiting."
	exit
	fi
fi

echo ""
echo "🎯 Changing default subscription for: " $subscription_id
az account set --subscription $subscription_id

echo ""
echo "🎯 Getting resource group named: " $RESOURCE_GROUP_NAME
RG_EXISTS=$(az group exists --name $RESOURCE_GROUP_NAME )
if [ $RG_EXISTS == "false" ]; then
  echo "Resource group not found, creating... "
  az group create --name $RESOURCE_GROUP_NAME --location westeurope 
fi
RESOURCE_GROUP_ID=$(az group show -n $RESOURCE_GROUP_NAME  -o tsv --query id)

echo ""
echo "🎯 Getting storage account named: " $STORAGE_ACCOUNT_NAME
STORAGE_ACCOUNT_NOT_FOUND=$(az storage account check-name --name $STORAGE_ACCOUNT_NAME  --query nameAvailable)
if [ $STORAGE_ACCOUNT_NOT_FOUND == "true" ]; then
    echo ""
    echo "Storage account not found. Creating..."
	az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME  --sku Standard_LRS --encryption-services blob
fi
STORAGE_ACCOUNT=$(az storage account show --name $STORAGE_ACCOUNT_NAME  -o tsv --query id)


echo ""
echo "🎯 Getting storage account container named: " $CONTAINER_NAME
STORAGE_COUNTAINER_EXISTS=$(az storage container exists --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME  --query exists)
if [ $STORAGE_COUNTAINER_EXISTS == "false" ]; then
	echo ""
	echo "Blob container not found. Creating..."
	az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME 
fi
STORAGE_CONTAINER=$(az storage account show --name $STORAGE_ACCOUNT_NAME  -o tsv --query primaryEndpoints.blob)$CONTAINER_NAME

echo ""
echo "🎯 Getting storage account key..."
STORAGE_ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME  --account-name $STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv)

echo ""
echo "🎯 Getting storage connection string..."
STORAGE_ACCOUNT_CONNECTION_STRING=$(az storage account show-connection-string --resource-group $RESOURCE_GROUP_NAME  --name $STORAGE_ACCOUNT_NAME --query "connectionString"  -o tsv)
echo $STORAGE_ACCOUNT_CONNECTION_STRING


echo ""
echo "🎯 Changing default subscription for: " $subscription_id
az account set --subscription $acr_subscription_id

echo ""
echo "🎯 Getting container registry data..."
ACR_PASSWORD=$(az acr credential show --name $acr_server | jq -r '.passwords[0].value')
ACR_USERNAME=$(az acr credential show --name $acr_server | jq -r '.username')

echo ""
echo "🎯 Changing default subscription for: " $subscription_id
az account set --subscription $subscription_id

echo "🎯 Running Terraform Init!"
terraform init \
	-upgrade \
	-backend-config="resource_group_name=${RESOURCE_GROUP_NAME}" \
	-backend-config="storage_account_name=${STORAGE_ACCOUNT_NAME}" \
	-backend-config="container_name=${CONTAINER_NAME}" \
	-backend-config="key=${STORAGE_ACCOUNT_KEY}" \
	-input=true \
	-reconfigure


if [ $process == "plan" ]; then
echo "🎯 Running Terraform Plan for " $stage
terraform plan  \
	-out=./tfplan \
	-var-file="./vars/${stage}/${stage}.tfvars" \
	-var="stage=${stage}" \
	-var="location=${location}" \
	-var="client_name=${client_name}" \
	-var="project_name=${project_name}" \
	-var="subscription_id=${subscription_id}" \
	-var="tenantId=${tenantId}" \
	-var="azure_ad_client_id=${AZURE_AD_CLIENT_ID}" \
	-var="azure_ad_client_secret=${AZURE_AD_CLIENT_SECRET}" \
	-var="resource_group_name=${RESOURCE_GROUP_NAME}" \
	-var="container_registry_admin_password=${ACR_PASSWORD}" \
	-var="container_registry_login_server=${acr_server}" \
	-var="container_registry_admin_username=${ACR_USERNAME}" \
	-var="storage_account_connection_string=${STORAGE_ACCOUNT_CONNECTION_STRING}" \
	-var="nextauth_secret=${NEXTAUTH_SECRET}" \
	-refresh=false
fi

if [ $process == "apply" ]; then
	echo "🎯 Running Terraform Apply now!"
	terraform apply \
					-refresh=false \
					-auto-approve \
					./tfplan
fi

if [ $process == "destroy" ]; then
	echo "⚠️ Destroying Terraform now!"
	terraform plan  \
		-out=./tfplan \
		-var-file="./vars/${stage}/${stage}.tfvars" \
		-var="stage=${stage}" \
		-var="location=${location}" \
		-var="client_name=${client_name}" \
		-var="project_name=${project_name}" \
		-var="subscription_id=${subscription_id}" \
		-var="tenantId=${tenantId}" \
		-var="azure_ad_client_id=${AZURE_AD_CLIENT_ID}" \
		-var="azure_ad_client_secret=${AZURE_AD_CLIENT_SECRET}" \
		-var="resource_group_name=${RESOURCE_GROUP_NAME}" \
		-var="container_registry_admin_password=${ACR_PASSWORD}" \
		-var="container_registry_login_server=${acr_server}" \
		-var="container_registry_admin_username=${ACR_USERNAME}" \
		-var="storage_account_connection_string=${STORAGE_ACCOUNT_CONNECTION_STRING}" \
		-destroy \
		-refresh=false
	terraform apply \
		-refresh=false \
		-auto-approve \
		-destroy \
		./tfplan
fi