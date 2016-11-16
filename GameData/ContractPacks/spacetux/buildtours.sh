#!/bin/bash


templatefile=cfg.template
parameterfile=planetparameter.template
landedfile=landed.template

KerbolMultiplier="2"
MohoMultiplier="7"
EveMultiplier="5"
GillyMultiplier="6"
KerbinMultiplier="1.5"
MunMultiplier="2"
MinmusMultiplier="2.5"
DunaMultiplier="5"
IkeMultiplier="5"
DresMultiplier="6"
JoolMultiplier="6"
LaytheMultiplier="8"
VallMultiplier="8"
TyloMultiplier="8"
BopMultiplier="8"
PolMultiplier="8"
EelooMultiplier="10"

tourlist=(
	"inner_planets,Moho,Eve"
	"inner_planets_and_moons,Moho,Eve,Gilly"
	"outer_planets,Duna,Dres,Jool,Eeloo"
	"outer_planets_with_moons,Duna,Ike,Dres,Jool,Laythe,Vall,Tylo,Bop,Pol"
	"all_planets,Moho,Eve,Duna,Dres,Jool,Eeloo"
	"all_planets_and_moons,Mun,Minmus,Moho,Eve,Gilly,Duna,Ike,Dres,Jool,Laythe,Vall,Tylo,Bop,Pol"
)
numTours=${#tourlist[@]}

#echo "Total waypoints (including landing point): $numWaypoints"

function readtours
{
	tours=("${@}")
	numTours=${#tours[@]}
}

function parameters
{

	cnt=0
	while IFS=$'\n' read -r var ; do
		vars[$cnt]=$var
		cnt=$((cnt+1))
	done < $parameterfile
	n=${#vars[@]}
	
	if [ $landed -eq 1 ]; then
		cnt=0
		while IFS=$'\n' read -r var ; do
			landedvars[$cnt]=$var
			cnt=$((cnt+1))
		done < $landedfile
		nl=$cnt
	fi
	for planetindex in $*; do
		planetindex=`echo $planetindex | sed 's/,//g'`	
		for s in `seq 0 $n`; do
			oIFS=$IFS
			IFS=
			echo ${vars[${s}]} | sed "s/<PLANET>/$planetindex/g"
			IFS=$oIFS
		done
		if [ $landed -eq 1 ]; then
			for s in `seq 0 $nl`; do
				oIFS=$IFS
				IFS=
				echo ${landedvars[${s}]} | sed "s/<PLANET>/$planetindex/g"
				IFS=$oIFS
			done
		fi
	done
}



readtours "${tourlist[@]}"



exec 3>&1
for (( i=0; i<${numTours}; i++ ));
do
	linearray=($(awk -F, '{$1=$1} 1' <<<"${tours[${i}]}"))	
	numElements=${#linearray[@]}

echo ${tours[${i}]}

	for landed in 0 1; 
	do
		if [ $landed -eq 0 ]; then
			land=""
		else
			land=".land"
		fi
		exec 1<&-
		exec 1>&3
		tourname=${linearray[0]}
		t=$tourname
		the=""
		[ "${tourname:0:11}" != "all_planets" ] && the="the "
		tourname=`echo $tourname | sed 's/_/ /g'`
		if [ "$the" = "" ]; then
			tourname="all the ${tourname:4}"
		fi
		outfile="${t}${land}.grandtour.cfg"
echo $outfile
		rm -f $outfile
		exec 1<>"$outfile"
		planetnames=""
		contractTourname="${t}${land}"

		multiplier=$((landed + 1))
		for i2 in `seq 1 $((numElements-1))`; do
			oIFS=$IFS
			IFS=
			[ $i2 -gt 1 ] && planetnames="$planetnames, "
			planetnames="${planetnames}${linearray[$i2]}"
v="${linearray[$i2]}Multiplier"
multiplier="${multiplier} + ${!v}"
			IFS=$oIFS
		done

		cnt=0
		while IFS='' read -r var ; do
			oIFS=$IFS
			IFS=
			var=`echo $var | sed "s/<CONTRACT_TOURNAME>/$contractTourname/g" | sed "s/<TOURNAME>/$tourname/g" | sed "s/<PLANETNAMES>/$planetnames/g" | sed "s/<THE>/$the/g" | sed "s/<REWARDMULTIPLIER>/$multiplier/g"`
			if [ $landed -eq 0 ]; then
				land=""
			else
				land=" and land on each planet"
				[[ "$tourname" == "*moon*" ]] && land="${land}/moon"
			fi
			var=`echo $var | sed "s|<LAND>|$land|g"`
			template[$cnt]=$var
			IFS=$oIFS
			cnt=$((cnt+1))
		done < $templatefile
		templatelines=${#template[@]}

		for (( lines = 0;lines < ${templatelines}; lines++ ));
		do
			if [[ "${template[${lines}]}" =~ "<PLANETPARAMETER>" ]]; then
				parameters $planetnames
				continue
			fi
			oIFS=$IFS
			IFS=
			echo ${template[$lines]}
			IFS=$oIFS
		done
	done
done

exit

