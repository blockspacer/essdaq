#!/bin/bash

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

#ensure that we are in the script directory
pushd $THISDIR

#get config variables
. ../../config/system.sh

PATH=$PATH:/home/mg/epics/base-3.16.1/bin/linux-x86_64
export EPICS_CA_ADDR_LIST=128.219.165.154:5066 

run_status=$(caget -t BL17:CS:RunControl:State 2>&1)

while true; do 
  echo " "

  while [  $run_status -lt 8 ]; do
    run_status=$(caget -t BL17:CS:RunControl:State 2>&1)
    pcharge=$(caget -t BL17:Det:PCharge:C 2>&1)
    echo -ne "\e[0K\r $(date +%FT%T) IDLE"
    sleep 1
  done

  RunNumber=$(caget -t BL17:CS:RunControl:LastRunNumber 2>&1)
  energy=$(caget -t BL17:CS:Energy:Ei 2>&1)
  TCDelay=$(caget -t BL17:Det:TH:DlyDet:TCDelay 2>&1)

  echo " "
  echo "Starting run"
  echo "RunNumber=$RunNumber Energy=$energy TCDelay=$TCDelay"
  prepend="${RunNumber}_${energy}meV_${TCDelay}us_"
  echo "prepend=$prepend"

  echo "START_NEW" | nc $DAQUIRI_IP 12345 -w 1
  ../../efu/efu_start.sh --file $THISDIR/Sequoia_mappings.json --dumptofile $HOME/data/efu_dump/$prepend
  play ./sounds/cow1.wav -q
  mvme/scripts/start_mvme.sh $MVME_IP

  sleep 5
  echo " "

  while [  $run_status -gt 7 ]; do
    run_status=$(caget -t BL17:CS:RunControl:State 2>&1)
    pcharge=$(caget -t BL17:Det:PCharge:C 2>&1)
    echo -ne "\e[0K\r $(date +%FT%T) RUNNING pcharge=$pcharge"
    sleep 1
  done

  echo " "
  echo "Stopping run"

  mvme/scripts/stop_mvme.sh $MVME_IP
  play ./sounds/cat_growl.wav -q
  sleep 3
  ../../efu/efu_stop.sh
  sleep 3
  echo "STOP" | nc $DAQUIRI_IP 12345 -w 2

done


