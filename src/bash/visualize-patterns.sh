#! /usr/bin/env bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

while IFS='$\n' read -r line; do
   for patternstr in $line; do
      $DIR/visualize-pattern-from-txt.sh "$patternstr" &
   done
done

wait
