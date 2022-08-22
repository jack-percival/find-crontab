#!/bin/sh
set -x

SEARCH_TARGET=$1
MTIME_VAL=$2
OCP=$3
OUTPUT=$4
OLD_LOGS=$5 
FOLDERS_TO_CLEAN=$6
#checks that first variable is defined when parsing in parameters. $1 is used to the -name switch in find
if [-z $1]
then 
	SEARCH_TARGET=$1
fi

#checks that second variaable is defined when parsing in parameters. $2 is used to designate the mtime switch
if [-z $2]
then 
	MTIME_VAL=$2
fi 

#checks that third variaable is defined when parsing in parameters. $3 is used to designate the folder path that old cleanup paths are moved to 

if [-z $2]
then
	OCP=$3
fi

#checks that fourth variaable is defined when parsing in parameters. $4 is used to designate the output which the find command will populate with files to delete
if [-z $2]
then
	OUTPUT=$4
fi

#checks that fifth variaable is defined when parsing in parameters. $5 is used to designate the file for cp to copy out to create a log of folders scanned previous days
if [-z $2]
then
	OLD_LOGS=$5
fi

#checks that sixth variaable is defined when parsing in parameters. $6 is used to designate the file to be downloaded by wget. This file contains the absolute paths of folders that are to be cleaned
if [-z $2]
then
	FOLDERS_TO_CLEAN=$6
fi

# if statement to check if the folder exists and if it doesn't to create it
date=$(date +"%d-%m-%Y_%T")

 if [ ! -d $OCP ]; then
     # make directory if it does not exist
         mkdir -p $OCP;
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
 if [ ! -d $OUTPUT ]; then
             # make directory if it does not exist
               touch $OUTPUT;
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
 cp $OLD_LOGS 

# #checks to see if previous command has ran succesfully
 if [ $? -eq 0 ]; then
            echo "copied succesfully"
     else
         echo "copy failed"
                 exit
 fi

# # retrieves new pathways file from url
# # wget -O is used because we only want to download that specific file not the whole html code

wget -O $FOLDERS_TO_CLEAN 

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

#creates the outfile and sets permissing to be edited
touch $outfile
chmod 777 $outfile
#removes any carriage returns in case windows has interferred and messed up how the lines are output to the file
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
