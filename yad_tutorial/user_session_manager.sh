#!/bin/bash
##############################################################################################
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



#> EXAMPLE: Basic yad command to Show Custom button without Title Bar and Time to Auto Close the application
#yad --center --undecorated --timeout=3 --timeout-indicator=POS--button="Logout:gnome-session-quit --logout --no-prompt" --button="Switch User:1" ;echo $?
cd ~/Documents/yad_tutorial/

#> Function show dialog without again appear
function user_session_manager(){
yad --center --undecorated --timeout=20 --timeout-indicator=top --text="[MKM]: User Session Management" \
--button="Logout!$(pwd)/icons/logout_10.png:0" \
--button="Switch User!$(pwd)/icons/switchuser_10.png:1"  \
--button="Shutdown!$(pwd)/icons/shutdown_10.png:2" \
--button="Restart!$(pwd)/icons/restart_10.png:3"  \
--button="Close!$(pwd)/icons/cancel_10.png:4"  \
--button="Dark Theme!$(pwd)/icons/theme_dark_10.png:5" \
--button="Light Theme!$(pwd)/icons/theme_light_10.png:6"  \
--image="$(pwd)/icons/humming-bird_5.png"  --window-icon="$(pwd)/icons/humming-bird_16.png"

	case $? in
	0)
		printf "Code to Implement Logout!"
		;;
	1)
		printf "Code to Implement Switch User!"
		;;
	2)
		printf "[INFO]: System going to Shutdown!"
		sleep 0.5
		sudo shutdown now
		;;
	3)
		printf "Code to Implemet Restart!"
		##reboot
		;;
	4)
		printf "Cancel the Operation!"
		;;
	5)
		printf "[INFO]: Changing Theme to Dark Mode!\n"	
		sed -i 's/\bfalse\b/true/g' ~/.config/gtk-3.0/settings.ini
		;;
	6)
		printf "[INFO]: Changing Theme to Light Mode!\n"	
		sed -i 's/\btrue\b/false/g' ~/.config/gtk-3.0/settings.ini
		;;
	70)
		printf "Input Session time out!"
		;;
	*)
		printf "Nothing to do!"
		;;
	esac
}

#> Function show dialog with again appear
function user_session_manager_2(){
yad --center --undecorated --timeout=900 --timeout-indicator=top --text="[MKM]: User Session Management"  \
--button="L!$(pwd)/icons/logout_10.png:0" \
--button="S!$(pwd)/icons/switchuser_10.png:1"  \
--button="S!$(pwd)/icons/shutdown_10.png:2" \
--button="R!$(pwd)/icons/restart_10.png:3" \
--button="F!$(pwd)/icons/find_10.png:4"  \
--button="G!$(pwd)/icons/content_search_10.png:5"  \
--button="N!$(pwd)/icons/networking_10.png:9" \
--button="C!$(pwd)/icons/cancel_10.png:6"  \
--button="D!$(pwd)/icons/theme_dark_10.png:7" \
--button="L!$(pwd)/icons/theme_light_10.png:8"  \
--image="$(pwd)/icons/humming-bird_5.png"  \
--window-icon="$(pwd)/icons/humming-bird_16.png"

	case $? in
	0)
		printf "Code to Implement Logout! \n"
		;;
	1)
		printf "Code to Implement Switch User! \n"
		;;
	2)
		printf "[INFO]: System going to Shutdown! \n"
		sleep 0.5
		sudo shutdown now
		;;
	3)
		printf "Code to Implemet Restart! \n"
		;;
	4)
		printf "[INFO]: Find Application Launching! \n"
		./find_utility_v1.8.sh
		user_session_manager_2
		;;
	5)
		printf "[INOF]: Content Search in File! \n"
		;;
	6)	printf "Application Closed!\n" ;;
	7)
		printf "[INFO]: Changing Theme to Dark  Mode!\n"	
		sed -i 's/\bfalse\b/true/g' ~/.config/gtk-3.0/settings.ini
		user_session_manager_2
		;;
	8)
		printf "[INFO]: Changing Theme to Light Mode!\n"	
		sed -i 's/\btrue\b/false/g' ~/.config/gtk-3.0/settings.ini
		user_session_manager_2
		;;
	9)
		printf "[INFO]: Launching Network & Services GUI! \n[WARNING]: Wait After Entering Password! \n"
		sudo ./network_and_services_info.sh
		user_session_manager_2
		;;
	70)
		printf "Input Session time out! \n"
		;;
	*)
		printf "Nothing to do! \n"
		;;
	esac
}

#> DEFINATION: Main Method
function main_method(){
	user_session_manager_2
}


#> CALLING: Main Method
main_method







