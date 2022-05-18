#!/bin/bash
echo "creating ResourceGroup"
RG=peeringRG
echo ${RG}
az group create -l centralus -n ${RG}

echo "Creating Azure Virtual Network"

vnetName01=EAST-Vnet001
subnetName01=East-Snet001
vnet01add=10.1.0.0/16
sub01add=10.1.1.0/24

az network vnet create \
  --name $vnetName01 \
  --resource-group $RG \
  --address-prefixes $vnet01add \
  --subnet-name $subnetName01 \
  --subnet-prefixes $sub01add \
  --location eastus

vnetName02=EAST-Vnet002
subnetName02=EAST-Snet002
vnet02add=172.16.0.0/16
sub02add=172.16.1.0/24

az network vnet create \
  --name $vnetName02 \
  --resource-group $RG \
  --address-prefixes $vnet02add \
  --subnet-name $subnetName02 \
  --subnet-prefixes $sub02add \
  --location eastus

vnetName03=WEST-Vnet003
subnetName03=WEST-Snet003
vnet03add=192.168.0.0/16
sub03add=192.168.1.0/24

az network vnet create \
  --name $vnetName03 \
  --resource-group $RG \
  --address-prefixes $vnet03add \
  --subnet-name $subnetName03 \
  --subnet-prefixes $sub03add \
  --location westus

  echo "NSG creation"

az network nsg create -g ${RG} -n MyNsg001 --location eastus
az network nsg rule create -g ${RG} --nsg-name MyNsg001 -n MyNsgRule01 \
    --priority 400 --source-address-prefixes "*" --destination-address-prefixes "*" \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allow ALL trafic."


az network nsg create -g ${RG} -n MyNsg002 --location eastus
az network nsg rule create -g ${RG} --nsg-name MyNsg002 -n MyNsgRule02 \
    --priority 500 --source-address-prefixes "*" --destination-address-prefixes "*" \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allow ALL trafic."


az network nsg create -g ${RG} -n MyNsg003 --location westus
az network nsg rule create -g ${RG} --nsg-name MyNsg003 -n MyNsgRule03 \
    --priority 600 --source-address-prefixes "*" --destination-address-prefixes "*" \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allow ALL trafic."

echo " Create VM's"
vmName01=edaraVM2001

az vm create \
  --resource-group ${RG} \
  --name $vmName01 \
  --image UbuntuLTS \
  --vnet-name $vnetName01 \
  --subnet $subnetName01 \
  --admin-username venedara \
  --admin-password "Venkataramesh@01" \
  --size Standard_B1s \
  --nsg MyNsg01 \
  --public-ip-sku Standard \
  --location eastus

vmName02=edaraVM2002
az vm create \
  --resource-group ${RG} \
  --name $vmName02 \
  --image UbuntuLTS \
  --vnet-name $vnetName02 \
  --subnet $subnetName02 \
  --admin-username venedara \
  --admin-password "Venkataramesh@01" \
  --size Standard_B1s \
  --nsg MyNsg02 \
  --public-ip-sku Standard \
  --location eastus

vmName03=edaraVM2003
az vm create \
  --resource-group ${RG} \
  --name $vmName03 \
  --image UbuntuLTS \
  --vnet-name $vnetName03 \
  --subnet $subnetName03 \
  --admin-username venedara \
  --admin-password "Venkataramesh@01" \
  --size Standard_B1s \
  --nsg MyNsg03 \
  --public-ip-sku Standard \
  --location westus