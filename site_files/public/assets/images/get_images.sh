#!/bin/bash

cd $1
for album in $(ls -1)
do	
  if [ -d $album ] && [ "$album" != "thumbs" ]
  then
    echo $album
  fi
done