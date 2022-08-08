#! /usr/bin/env bash

patterndir=$1

lab="\"$(basename $patterndir)\""
echo $lab

cat $patterndir/edges \
   | awk -v lab=$lab 'BEGIN {g=""} {if (NR == 1) {g=$1"--"$2} else {g=g";"$1"--"$2}} END {print "graph{label="lab";"g"}"}' \
   | sfdp -Tx11
