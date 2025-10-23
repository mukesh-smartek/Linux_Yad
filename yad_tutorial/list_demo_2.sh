#!/bin/bash
yad_cmd='yad --list --column="SIZE" --column="DATE & TIME" --column="File Path"'
file_content='"331" "16 OCt" "findfile.sh" "4.3K" "12 Dec" "session.sh"'

file_name="tmp2.txt"
content=""
while IFS= read -r line
do	#-rwxrwxr-x 1 mkm mkm 4.1K Oct 22 15:02 /home/mkm/Documents/yad_tutorial/user_session_manager.sh
	size=$(echo "$line" | awk '{ print "\"" $5 "\"" }')
	date_time=$(echo "$line" | awk '{ print "\"" $6 $7 $8 "\"" }')
	name=$(echo "$line" | awk '{ print "\"" $9 "\"" }')
	row=$(printf "$size  $date_time  $name ")
	#echo $row
	content+=$row
done < "$file_name"



CMD="$yad_cmd $content"
#echo "YAD PRE: $yad_cmd"
#echo "File: $content"

#echo "CMD: $CMD"



SELECTED_ROW=$(eval "$CMD")
echo "SELECTED RECORD: $SELECTED_ROW"
