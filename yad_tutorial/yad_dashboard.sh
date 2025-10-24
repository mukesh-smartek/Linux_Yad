#!/bin/bash
#############################################################################################
#	●THIS SCIPT WILL POPUP SHIMPLE UNDECORATED GUI WITH AUTO CLOSE TIMER
#	●THERE WILL BE FOLLOWING BUTTON:
#		◉LOGOUT	:
#		◉SWITCH USER	:
#		◉SHUTDOWN	: Fully Implemented, But need to call script in cli mode
#		◉RESTART	:
#		◉CLOSE		: Fully Implemented
#		◉DARK THEME	: Fully Implemented
#		◉LIGHT THEME	: Fully Implemented
#		◉FIND		: Implementation of full find Command
#		◉GREP		:
#		◉N/W & SERVICE	:
#		
##############################################################################################

#> TO CREATE DESKTOP LAUNCHER FOLLOWING ENTRY IS REQUIRED
# [Desktop Entry]
# Version=1.0
# Type=Application
# Name=Yad Session Manager
# Comment=Launch session.sh script
# Exec=/home/mkm/Documents/yad_tutorial/user_session_manager.sh
# #Icon=utilities-terminal
# Icon=/home/mkm/Documents/yad_tutorial/icons/humming-bird_16.png
# Terminal=false
# Categories=Utility;



#GLOBAL VARIABLES
WIDTH=700
LINE_LENGTH=120
LINE=$(printf "%-${LINE_LENGTH}s" "-" | tr ' ' '-')



SPAN_OPEN="<span size='x-large' weight='bold' foreground='#2EC96D' >"
SPAN_CLOSE="</span>"
#LOGIN PAGE

function login(){
	# A YAD-based login GUI with validation

	# Define credentials
	VALID_USER="admin"
	VALID_PASS="admin@123"

	# Show login dialog using yad
	LOGIN_INFO=$(yad  --center  --undecorated --text="<span size='x-large' weight='bold' foreground='#2EC96D' >[MKM] Login Here  $LINE </span>\n <b>Please enter your credentials</b>" --width=300 --height=250 \
	    --form \
	    --image="$(pwd)/icons/humming-bird_5.png"  \
	    --window-icon="$(pwd)/icons/humming-bird_16.png" \
	    --field="                                               👤 Username" \
	    --field="                                               🔑 Password:H" \
	    --field=":LBL" \
	    --field=":LBL" \
	    --button="Login!gtk-ok:0" \
	    --button="Cancel!gtk-cancel:1")

	# Check if user pressed Cancel or closed window
	if [ $? -ne 0 ]; then
	    ./yad_information.sh "Login cancelled by user."
	    exit 1
	fi

	# Extract username and password from the yad output
	USERNAME=$(echo "$LOGIN_INFO" | cut -d'|' -f1)
	PASSWORD=$(echo "$LOGIN_INFO" | cut -d'|' -f2)

	# Validate user input
	if [[ "$USERNAME" == "$VALID_USER" && "$PASSWORD" == "$VALID_PASS" ]]; then
	    ./yad_information.sh "✅ Welcome, $USERNAME! 🎉"
	else
	    ./yad_information.sh "❌ Error, Invalid username or password!"
	fi

}

#Dashboard View
function show_dashboard(){
	yad --title="[MKM] Dashboard" --center  --undecorated --text="<span size='x-large' weight='bold' foreground='#2EC96D' >[MKM] Dashboard </span> \n <b>System and Application Tools at Single Place</b> \n $SPAN_OPEN $LINE $SPAN_CLOSE" --width=600 --height=500 \
		--image="$(pwd)/icons/humming-bird_5.png"  \
		--window-icon="$(pwd)/icons/humming-bird_16.png" \
		--notebook \
			--tab="User Session" \
				--form --columns=3 \
					--field="Logout       !$(pwd)/icons/logout_10.png:BTN" 'bash -c "echo logout"' \
					--field="Switchuser   !$(pwd)/icons/switchuser_10.png:BTN" 'bash -c "echo switchuser"' \
					--field="Shutdown     !$(pwd)/icons/shutdown_10.png:BTN" 'bash -c "sudo shutdown now"' \
					--field="H/W Details  !$(pwd)/icons/os_10.png:BTN" 'bash -c "./yad_information.sh \"H/W Details code Will be Implemented using dmidecome\" "' \
			--tab="Utility"\
				--form --columns=3 \
					--field="Find         !$(pwd)/icons/find_10.png:BTN" 'bash -c "./find_utility_v1.8.sh"' \
					--field="Grep         !$(pwd)/icons/content_search_10.png:BTN" 'bash -c "./yad_information.sh \" Grep Utility is Under Development!\" "' \
					--field="Terminal     !$(pwd)/icons/terminal_10.png:BTN" 'bash -c "echo \"Invoking Terminal\"; gnome-terminal --working-directory=~/"' \
					--field="File Explorer!$(pwd)/icons/folder_10.png:BTN" 'bash -c "xdg-open ~/"' \
					--field="Firefox      !$(pwd)/icons/firefox_10.png:BTN" 'bash -c "firefox"' \
			--tab="Services"\
				--form --columns=3 \
					--field="Close     !$(pwd)/icons/cancel_10.png:BTN" 'bash -c " kill $YAD_PID"' \
		--button="Close!gtk-close:0" \
		--timeout=900 --timeout-indicator=top
		
		
	#--field="Close:BTN" 'bash -c "echo button pressed"' \	
	RETURN_CODE=$?
	echo "RETURN CODE:  $RETURN_CODE"
}

cd /home/mkm/Documents/yad_tutorial/

login

show_dashboard
