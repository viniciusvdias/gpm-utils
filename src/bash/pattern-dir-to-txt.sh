#! /usr/bin/env bash

patterndir=$1

edges=$(cat $patterndir/edges | tr ' ' ',' | awk '{print "("$0")"}' \
   | paste -sd ",")

nedges=$(cat $patterndir/edges | wc -l)

vlabels=$(cat $patterndir/vlabels | paste -sd ",")


if [[ -f "$patterndir/elabels" ]]; then
   elabels=$(cat $patterndir/elabels | paste -sd ",")
else
   elabels=$(cat $patterndir/edges | awk '{print "0"}' | paste -sd ",")
fi

echo "edges=[$edges],vlabels=[$vlabels],elabels=[$elabels]"
