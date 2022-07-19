#!/bin/bash -x
# if statement to check if the folder exists and if it doesn't to create it
if [ ! -d /home/jack/documents/scripts/old_cleanup_paths ]; then
	# make directory if it does not exist
	mkdir -p /home/jack/documents/scripts/old_cleanup_paths;
else
echo "folder already exists"

if [ $? -eq 0 ]; then
	echo "folder created or already exists"
else
	echo "mkdir failed"
	exit
fi

# copies out previous day's pathways file and renames it with the date at the end.
cp /home/jack/documents/scripts/cleanup_paths /home/jack/documents/scripts/old_cleanup_paths/cleanup_paths_"$(date)"

if [ $? -eq 0 ]; then
	        echo "copied succesfully"
	else
		echo "copy failed"
		        exit
fi

# retrieves new pathways file from url
# wget -O is used because we only want to download that specific file not the whole html code
wget -O /home/jack/documents/scripts/cleanup_paths https://raw.githubusercontent.com/jack-percival/Find-crontab/main/cleanup_paths

if [ $? -eq 0 ]; then
	        echo "file succesfully downloaded"
	else
		echo "wget failed"
		        exit
fi

#runs the find command against every pathway designated in the pathways.sh 
file=/home/jack/documents/scripts/cleanup_paths
lines=$(cat $file | sed 's/\r//')
for line in $lines
do 
	if [ $line-d ]; then
			sudo echo $line
			sudo find $line -mtime +2 -type f -name "*.logs" | tr " " "\n"  >> /home/jack/documents/scripts/find_crontab/output
		else
			echo "directory does not exist"
	fi

done
fi

if [ $? -eq 0 ]; then
	        echo "find succesfully ran"
	else
		echo "find failed"
		        exit

fi

delete_file=/home/jack/documents/scripts/find_crontab/output
delete_lines=$(cat $delete_file)
for line in $delete_lines
do
       	sudo echo $line 
															done
