#!/bin/bash

i=1
for f in *.tif; do
	mv "$f" "${i}.tif";
	i=$((i+1))
done

