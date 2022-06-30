# if statement to check if the folder exists and if it doesn't to create it
if [ ! -d /home/jack/documents/scripts/old_pathways ]; then
	# make directory if it does not exist
	mkdir -p /home/jack/documents/scripts/old_pathways;
else
echo "folder already exists"

# copies out previous day's pathways file and renames it with the date at the end
cp /home/jack/documents/scripts/pathways /home/jack/documents/scripts/pathways_"$(date)"

# retrieves new pathways file from url
wget -p /home/jack/documents/scripts https://github.com/jack-percival/Find-crontab/blob/main/pathways.sh

file="/home/jack/documents/scripts/pathways"
lines=$(cat $file)
for line in $lines
do 
	find -mtime +2 -type f
done
