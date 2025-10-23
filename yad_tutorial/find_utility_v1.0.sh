# Show YAD form to get input

WIDTH=700
LINE_LENGTH=180
LINE=$(printf "%-${LINE_LENGTH}s" "-" | tr ' ' '-')
INPUT=$(yad  --center  --undecorated --text="[MKM]: Find Files\n$LINE"  --form --title="[MKM]: Find Files" \
    --field="Directory to search:DIR" \
    --field="Filename pattern" "Type File Pattern"   --field="File type:CB"   "File! Directory ! Link" \
    --width=$WIDTH \
    --image="$(pwd)/icons/humming-bird_5.png" \
    --window-icon="$(pwd)/icons/humming-bird_16.png")

# Parse input
DIR=$(echo "$INPUT" | cut -d'|' -f1)
PATTERN=$(echo "$INPUT" | cut -d'|' -f2)
TYPE=$(echo "$INPUT" | cut -d'|' -f3)

# Run find command
case $TYPE in
    f) TYPE_OPT="-type f" ;;
    d) TYPE_OPT="-type d" ;;
    l) TYPE_OPT="-type l" ;;
esac

RESULT=$(find "$DIR" $TYPE_OPT -name "$PATTERN" 2>/dev/null)

# Show results
yad --center --undecorated  --text-info --title="[MKM]: Search Results" --width=$WIDTH --height=400 --text="[MKM]: Search Result \n$LINE" --image="$(pwd)/icons/humming-bird_5.png" --window-icon="$(pwd)/icons/humming-bird_16.png" --filename=<(echo "$RESULT")
