#!/bin/bash
echo "creating ResourceGroup"
RG=peeringRG
echo ${RG}
az group create -l centralus -n ${RG}

echo "Creating Azure Virtual Network"

vnetName111=east-Vnet1111
subnetName111=east-Snet1111
vnet11add=10.1.0.0/16
sub11add=10.1.1.0/24

az network vnet create \
  --name $vnetName111 \
  --resource-group $RG \
  --address-prefixes $vnet11add \
  --subnet-name $subnetName111 \
  --subnet-prefixes $sub11add \
  --location eastus

vnetName222=EAST-Vnet2222
subnetName222=EAST-Snet2222
vnet22add=172.16.0.0/16
sub22add=172.16.1.0/24

az network vnet create \
  --name $vnetName222 \
  --resource-group $RG \
  --address-prefixes $vnet22add \
  --subnet-name $subnetName222 \
  --subnet-prefixes $sub22add \
  --location eastus

vnetName333=west-Vnet3333
subnetName333=west-Snet3333
vnet33add=192.168.0.0/16
sub33add=192.168.1.0/24

az network vnet create \
  --name $vnetName333 \
  --resource-group $RG \
  --address-prefixes $vnet33add \
  --subnet-name $subnetName333 \
  --subnet-prefixes $sub33add \
  --location westus

echo "NSG creation"
az network nsg create -g ${RG} -n MyNsg1111 --location eastus
az network nsg rule create -g ${RG} --nsg-name MyNsg1111 -n MyNsgRule1111 \
    --priority 400 --source-address-prefixes "*" --destination-address-prefixes "*" \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allow ALL trafic."

az network nsg create -g ${RG} -n MyNsg2222 --location eastus
az network nsg rule create -g ${RG} --nsg-name MyNsg2222 -n MyNsgRule2222 \
    --priority 500 --source-address-prefixes "*" --destination-address-prefixes "*" \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allow ALL trafic."

az network nsg create -g ${RG} -n MyNsg3333 --location westus
az network nsg rule create -g ${RG} --nsg-name MyNsg3333 -n MyNsgRule3333 \
    --priority 600 --source-address-prefixes "*" --destination-address-prefixes "*" \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allow ALL trafic."

echo " Create VM's"
vmName111=edaraVM11111

az vm create \
  --resource-group ${RG} \
  --name $vmName111 \
  --image UbuntuLTS \
  --vnet-name $vnetName111 \
  --subnet $subnetName111 \
  --admin-username venedara \
  --admin-password "Venkataramesh@01" \
  --size Standard_B1s \
  --nsg MyNsg1111 \
  --public-ip-sku Standard \
  --location eastus

vmName222=edaraVM22222
az vm create \
  --resource-group ${RG} \
  --name $vmName222 \
  --image UbuntuLTS \
  --vnet-name $vnetName222 \
  --subnet $subnetName222 \
  --admin-username venedara \
  --admin-password "Venkataramesh@01" \
  --size Standard_B1s \
  --nsg MyNsg2222 \
  --public-ip-sku Standard \
  --location eastus

vmName333=edaraVM33333
az vm create \
  --resource-group ${RG} \
  --name $vmName333 \
  --image UbuntuLTS \
  --vnet-name $vnetName333 \
  --subnet $subnetName333 \
  --admin-username venedara \
  --admin-password "Venkataramesh@01" \
  --size Standard_B1s \
  --nsg MyNsg3333 \
  --public-ip-sku Standard \
  --location westus
  
echo "vnet peering"
  az network vnet peering create -g ${RG} -n MyVnet111ToMyVnet222 --vnet-name $vnetName111 \
    --remote-vnet $vnetName222 --allow-vnet-access
echo "vnet peering"
  az network vnet peering create -g ${RG} -n MyVnet222ToMyVnet111 --vnet-name $vnetName222 \
    --remote-vnet $vnetName111 --allow-vnet-access

az network vnet peering sync -g ${RG} -n MyVnet111ToMyVnet222 --vnet-name $vnetName111

az network vnet peering sync -g ${RG} -n MyVnet222ToMyVnet111 --vnet-name $vnetName222