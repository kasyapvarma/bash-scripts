#!/bin/bash

#Source Directory
source_dir=$1
echo "Source directory is $source_dir"

#Destination Directory
dest_dir=$2
echo "Destination directory is $dest_dir"

#Cron job frequency in seconds. If scheduled for 1 hour, then configure it to 3600
cron_frequency=3600

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
time_and_file=$(find $source_dir -type f -printf '%T+ %p\n' | sort | head -n 1)
echo "Oldest timestamp and file in $source_dir are" $time_and_file
oldest_file=$(echo "$time_and_file" | cut -d" " -f2)

#Print the timestamp of oldest file
oldest_file_date=$(stat --printf=%y $oldest_file | cut -d. -f1 | cut -d" " -f1)
oldest_file_time=$(stat --printf=%y $oldest_file | cut -d. -f1 | cut -d" " -f2)
oldest_timestamp=$(echo $oldest_file_time" "$oldest_file_date)

#Print the frequency provided in minutes
frequency=$(echo $3)

#Calculating end timestamp based on oldest timestamp and frequency of minutes provided
end_timestamp=$(date -d"$oldest_timestamp  +$frequency minutes" +"%Y-%m-%d %H:%M:%S")
echo "The end timestamp is $end_timestamp"

#printing files to be copied
echo "Below are the oldest $frequency hour files"
find $source_dir ! -newermt "$end_timestamp"

#Copying the files
find $source_dir ! -newermt "$end_timestamp" -exec mv {}  $dest_dir \;