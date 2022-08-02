#!/bin/sh
set -x

SEARCH_TARGET=$1
MTIME_VAL=$2

if [-z $1]
then 
	SEARCH_TARGET=$1
fi

if [-z $2]
then 
	MTIME_VAL=+2
fi 

# if statement to check if the folder exists and if it doesn't to create it
date=$(date +"%d-%m-%Y_%T")

 if [ ! -d /home/jack/documents/scripts/old_cleanup_paths ]; then
     # make directory if it does not exist
         mkdir -p /home/jack/documents/scripts/old_cleanup_paths;
 else
         echo "folder already exists"
 fi

 #checks to see if previous command has ran succesfully
 if [ $? -eq 0 ]; then
     echo "folder created or already exists"
 else
     echo "mkdir failed"
     exit
 fi

# #if statement to make the output file
 if [ ! -d /home/jack/documents/scripts/find_crontab/output ]; then
             # make directory if it does not exist
               touch /home/jack/documents/scripts/find_crontab/output;
         else
             echo "file already exists"
 fi

# #checks to see if previous command has ran succesfully
 if [ $? -eq 0 ]; then
            echo "file created or already exists"
 else
                echo "output file creation failed"
            exit
 fi

# # copies out previous day's pathways file and renames it with the date at the end.
 cp /home/jack/documents/scripts/find_crontab/cleanup_paths /home/jack/documents/scripts/old_cleanup_paths/cleanup_paths_'$(date)'

# #checks to see if previous command has ran succesfully
 if [ $? -eq 0 ]; then
            echo "copied succesfully"
     else
         echo "copy failed"
                 exit
 fi

# # retrieves new pathways file from url
# # wget -O is used because we only want to download that specific file not the whole html code
wget -O /home/jack/documents/scripts/cleanup_paths https://raw.githubusercontent.com/jack-percival/find-crontab/main/cleanup_paths

# #checks to see if previous command has ran succesfully
 if [ $? -eq 0 ]; then
            echo "file succesfully downloaded"
     else
         echo "wget failed"
         exit
                
 fi

#get cwd
DIR="$( cd "$( dirname -- "$0" )" && pwd )"

#runs find against every path defintie in cleanup_paths. Outputs the results to the output file with the current date to create a log of all files deleted.
file=$DIR/cleanup_paths
outfile=$DIR/output

# empty the outfile
if [ -f $outfile ]; then
	    mv $outfile $outfile.$date
fi

touch $outfile
chmod 777 $outfile
lines=$(cat $file | sed 's/\r//')
for line in $lines
do 
	    if [ -d $line ]; then
		    # creates a list of all files to be processed and appends it to the output file
		                find $line -type f -mtime $MTIME_VAL -name $SEARCH_TARGET | tr " " "\n" >> $DIR/output
				    fi

			    done

			    #checks to see if previous command has ran succesfully
			    if [ $? -eq 0 ]; then
				               echo "find succesfully ran"
					           else
							           echo "find failed"
								                   exit

			    fi

			    #searches through the output file and deletes all files designated 
			    delete_file=$DIR/output
			    delete_lines=$(cat $delete_file | grep -v ^#)
			    for line in $delete_lines
			    do
				      rm -f $line 
			      done

			      #checks to see if previous command has ran succesfully
			      if [ $? -eq 0 ]; then
				                         echo "delete succesfully ran"
							                     else
										                                        echo "delete failed" 
															                                   exit
			      fi
