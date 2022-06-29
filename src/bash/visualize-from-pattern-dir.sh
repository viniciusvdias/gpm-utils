#! /usr/bin/env bash

patterndir=$1

cat $patterndir/edges \
   | awk 'BEGIN {g=""} {if (NR == 1) {g=$1"--"$2} else {g=g";"$1"--"$2}} END {print "graph{"g"}"}' \
   | sfdp -Tx11
