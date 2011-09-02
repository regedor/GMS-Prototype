#!/bin/bash

file=$0

for i in $(ls -1)
do
  if [ -f $i ] && [ "$i" != "${0##*/}" ]
  then	
    $MAGICK_HOME/utilities/convert $i -resize 192x142! thumbs/$i
  fi
done