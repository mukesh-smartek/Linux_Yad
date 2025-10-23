#!/bin/bash

WIDTH=700
LINE_LENGTH=180
LINE=$(printf "%-${LINE_LENGTH}s" "-" | tr ' ' '-')

#> DEFINATION: Find Form Dialog
function find_input_form(){
	INPUT=$(yad --center --undecorated --form  \
	--text="[MKM]: Find Files\n$LINE"   \
	--field="📁 Directory to Search:DIR" "/" \
	--field="📄 File Pattern" "*filename*type"  \
	--field="Is File pattern case Sensitive:CHK"  "" \
	--field="Select Type:CB" "File!Directory!Link" \
	--field=":LBL"  \
	--field="--Optional Parameters--:LBL" \
	--field=":LBL"  \
	--field="Minimum size [e.g., 1k, 10M] (Optional)" "" \
	--field="Modified within [days] (Optional)" "" \
	--image="$(pwd)/icons/humming-bird_5.png" \
	--window-icon="$(pwd)/icons/humming-bird_16.png" \
	--button="gtk-close:1" \
	--button="gtk-ok:0")
	
	echo $INPUT
}

#> CALLING: Find Form Dialog
INPUT=$(find_input_form)
#> Parsing input
DIR=$(echo "$INPUT" | cut -d'|' -f1)
PATTERN=$(echo "$INPUT" | cut -d'|' -f2)
SENSITIVE=$(echo "$INPUT" | cut -d'|' -f3)
TYPE=$(echo "$INPUT" | cut -d'|' -f4)
SIZE=$(echo "$INPUT" | cut -d'|' -f5)
DAYS=$(echo "$INPUT" | cut -d'|' -f6)

#> TESTING: Printing User Inputs
printf "ALL INPUTS: $INPUT \n"
#printf "DIR: $DIR\n"
#printf "PATTERN: $PATTERN\n"
printf "CASE SENSITIVE: $SENSITIVE\n" 
#printf "TYPE:..$TYPE..\n"
#printf "SIZE: $SIZE \n"
#printf "DAYS: $DAYS \n"

#exit ;
#> Run find command
case $TYPE in
    File) TYPE_OPT="-type f" ;;
    Directory) TYPE_OPT="-type d" ;;
    Link) TYPE_OPT="-type l" ;;
esac

#> TESTING: Printing type of file to be search syntax
#echo "TYPE SYNTAX: $TYPE_OPT"

#Build find command
CMD="find \"$DIR\""

[ "$TYPE" ] && CMD+=" "$TYPE_OPT
#[ "$PATTERN" ] && CMD+=" -iname \"$PATTERN\""
if [ $SENSITIVE == "TRUE" ]; then
	[ "$PATTERN" ] && CMD+=" -name \"$PATTERN\""
else
	[ "$PATTERN" ] && CMD+=" -iname \"$PATTERN\""
fi	
[ "$SIZE" ] && CMD+=" -size +$SIZE"
[ "$DAYS" ] && CMD+=" -mtime -$DAYS"
CMD+=" -exec ls -ltrkh {} +"

#> TESTING: Checking Command to Execute
echo "[INFO]: CMD-> $CMD"

# Evaluate command safely
#RESULT=$(eval "$CMD" 2>/dev/null)

RESULT_FILE="tmp.txt"
(
echo "Searching.."; sleep 5
RESULT=$(eval "$CMD" >$RESULT_FILE 2>/dev/null)
)| yad --center -center --undecorated 	--text="[MKM]: Searching Files\n$LINE" --progress  --pulsate --auto-close  --no-buttons --height=150 \
--image="$(pwd)/icons/humming-bird_5.png" \
--window-icon="$(pwd)/icons/humming-bird_16.png"

#printf "RESULT:\n$(cat $RESULT_FILE) \n"



#RESULT=$(find "$DIR" $TYPE_OPT -iname "$PATTERN" 2>/dev/null)

# Show results
#yad --center --undecorated  --text-info --title="[MKM]: Search Results" --width=$WIDTH --height=400 --text="[MKM]: Search Result \n$LINE" --image="$(pwd)/icons/humming-bird_5.png" --window-icon="$(pwd)/icons/humming-bird_16.png" --filename=<(cat "$RESULT_FILE")

