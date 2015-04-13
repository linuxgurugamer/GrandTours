#!/bin/bash

echo -e "\n\n"

releasedir=~/release
mkdir -p $releasedir

major=0
major=`cat version-number.txt`
minor=`cat build-number.txt`
patch=`cat patch-number.txt`

curdir=`pwd`
i=`awk -v a="$curdir" -v b="GameData" 'BEGIN{print index(a,b)}'`
i=$((i-1))
curdir=`echo $curdir | cut -c1-${i}`

if [ "$1" = "mono" ]; then
	mono /Users/jbayer/Desktop/Kerbal/bin/netkan.exe  -v grandtours.netkan
	exit
fi

[ "$1" = "version" ] && exit

f=" GameData/ContractPacks/Spacetux/SharedAssets GameData/ContractPacks/Spacetux/Grandtours"
cd ~/install
rm -f ${releasedir}/GrandTours-${major}.${minor}.${patch}.zip
echo "zip -9r ${releasedir}/GrandTours-${major}.${minor}.${patch}.zip  $f"
zip -9r ${releasedir}/GrandTours-${major}.${minor}.${patch}.zip  $f
