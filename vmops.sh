echo " start -- stop -- deallocate virtual machine"

az vm start -n "edaraVM11111" -g "peeringRG"

# 
# echo "stop VM's"
# az vm stop -n "edaraVM11111" -g "peeringRG"
# 
# # About to power off the specified VM...
# # It will continue to be billed. To deallocate a VM, run: az vm deallocate.
# 
# az vm stop -n "edaraVM11111" -g "peeringRG"
# 