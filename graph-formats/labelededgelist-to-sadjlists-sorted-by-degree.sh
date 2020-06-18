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
   | awk '{printf "%d %d\n%d %d\n", $1, $2, $2, $1}' \
   | sort -n -k1,1 -k2,2 \
   | uniq \
   | awk '{print $1; nedges+=1}' \
   | uniq -c \
   | sort -n -k1,1 -k2,2 \
   | awk '{print $2,NR-1}' \
   > ${outputfile}.remapping &

# generate adjlists (async)
cat ${inputfile} | grep -v "^#" \
   | awk '{printf "%d %d %d\n%d %d %d\n", $1, $2, $3, $2, $1, $3}' \
   | sort -n -k1,1 -k2,2 \
   | uniq \
   | awk -f $DIR/get-adjlists-edge-labeled.awk \
   | awk '{lastv=-1; sum=0; for (i=2; i<=NF; i=i+2) {if (lastv==-1 || $i != lastv) {sum+=1; lastv=$i} }; print sum,$0 }' \
   | sort -n -k1,1 -k2,2 \
   > ${outputfile}.sortedadjlists &

# sync
wait

# number of vertices and edges (async)
wc -l ${outputfile}.remapping | cut -d' ' -f1 > ${outputfile}.nvertices &
cat ${outputfile}.sortedadjlists \
   | awk '{lastv=-1; for (i=3; i<=NF; i=i+2) {if (lastv==-1 || $i != lastv) {sum+=1; lastv=$i} } } END {print sum/2}' \
   > ${outputfile}.nedges &

# sync
wait

nvertices=$(cat ${outputfile}.nvertices)
nedges=$(cat ${outputfile}.nedges)

>&2 echo "nvertices=$nvertices"
>&2 echo "nedges=$nedges"

echo "$nvertices $nedges" > ${outputfile}

awk -f $DIR/remap-sadjlists-edge-labeled.awk ${outputfile}.remapping ${outputfile}.sortedadjlists \
   | cut -d' ' -f2- \
   >> ${outputfile}

#rm -f ${outputfile}.remapping
#rm -f ${outputfile}.sortedadjlists
#rm -f ${outputfile}.nvertices
#rm -f ${outputfile}.nedges
