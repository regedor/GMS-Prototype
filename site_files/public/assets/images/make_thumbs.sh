#!/bin/bash

if [ "$1" == "-c" ]
then	
  rm -r thumbs/* 2>/dev/null	
fi	

for album in $(ls -1)
do	
  if [ -d $album ] && [ "$album" != "thumbs" ]
  then	
    for image in $(ls -1 $album)
    do
	  mkdir thumbs/$album 2>/dev/null
      convert $album/$image -resize 192x142! thumbs/$album/$image
    done  
  fi
done