#! /usr/bin/env bash

edges=$(echo $1 | tr ',' '\n')
vlabels=$(echo $2 | tr ',' '\n')
lab=${3:-"edges=$1 vlabels=$2"}

echo $lab

vertices=$(echo "$edges" | tr ' ' '\n' | sort -n | uniq)

colormap=$(echo "$vlabels" | sort -n | uniq | awk '{print $0,NR}')

gvnodes=$(awk 'FNR == NR {ids[$1] = $2; next} {print FNR-1,$1,ids[$1]}' <(echo "$colormap") <(echo "$vlabels") \
   | awk '{print "node [style=filled,color="$3",label=\""$1","$2"\"]"$1";"}')

gvedges=$(echo "$edges" | awk '{print $1"--"$2";"}')

header="graph{ label=\"$lab\"; node [colorscheme=set312];"
footer="}"

gv="$header $gvnodes $gvedges $footer"
echo $gv
echo "$gv" | sfdp -Tx11
