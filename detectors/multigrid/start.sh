#!/bin/bash

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

#ensure that we are in the script directory
pushd $THISDIR

#get config variables
. ../../config/system.sh

../../efu/efu_start.sh --file $THISDIR/Utgard_mappings.json
sleep 3
mvme/scripts/start_mvme.sh $MVME_IP