#!/bin/bash

if [ "$1" = "clean" ]; then
	rm -f *.cfg
	exit
fi
major=0
major=`cat version-number.txt`
minor=`cat build-number.txt`
patch=`cat patch-number.txt`
FILES="GrandTour.version"
for i in $FILES; do
        sed "s/<MAJOR>/$major/g" ${i}.template | sed "s/<MINOR>/$minor/g" | sed "s/<PATCH>/$patch/g" >$i
done

