#!/bin/bash
echo "creating ResourceGroup"
RG=MyRG01
echo ${RG}
az group create -l westus -n ${RG}

echo "Creating Azure Virtual Network"

vnetName01=Vnet01
subnetName01=Snet01
vnet01add=10.1.0.0/16
sub01add=10.1.1.0/24

az network vnet create \
  --name $vnetName01 \
  --resource-group $RG \
  --address-prefixes $vnet01add \
  --subnet-name $subnetName01 \
  --subnet-prefixes $sub01add
  
vnetName02=Vnet02
subnetName02=Snet02
vnet02add=10.2.0.0/16
sub02add=10.2.1.0/24

az network vnet create \
  --name $vnetName02 \
  --resource-group $RG \
  --address-prefixes $vnet02add \
  --subnet-name $subnetName02 \
  --subnet-prefixes $sub02add

vnetName03=Vnet03
subnetName03=Snet03
vnet03add=10.3.0.0/16
sub03add=10.3.1.0/24

az network vnet create \
  --name $vnetName03 \
  --resource-group $RG \
  --address-prefixes $vnet03add \
  --subnet-name $subnetName03 \
  --subnet-prefixes $sub03add

  echo "NSG creation"

az network nsg create -g ${RG} -n MyNsg01 --location westus
az network nsg rule create -g ${RG} --nsg-name MyNsg01 -n MyNsgRule01 \
    --priority 400 --source-address-prefixes "*" --destination-address-prefixes "*" \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allow ALL trafic."


az network nsg create -g ${RG} -n MyNsg02 --location westus
az network nsg rule create -g ${RG} --nsg-name MyNsg02 -n MyNsgRule02 \
    --priority 500 --source-address-prefixes "*" --destination-address-prefixes "*" \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allow ALL trafic."


az network nsg create -g ${RG} -n MyNsg03 --location westus
az network nsg rule create -g ${RG} --nsg-name MyNsg03 -n MyNsgRule03 \
    --priority 600 --source-address-prefixes "*" --destination-address-prefixes "*" \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allow ALL trafic."

echo " Create VM's"
vmName01=edaraVM001

az vm create \
  --resource-group ${RG} \
  --name $vmName01 \
  --image UbuntuLTS \
  --vnet-name $vnetName01 \
  --subnet $subnetName01 \
  --admin-username venedara \
  --admin-password "Venkataramesh@01" \
  --size Standard_B1s \
  --nsg MyNsg01 


vmName02=edaraVM002
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
  --public-ip-sku Standard

vmName03=edaraVM003
az vm create \
  --resource-group ${RG} \
  --name $vmName03 \
  --image UbuntuLTS \
  --vnet-name $vnetName03 \
  --subnet $subnetName03 \
  --admin-username venedara \
  --admin-password "Venkataramesh@01" \
  --size Standard_B1s \
  --nsg MyNsg03
  --public-ip-sku Standard