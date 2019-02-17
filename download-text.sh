#!/bin/bash

if [ ! -d text ]
then
	mkdir text
	cat audiobooks.tsv|awk -F'\t' '{print $3}' > text/input
	pushd text
	wget -i input
	popd
fi
