#!/bin/bash

#Source Directory
source_dir=/tmp/kasyap
echo "Source directory is $source_dir"

#Destination Directory
dest_dir=/tmp/kasyap/dest
echo "Destination directory is $dest_dir"

#Cron frequency in seconds
cron_frequency=30

#Setting counter variable to 0
COUNTER=0

#Calculating max counter variable based on cron frequency
MAX_COUNTER=`expr $cron_frequency / 5 - 1`
echo "max counter is $MAX_COUNTER"

#Looping until the destination directory is empty or max waiting time which ever is earlier
while [ ! -z "$(ls -A $dest_dir)" ]
do
	echo "Destination directory is not empty and counter is $COUNTER"
	if [ $COUNTER -gt $MAX_COUNTER ]
	then
		echo "Exceeded waiting time"
		exit 0;
	fi
	sleep 5s
	COUNTER=`expr $COUNTER + 1`
done
	
echo "Destination directory is empty, proceeding with next steps"

#Print the oldest file with timestamp
echo "Oldest timestamp and file in $source_dir are" $(find $source_dir -type f -printf '%AY-%Ad-%Am:%AH:%AM %p\n' | sort | head -n 1)

#Print the timestamp of oldest file
oldest_timestamp=$(find $source_dir -type f -printf '%AH:%AM %AY-%Am-%Ad \n' | sort | head -n 1)

#Print the frequency provided in hours
frequency=$(echo $1)

#Calculating end timestamp based on oldest timestamp and frequency of hours provided
end_timestamp=$(date -d"$oldest_timestamp  +$frequency hours" +"%Y-%m-%d %H:%M:%S")
echo "The end timestamp is $end_timestamp"

#printing files to be copied
echo "Below are the oldest $frequency hour files"
find $source_dir ! -newermt "$end_timestamp"

#Copying the files
find $source_dir ! -newermt "$end_timestamp" -exec cp {}  $dest_dir \;