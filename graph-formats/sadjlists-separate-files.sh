#! /usr/bin/env bash

required="inputfile outputdir"
for argname in $required; do
	if [ -z ${!argname+x} ]; then
		printf "error: $argname is unset\n"
                printf "$wholeusage\n"
		exit 1
	else
		echo "info: $argname is set to '${!argname}'"
	fi
done

mkdir -p $outputdir

# metadata
cat $inputfile | head -1 > $outputdir/metadata

# vlabels
cat $inputfile | awk 'NR > 1' | awk '{print $1}' | awk 'NF' \
   > $outputdir/vlabels

nvlabels=$(wc -l "$outputdir"/vlabels | awk '{print $1}')
echo $nvlabels
if [[ "$nvlabels" == "0" ]]; then
   rm $outputdir/vlabels
fi

# elabels
cat $inputfile | awk 'NR > 1' |  awk 'NF > 1' | cut -d" " -f2- | tr ' ' '\n' \
   | sed 's/^[0-9]*,//g' | tr ',' ' ' | sort -n -k1,1 | uniq \
   | awk '{print $2}' \
   | awk 'NF' \
   > $outputdir/elabels


nelabels=$(wc -l "$outputdir"/elabels | awk '{print $1}')
echo $nelabels
if [[ "$nelabels" == "0" ]]; then
   rm $outputdir/elabels
fi

# adjlists
cat $inputfile | awk 'NR > 1' \
   | awk '{for (i=2;i<=NF;++i) {printf "%s",$i; if (i!=NF) printf " "} printf "\n" }' \
   | awk '{print "  "$0"  "}' \
   | sed 's/\([^ ]*\)/ \1 /g' \
   | sed 's/ \([0-9]*,[0-9]*\),[^ ]* / \1 /g' \
   | awk '{for (i=1;i<=NF;++i) {printf "%s",$i; if (i!=NF) printf " "} printf "\n" }' \
   > $outputdir/adjlists
