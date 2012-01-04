#!/bin/bash

if [ "$1" != "-o" ]; then

	sources=`ls *.m 2>/dev/null`;

	for file in $sources; do
		echo `basename $file ".m"`.o;
	done;

	sources=`ls *.c 2>/dev/null`;

	for file in $sources; do
		echo `basename $file ".c"`.o;
	done;

elif [ "$1" == "-o" ]; then

	pushd $2 >/dev/null;
	objects=`ls *.o`;
	for i in $objects; do
		echo "$2/$i";
	done;
	popd >/dev/null;
	
fi

