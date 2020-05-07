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
   | awk '{print NF-1,$0}' \
   | sort -n -k1,1 -k2,2 \
   | awk '{print $2,NR-1}' \
   > ${outputfile}.remapping &

# generate adjlists (async)
cat ${inputfile} | grep -v "^#" \
   | awk '{print NF-2,$0}' \
   | sort -n -k1,1 -k2,2 \
   > ${outputfile}.sortedadjlists &

# sync
wait

# number of vertices and edges (async)
wc -l ${outputfile}.remapping | cut -d' ' -f1 > ${outputfile}.nvertices &
cat ${outputfile}.sortedadjlists | awk '{sum+=NF-3} END {print sum/2}' > ${outputfile}.nedges &

# sync
wait

nvertices=$(cat ${outputfile}.nvertices)
nedges=$(cat ${outputfile}.nedges)

>&2 echo "nvertices=$nvertices"
>&2 echo "nedges=$nedges"

echo "$nvertices $nedges" > ${outputfile}

awk -f $DIR/remap-sadjlists-vertex-labeled.awk ${outputfile}.remapping ${outputfile}.sortedadjlists \
   | cut -d' ' -f2- \
   >> ${outputfile}

#rm -f ${outputfile}.remapping
rm -f ${outputfile}.sortedadjlists
rm -f ${outputfile}.nvertices
rm -f ${outputfile}.nedges
