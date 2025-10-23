#!/bin/bash

WIDTH=700
LINE_LENGTH=180
LINE=$(printf "%-${LINE_LENGTH}s" "-" | tr ' ' '-')

#> DEFINATION: Find Form Dialog
function find_input_form(){
	INPUT=$(yad --center --undecorated --form  \
	--text="[MKM]: Find Files\n$LINE"   \
	--field="Directory to Search:DIR" "/" \
	--field="File Pattern" "*filename*type"  \
	--field="Select Type:CB" "File!Directory!Link" \
	--field="Minimum size (e.g., 1k, 10M)" "" \
	--field="Modified within (days)" "" \
	--image="$(pwd)/icons/humming-bird_5.png" \
	--window-icon="$(pwd)/icons/humming-bird_16.png")
	
	echo $INPUT
}

#> CALLING: Find Form Dialog
INPUT=$(find_input_form)
#> Parsing input
DIR=$(echo "$INPUT" | cut -d'|' -f1)
PATTERN=$(echo "$INPUT" | cut -d'|' -f2)
TYPE=$(echo "$INPUT" | cut -d'|' -f3)
SIZE=$(echo "$INPUT" | cut -d'|' -f4)
DAYS=$(echo "$INPUT" | cut -d'|' -f5)

#> TESTING: Printing User Inputs
#printf "ALL INPUTS: $INPUT \n"
#printf "DIR: $DIR\n"
#printf "PATTERN: $PATTERN\n"
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
[ "$PATTERN" ] && CMD+=" -iname \"$PATTERN\""
[ "$SIZE" ] && CMD+=" -size +$SIZE"
[ "$DAYS" ] && CMD+=" -mtime -$DAYS"

#> TESTING: Checking Command to Execute
echo "[INFO]: CMD-> $CMD"

# Evaluate command safely
RESULT=$(eval $CMD 2>/dev/null)



#RESULT=$(find "$DIR" $TYPE_OPT -iname "$PATTERN" 2>/dev/null)

# Show results
yad --center --undecorated  --text-info --title="[MKM]: Search Results" --width=$WIDTH --height=400 --text="[MKM]: Search Result \n$LINE" --image="$(pwd)/icons/humming-bird_5.png" --window-icon="$(pwd)/icons/humming-bird_16.png" --filename=<(echo "$RESULT")
