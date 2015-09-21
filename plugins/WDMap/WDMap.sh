#!/bin/bash
# WDMap - Watchdog 1337 Map plugin
# Plugin for Watchdog 1337 that enables host statuses on a ascii map
# Written by Christer Jonassen
# Licensed under CC BY-NC-SA 3.0 (check LICENCE file or http://creativecommons.org/licenses/by-nc-sa/3.0/ for details.)
# Made possible by the wise *nix people sharing their knowledge and work online

# Variables
APPVERSION="0.1"
# Pretty colors for the terminal:
DEF="\x1b[0m"
GRAY="\x1b[37;0m"
LIGHTBLACK="\x1b[30;01m"
BLACK="\x1b[30;11m"
LIGHTBLUE="\x1b[34;01m"
BLUE="\x1b[34;11m"
LIGHTCYAN="\x1b[36;01m"
CYAN="\x1b[36;11m"
LIGHTGRAY="\x1b[37;01m"
WHITE="\x1b[37;11m"
LIGHTGREEN="\x1b[32;01m"
GREEN="\x1b[32;11m"
LIGHTPURPLE="\x1b[35;01m"
PURPLE="\x1b[35;11m"
LIGHTRED="\x1b[31;01m"
RED="\x1b[31;11m"
LIGHTYELLOW="\x1b[33;01m"
YELLOW="\x1b[33;11m"

#gray CLR_BG="\x1b[30;01m"
CLR_BG="\x1b[0m"
CLR_UP="\x1b[32;01m"
CLR_LAT="\x1b[33;01m"
CLR_DOWN="\x1b[31;01m"

PREVIOUSCOLUMNS=$(tput cols)
PREVIOUSLINES=$(tput lines)

##################
# FUNCTIONS BEGIN:


gfx () # Used to display repeating "graphics" where needed
{
	case "$1" in
		
		splash) # Used on startup.
			clear
			echo
			echo
			echo
			echo
			echo
			echo
			echo	
			echo -e ""$LIGHTPURPLE"    _       _____  ______________  ______  ____  ______"$GRAY"    __________________"$DEF""
			echo -e ""$LIGHTPURPLE"   | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$GRAY"  <  /__  /__  /__  /"$DEF""
			echo -e ""$LIGHTPURPLE"   | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$GRAY"   / / /_ < /_ <  / /"$DEF""
			echo -e ""$LIGHTPURPLE"   | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$GRAY"  / /___/ /__/ / / /"$DEF""
			echo -e ""$LIGHTPURPLE"   |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$GRAY" /_//____/____/ /_/ "$LIGHTPURPLE"MAP"$DEF""
			echo
			echo -e "                     "$GRAY"WATCHDOG 1337 "$LIGHTPURPLE"MAP"$GRAY" plugin - Version $APPVERSION"
			echo
			echo
			echo
			echo
			echo
			echo
			echo
			echo -e "                        "$LIGHTPURPLE"Cj Designs"$GRAY"/"$LIGHTPURPLE"CSDNSERVER.COM"$GRAY" - 2015"
			sleep 2
			clear
			
			;;
	esac
}

ut()
{
	echo -e "$1"$DEF""
}

utm()
{
	echo -e $1 | eval sed $pattern
}

termreset()
{
		echo Terminal size changed, resetting...
		PREVIOUSCOLUMNS=$(tput cols)
		PREVIOUSLINES=$(tput lines)
		PREVIOUSHOSTS=$HOSTS
		REDRAW=YES
		reset
}

termcheck()
{
	CURRENTCOLUMNS=$(tput cols)
	CURRENTLINES=$(tput lines)
	if [ "$PREVIOUSCOLUMNS" != "$CURRENTCOLUMNS" ]; then
		termreset
	elif [ "$PREVIOUSLINES" != "$CURRENTLINES" ]; then
		termreset
	fi
}

event_import()
{
	rm plugins/WDMap/hosts-import.lst &> /dev/null
	rm plugins/WDMap/update.ack &> /dev/null
	while read -r HOSTENTRY
		do
			MAPTAG=$(echo $HOSTENTRY | awk -F":" '{print $5}')
			HOSTLAT=$(echo $HOSTENTRY | awk -F":" '{print $1}')
			if ! [[ "$HOSTLAT" == "none" ]]; then
				HOSTLAT=$(echo $HOSTENTRY | awk -F"." '{print $1}')
			fi
			echo $MAPTAG:$HOSTLAT >> plugins/WDMap/hosts-import.lst
		done < plugins/WDMap/export.txt
	rm plugins/WDMap/export.txt
}

hostread()
{
	HOSTS=0
	HOSTSDOWN=0
	while read -r HOSTENTRY
	do
			MAPTAG=$(echo $HOSTENTRY | awk -F":" '{print $1}')
			HOSTLAT=$(echo $HOSTENTRY | awk -F":" '{print $2}')
			if ! [[ "$HOSTLAT" == "none" ]]; then
				if [[ $HOSTLAT -gt 20 ]]; then
					HIGHLIGHT=$CLR_LAT
				else
					HIGHLIGHT=$CLR_UP
				fi
			else
				HIGHLIGHT=$CLR_DOWN
				((HOSTSDOWN++))
			fi
			# add monsterous expression switches
			pattern="$pattern -e 's:$MAPTAG:$HIGHLIGHT&$CLR_BG:g'"
			((HOSTS++))

	done < hosts-import.lst
}





