#!/bin/bash

WIDTH=700
LINE_LENGTH=180
LINE=$(printf "%-${LINE_LENGTH}s" "-" | tr ' ' '-')

#> DEFINATION: Find Form Dialog
function find_input_form(){
	INPUT=$(yad --center --undecorated --form  \
	--text="[MKM]: Find Files\n$LINE"   \
	--field="Directory to Search:DIR" "Select Dir" \
	--field="File Pattern" "*filename*type"  \
	--field="Select Type:CB" "File ! Directory ! Link" \
	--image="$(pwd)/icons/humming-bird_5.png" \
	--window-icon="$(pwd)/icons/humming-bird_16.png")
	
	printf $INPUT
}

#> CALLING: Find Form Dialog
INPUT=$(find_input_form)
#> Parsing input
DIR=$(echo "$INPUT" | cut -d'|' -f1)
PATTERN=$(echo "$INPUT" | cut -d'|' -f2)
TYPE=$(echo "$INPUT" | cut -d'|' -f3)

#> TESTING: Printing User Inputs
#printf "DIR: $DIR\n"
#printf "PATTERN: $PATTERN\n"
#printf "TYPE:..$TYPE..\n"

#> Run find command
case $TYPE in
    File) TYPE_OPT="-type f" ;;
    Directory) TYPE_OPT="-type d" ;;
    Link) TYPE_OPT="-type l" ;;
esac

#> TESTING: Printing type of file to be search syntax
#echo "TYPE SYNTAX: $TYPE_OPT"

RESULT=$(find "$DIR" $TYPE_OPT -iname "$PATTERN" 2>/dev/null)

# Show results
yad --center --undecorated  --text-info --title="[MKM]: Search Results" --width=$WIDTH --height=400 --text="[MKM]: Search Result \n$LINE" --image="$(pwd)/icons/humming-bird_5.png" --window-icon="$(pwd)/icons/humming-bird_16.png" --filename=<(echo "$RESULT")
