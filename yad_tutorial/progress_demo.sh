#!/bin/bash

# Create a dialog with a progress bar
#(
#    echo "10" ; sleep 1
#    echo "20" ; sleep 1
#    echo "30" ; sleep 1
#    echo "40" ; sleep 1
#    echo "50" ; sleep 1
#    echo "60" ; sleep 1
#   echo "70" ; sleep 1
#  echo "80" ; sleep 1
#   echo "90" ; sleep 1
#    echo "100" ; sleep 1
#) | yad --progress --title="Progress Dialog" --text="Processing..." --percentage=0 --auto-close


(
echo "Searching.."; sleep 5
find /home/mkm/Documents/ -type f -iname "*.sh*"> tmp.txt
)| yad --center -center --undecorated 	--text="[MKM]: Find Files\n$LINE" --progress --pulsate --auto-close \
--image="$(pwd)/icons/humming-bird_5.png" \
--window-icon="$(pwd)/icons/humming-bird_16.png"

cat tmp.txt
rm -rf tmp.txt
