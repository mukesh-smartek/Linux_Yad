#!/bin/bash
yad_cmd='yad --list --column="SIZE" --column="DATE & TIME" --column="File Path"'
file_content='"331" "16 OCt" "findfile.sh" "4.3K" "12 Dec" "session.sh"'

file_name="tmp.txt"
while IFS= read -r line
do	#-rwxrwxr-x 1 mkm mkm 4.1K Oct 22 15:02 /home/mkm/Documents/yad_tutorial/user_session_manager.sh
	size=$(echo "$line" | awk '{ print $5 }'
	echo $size 
done < "$file_name"

exit
CMD="$yad_cmd $file_content"
echo "YAD PRE: $yad_cmd"
echo "File: $file_content"

echo "CMD: $CMD"

SELECTED_ROW=$(eval "$CMD")
echo "SELECTED RECORD: $SELECTED_ROW"
