#! /usr/bin/env bash

required="basedir outputfile"
for argname in $required; do
	if [ -z ${!argname+x} ]; then
		>&2 printf "error: $argname is unset\n"
                >&2 printf "$wholeusage\n"
		exit 1
	else
		>&2 echo "info: $argname is set to '${!argname}'"
	fi
done

tmpdir=$(mktemp -d -t packfiles-XXXXXXXXXX)

for f in `find $basedir -type f`; do
   basenamef=$(basename $f)
   gzip -c $f > $tmpdir/$basenamef.gz &
done

wait

cd $tmpdir
zip -q -r $outputfile ./* 
echo $tmpdir/$outputfile
