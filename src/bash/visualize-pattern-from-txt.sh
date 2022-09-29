#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

patternstr=$1

edgesstr=$(echo $patternstr | sed 's/edges=\[\(.*\)\],vlabels=.*/\1/g' \
   | sed 's/),(/\n/g' | tr -d '()' | tr ',' ' ' | paste -sd ',')

vlabelsstr=$(echo $patternstr \
   | sed 's/edges=\[.*\],vlabels=\[\(.*\)\],elabels=.*/\1/g')

echo $edgesstr
echo $vlabelsstr

echo $DIR

$DIR/visualize-pattern-with-graphviz.sh "$edgesstr" "$vlabelsstr" \
   "$(echo $patternstr | sed 's/,vlabels=/\nvlabels=/g' \
   | sed 's/,elabels=/\nelabels=/g')"
