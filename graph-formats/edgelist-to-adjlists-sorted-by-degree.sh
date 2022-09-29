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

if [ -z "$remappingfile" ]; then
   printf "remapping file not found. Remapping ..."
   remappingfile="${outputfile}.remapping"

   # generate mapping (async)
   cat ${inputfile} | grep -v "^#" \
      | awk '{printf "%d %d\n%d %d\n", $1, $2, $2, $1}' \
      | sort -n -k1,1 -k2,2 \
      | uniq \
      | awk '{print $1; nedges+=1}' \
      | uniq -c \
      | sort -n -k1,1 -k2,2 \
      | awk '{print $2,NR-1}' \
      > $remappingfile
fi

# generate adjlists (async)
cat ${inputfile} | grep -v "^#" \
   | awk '{printf "%d %d\n%d %d\n", $1, $2, $2, $1}' \
   | sort -n -k1,1 -k2,2 \
   | uniq \
   | awk -f $DIR/get-adjlists.awk \
   | awk '{print NF-1,$0}' \
   > ${outputfile}.sortedadjlists &

wait

# number of vertices and edges (async)
wc -l $remappingfile | cut -d' ' -f1 > ${outputfile}.nvertices &
cat ${outputfile}.sortedadjlists | awk '{sum+=NF-2} END {print sum/2}' > ${outputfile}.nedges &

wait

nvertices=$(cat ${outputfile}.nvertices)
nedges=$(cat ${outputfile}.nedges)

>&2 echo "nvertices=$nvertices"
>&2 echo "nedges=$nedges"

echo "# $nvertices $nedges" > ${outputfile}

awk -f $DIR/remap-adjlists.awk $remappingfile ${outputfile}.sortedadjlists \
   >> ${outputfile}

#rm -f ${outputfile}.remapping
rm -f ${outputfile}.sortedadjlists
rm -f ${outputfile}.nvertices
rm -f ${outputfile}.nedges
