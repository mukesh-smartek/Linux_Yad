LINE_LENGTH=120
LINE=$(printf "%-${LINE_LENGTH}s" "-" | tr ' ' '-')



#Function to invoked gui of information
function yad_information(){
	echo "Message:$*"
	yad --info --center  --undecorated --text="<span size='x-large' weight='bold' foreground='#2EC96D' >[MKM] Information  \n$LINE  </span> \n\n\n\n <b>$*</b>" --width=600 --height=250 \
		--image="$(pwd)/icons/humming-bird_5.png"  \
		--window-icon="$(pwd)/icons/humming-bird_16.png" \
		--button="OK!gtk-ok:0"
}

yad_information $*