###################################################################################
#!/bin/bash

WIDTH=700
HEIGHT=400

# Read files from RESULT_FILE
FILE_LIST=$(cat "$RESULT_FILE")

#echo "********** Search Result ***********"
#cat $RESULT_FILE

####################################################################################################
# Below Code to Display Search Result in Tabular view and handle view & delete option on file      #
####################################################################################################
# user-trash-symbolic
#gtk-delete

yad_cmd='yad --center --undecorated --text="[MKM]: Search Result\n$LINE"  --height=500 --list --button="Delete!user-trash-symbolic:2" --button="View!document-preview:0" --button="Locate!folder-symbolic:4"  --image="$(pwd)/icons/humming-bird_5.png" --window-icon="$(pwd)/icons/humming-bird_16.png" --column="SIZE" --column="DATE & TIME" --column="File Path"'
content=""
#While loop which will read file content line by line and pick on only Columns i.e: File size | Date & Time | File Path
while IFS= read -r line
do	#-rwxrwxr-x 1 mkm mkm 4.1K Oct 22 15:02 /home/mkm/Documents/yad_tutorial/user_session_manager.sh
	size=$(echo "$line" | awk '{ print "\"" $5 "\"" }')
	date_time=$(echo "$line" | awk '{ print "\"" $6 $7 "-" $8 "\"" }')
	name=$(echo "$line" | awk '{ print "\"" $9 "\"" }')
	row=$(printf "$size  $date_time  $name ")
	echo $row
	content+=$row
done < "$RESULT_FILE"
CMD="$yad_cmd $content"

#echo "YAD LIST CMD: $CMD" 
#> TESTING: print fulll yad command with all record data
#echo "YAD PRE: $yad_cmd"
#echo "File: $content"
#echo "CMD: $CMD"
 
	
SELECTED_ROW=$(eval "$CMD")
RETURN_CODE=$(echo $?)
echo "YAD LIST RETURN CODE:$RETURN_CODE"
echo "SELECTED RECORD: $SELECTED_ROW"

#Cleanup
echo "[INFO]: Cleanup!"
rm -rfv $RESULT_FILE

#> Now Handling code when user click on Delete, View & Locate button. but before check whether user have selected any record or not
#> First chcking whether user selected any record or not
if [ ! -z $SELECTED_ROW ]; then  
	echo "[INFO]: Selected Record is: $SELECTED_ROW"
	#> Check for which operation user selected and handle acordingly
	file_path=$(echo $SELECTED_ROW| cut -d'|' -f3)			
	case $RETURN_CODE in
		0)
			echo "[INFO]: Viewing the Record Selected!"
			echo -e "SELECTED RECORD IS: \t\t"$SELECTED_ROW
			yad --center --undecorated --text="[MKM]: Content of File: $file_path\n$LINE"  --height=500 \
			--text-info --filename="$file_path"\
			--image="$(pwd)/icons/humming-bird_5.png" \
			--window-icon="$(pwd)/icons/humming-bird_16.png" \
			--button="Close!gtk-close:0"
			
			;;
		2)
			echo "[INFO]: Deleting the Record Selected!"
			yad --center --undecorated --question --text="[MKM]: Are you sure to delete File($file_path) ?\n$LINE"  --height=250  --image="$(pwd)/icons/humming-bird_5.png" --window-icon="$(pwd)/icons/humming-bird_16.png" --button="Cancel!gtk-cancel:1" --button="Yes!gtk-yes:0" 
			if [ $? -eq 0 ]; then
				echo "[INFO]: Deleting file: $file_path"
				rm -rfv $file_path
				yad --center --undecorated --info --text="[MKM]: Successfully deleted File($file_path) ! \n$LINE"  --height=250  --image="$(pwd)/icons/humming-bird_5.png" --window-icon="$(pwd)/icons/humming-bird_16.png" --button="Ok!gtk-ok:0" 
			else
				echo "[INFO]: User cancel the Deleting record!"
			fi				
			;;
		4)
			echo "[INFO]: Locating the Selected File: $file_path !"
			xdg-open $(dirname $file_path)
			;;
		esac
		
else
	echo "[INFO]: No Record is Selected!"
fi



#######################################################################################
#exit
####################################################################################
#Cleanup
rm -rfv $RESULT_FILE
