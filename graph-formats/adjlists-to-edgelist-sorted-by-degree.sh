#! /usr/bin/env bash

required="inputfile outputfile"
for argname in $required; do
	if [ -z ${!argname+x} ]; then
		printf "error: $argname is unset\n"
                printf "$wholeusage\n"
		exit 1
	else
		echo "info: $argname is set to '${!argname}'"
	fi
done

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# generate mapping (async)
cat ${inputfile} | grep -v "^#" \
   | awk '{for (i=3; i<=NF; ++i) printf "%d %d\n%d %d\n", $1, $i, $i, $1}' \
   | sort -n -k1,1 -k2,2 \
   | uniq \
   | awk '{print $1; nedges+=1}' \
   | uniq -c \
   | sort -n -k1,1 -k2,2 \
   | awk '{print $2,NR-1}' \
   > ${outputfile}.remapping

cat ${inputfile} | grep -v "^#" \
   | awk '{for (i=3; i<=NF; ++i) printf "%d %d\n%d %d\n", $1, $i, $i, $1}' \
   | sort -n -k1,1 -k2,2 \
   | uniq \
   > ${outputfile}.edgelist

awk -f $DIR/remap-edgelist.awk ${outputfile}.remapping ${outputfile}.edgelist \
   > ${outputfile}

# rm -f ${outputfile}.edgelist
