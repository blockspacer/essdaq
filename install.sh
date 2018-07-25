#!/bin/bash

#ensure that we are in the script directory
pushd $(dirname "${BASH_SOURCE[0]}")

# build with 1 less than total number of CPUS, minimum 1
NUMCPUS=$(cat /proc/cpuinfo | grep -c processor)
let NUMCPUS-=1
if [ "$NUMCPUS" -lt "1" ]; then
  NUMCPUS=1
fi

read -r -p "Before we proceed, it is rocommended that you update your system's packages. Shall we do this? [Y/n]" aptupdate
aptupdate=${aptupdate,,} # tolower
if [[ $aptupdate =~ ^(yes|y| ) ]]; then
  sudo apt update
fi

#TODO: should determine this automatically?
read -r -p "Use ssh instead of http for cloning repos? [Y/n]" usessh
usessh=${usessh,,} # tolower


read -r -p "Install and setup conan? [Y/n]" getconan
getconan=${getconan,,} # tolower
if [[ $getconan =~ ^(yes|y| ) ]]; then
  #TODO: do we use python3 instead?
  sudo apt install -y python-pip
  sudo pip2 install conan
  conan remote add conancommunity https://api.bintray.com/conan/conan-community/conan
  conan remote add conan-transit https://api.bintray.com/conan/conan/conan-transit
  conan remote add bincrafters https://api.bintray.com/conan/bincrafters/public-conan
  conan remote add ess-dmsc https://api.bintray.com/conan/ess-dmsc/conan
  conan profile new --detect default
  #TODO: only ubuntu
  conan profile update settings.compiler.libcxx=libstdc++11 default
fi

read -r -p "Install docker and start up grafana? [Y/n]" getgrafana
getgrafana=${getgrafana,,} # tolower
if [[ $getgrafana =~ ^(yes|y| ) ]]; then
  grafana/install.sh
fi

read -r -p "Install kafka? [Y/n]" getfkafka
getfkafka=${getfkafka,,} # tolower
if [[ $getfkafka =~ ^(yes|y| ) ]]; then
  ./kafka/install.sh
fi

read -r -p "Get and build EFU? [Y/n]" getefu
getefu=${getefu,,} # tolower
if [[ $getefu =~ ^(yes|y| ) ]]; then
  sudo apt install -y cmake libpcap-dev ethtool
  #TODO: could be libpcap-devel on CentOS
  if [[ $usessh =~ ^(yes|y| ) ]]; then
    git clone git@github.com:ess-dmsc/event-formation-unit.git
  else
    git clone https://github.com/ess-dmsc/event-formation-unit.git
  fi
  mkdir ./event-formation-unit/build
  pushd event-formation-unit/build
  cmake ..
  #(or -DCMAKE_BUILD_TYPE=Release -DBUILDSTR=speedtest ..)
  make -j$NUMCPUS && make unit_tests -j$NUMCPUS
  make runtest && make runefu
  popd
fi

read -r -p "Get and build Daquiri? [Y/n]" getdaquiri
getdaquiri=${getdaquiri,,} # tolower
if [[ $getdaquiri =~ ^(yes|y| ) ]]; then
  sudo apt install -y cmake qt5-default
  if [[ $usessh =~ ^(yes|y| ) ]]; then
    git clone git@github.com:ess-dmsc/daquiri.git
  else
    git clone https://github.com/ess-dmsc/daquiri.git
  fi
  pushd daquiri
  ./utils/first_build.sh -j$NUMCPUS
  popd
fi
