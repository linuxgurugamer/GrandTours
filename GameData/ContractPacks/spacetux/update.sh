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

#d=`date +%Y%m%d-%H:%m`
#FILES="GrandTour.version"
#for i in $FILES; do
#	mv $i ${i}.$d
#	sed "s/<MAJOR>/$major/g" ${i}.template | sed "s/<MINOR>/$minor/g" | sed "s/<PATCH>/$patch/g" >$i
#done

[ "$1" = "version" ] && exit

#if [ "$1" = "nopatch" ]; then
#	shift
#else
#	patch=$((patch+ 1))
#	echo $patch>patch-number.txt
#fi

cd ~/install
rm -f ${releasedir}/GrandTours-${major}.${minor}.${patch}.zip
echo "zip -9r ${releasedir}/GrandTours-${major}.${minor}.${patch}.zip  $1"
zip -9r ${releasedir}/GrandTours-${major}.${minor}.${patch}.zip  $1
