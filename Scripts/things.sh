#!/bin/bash

az group create --name ndccontoso --location eastus
az iot hub create --resource-group ndccontoso --name ndccontosohub --sku S1
az acr create --resource-group ndccontoso --name ndccontosoreg --sku Basic --admin-enabled
az eventhubs namespace create --resource-group ndccontoso --name ndccontosons
az eventhubs eventhub create --resource-group ndccontoso --namespace-name ndccontosons --name ndccontosoeh
az appservice plan create --name ndccontosoapp --resource-group ndccontoso --sku S1
az webapp create --name ndccontosofunc --resource-group ndccontoso --plan ndccontosoapp
az webapp create --name ndccontosobot --resource-group ndccontoso --plan ndccontosoapp
# You should only have to install the ext once
# az extension add --name azure-cli-iot-ext
az iot hub device-identity create --device-id contosodevice --hub-name ndccontosohub --edge-enabled

iotedgectl setup --connection-string "<your conn string>" --nopass
ndccontosoreg.azurecr.io/accel_sim:0.0.1-amd64

az iot hub apply-configuration --device-id contosodevice --hub-name ndccontosohub --content "C:\src\GrandmaFallDown\Modules\accel_sim\deployment.json"

# Currently Databricks via Azure Portal