display_map(){
	tput cup 0 0
	tput el
	OLD_IFS="$IFS"
	IFS=
	echo -e ""$LIGHTPURPLE"    _       _____  ______________  ______  ____  ______"$GRAY"    __________________"$DEF""
	echo -e ""$LIGHTPURPLE"   | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$GRAY"  <  /__  /__  /__  /"$DEF""
	echo -e ""$LIGHTPURPLE"   | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$GRAY"   / / /_ < /_ <  / /"$DEF""
	echo -e ""$LIGHTPURPLE"   | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$GRAY"  / /___/ /__/ / / /"$DEF""
	echo -e ""$LIGHTPURPLE"   |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$GRAY" /_//____/____/ /_/ "$LIGHTPURPLE"MAP"$DEF""
	echo
	ut ""$LIGHTPURPLE"Watchdog1337"$GRAY">"$LIGHTPURPLE"Map"$GRAY" // Last refresh @ $(date)"
	echo
	while read -r MAPLINE
		do
			utm ""$CLR_BG"$MAPLINE"
	done <map.txt

	IFS="$OLD_IFS"
	touch update.ack
}

preflight_tests()
{
	#check 1
	echo Preflight-check 1/2
	echo Loading configuration.. # Read from settings.cfg, if exists
	if [ -f settings.cfg ]; then source settings.cfg; else echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"settings.cfg not found "$DEF""; fi
	if [ -z "$WDMAP" ]; then echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"WDMAP not set, changing WDMAP to map.txt."$DEF""; WDMAP=map.txt; sleep 2; fi
	if [ -z "$WDTAGFIELD" ]; then echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"WDTAGFIELD not set, changing WDTAGFIELD to "5"."$DEF""; WDTAGFIELD=5; sleep 2; fi

	#check 2
	echo Preflight-check 2/2
	mapsize_test

	#check 3
	clear
}

mapsize_test()
{
	WDMAPHEIGHT=$(wc -l < $WDMAP)
	WDMAPWIDTH=$(awk ' { if ( length > L ) { L=length} }END{ print L}' $WDMAP)
	if [ "$WDMAPHEIGHT" -lt 25 ]; then WDTERMHEIGHTREQ=25; else WDTERMHEIGHTREQ=$((( WDMAPHEIGHT + 11 ))); fi
	if [ "$WDMAPWIDTH" -lt 80 ]; then WDTERMWIDTHREQ=80; else WDTERMWIDTHREQ=$WDMAPWIDTH; fi
	termcheck

	while [ "$CURRENTLINES" -lt "$WDTERMHEIGHTREQ" ] || [ "$CURRENTCOLUMNS" -lt "$WDTERMWIDTHREQ" ] ; do
		clear
		echo -e ""$YELLOW"WD1337 Map plugin temporarily suspended! "$GRAY""
		echo
		echo -e "WDMap needs a terminal size of "$CYAN"$WDTERMWIDTHREQ"$GRAY" by "$CYAN"$WDTERMHEIGHTREQ"$GRAY" to proceed"
		echo -e "(currently $CURRENTCOLUMNS x $CURRENTLINES)"$DEF""
		echo
		read -p "Resize terminal, and press any key re-check (or press Ctrl-C to abort)"
		termcheck		
	done
}

event_update_wait()
{
	COUNTER=0
	echo
	tput el
	if [[ $HOSTSDOWN -gt 0 ]]; then
		ut ""$GRAY"///"$LIGHTPURPLE" SUMMARY @ $(date +"%R:%S"): "$LIGHTGRAY"$HOSTSDOWN"$GRAY" of "$LIGHTGRAY"$HOSTS"$GRAY" hosts are "$LIGHTRED"DOWN"$DEF" "
	else
		ut ""$GRAY"///"$LIGHTPURPLE" SUMMARY @ $(date +"%R:%S"): "$LIGHTGRAY"$HOSTS"$GRAY" of "$LIGHTGRAY"$HOSTS"$GRAY" hosts are "$LIGHTGREEN"UP"$DEF" "
	fi
	while [[ -f update.ack ]]; do
		tput sc
		echo -e -n ""$GRAY"--"$LIGHTPURPLE"> "$GRAY"$COUNTER second(s) since last update.    (Press [CTRL+C] to exit..)"$DEF""
		sleep 1
		tput rc
		tput el
		((COUNTER++))
	done
	tput sc
	tput el
	ut ""$GRAY"--"$LIGHTPURPLE"> Update imminent, please wait..."
	while ! [[ -f hosts-import.lst  ]]; do
		sleep 1
	done
	tput rc
	tput el
	ut ""$GRAY"--"$LIGHTPURPLE"> Processing update..."
}

trap "{ reset; clear;echo Watchdog1337 Map plugin $APPVERSION terminated at $(date); exit; }" SIGINT SIGTERM # Set trap for catching Ctrl-C and kills, so we can reset terminal upon exit


if [ "$1" == "import" ]; then
	event_import
	exit
fi

gfx splash
preflight_tests

while true # The script will repeat below until CTRL-C is pressed
	do
		hostread
		mapsize_test
		display_map
		event_update_wait
	done