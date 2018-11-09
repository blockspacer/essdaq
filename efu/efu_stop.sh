#!/bin/bash

#ensure that we are in the script directory
pushd $(dirname "${BASH_SOURCE[0]}")

#get config variables
. ../config/system.sh

echo "Stopping EFU by sending EXIT to $EFU_IP"
echo "EXIT" | nc $EFU_IP 8888
echo " "
