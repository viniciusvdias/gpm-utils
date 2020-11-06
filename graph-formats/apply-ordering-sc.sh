#! /usr/bin/env bash

required="inputfile orderingfile outputfile"
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

nvertices=$(cat ${inputfile} | head -1 | awk '{print $1}')
nedges=$(cat ${inputfile} | head -1 | awk '{print $2}')

>&2 echo "nvertices=$nvertices"
>&2 echo "nedges=$nedges"

echo "$nvertices $nedges" > ${outputfile}

awk -f $DIR/reordering-sc.awk ${orderingfile} ${inputfile} \
   | sort -n -k1,1 \
   | awk -f $DIR/reordering-sc-fix-edges.awk \
   >> ${outputfile}
