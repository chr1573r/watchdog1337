#!/bin/bash

# Variables
APPVERSION="1.0"
# Pretty colors for the terminal:
DEF="\x1b[0m"
GRAY="\e[0;37m"
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

##################
# FUNCTIONS BEGIN:

gfx () # Used to display repeating "graphics" where needed
{
	case "$1" in
		
		splash)
			clear
			echo
			echo
			echo
			echo          
			echo
			echo
			echo
			echo
			echo -e ""$LIGHTGREEN"    _       _____  ______________  ______  ____  ______"$GRAY"    __________________"$DEF""
			echo -e ""$LIGHTGREEN"   | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$GRAY"  <  /__  /__  /__  /"$DEF""
			echo -e ""$LIGHTGREEN"   | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$GRAY"   / / /_ < /_ <  / /"$DEF""
			echo -e ""$LIGHTGREEN"   | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$GRAY"  / /___/ /__/ / / /"$DEF""
			echo -e ""$LIGHTGREEN"   |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$GRAY" /_//____/____/ /_/ "$YELLOW"(A!)"$DEF""
			echo
			echo -e "     "$LIGHTGREEN"WATCHDOG "$GRAY"1337 "$YELLOW"(ALERTS!) "$GRAY"Version $APPVERSION - "$RED"Cj Designs"$GRAY"/"$YELLOW"CSDNSERVER.COM"$GRAY" - 2012"
			sleep 2
			clear
			
			;;

		green)
			clear
			echo -e ""$GREEN"    _       _____  ______________  ______  ____  ______"$GRAY"    __________________"$DEF""
			echo -e ""$GREEN"   | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$GRAY"  <  /__  /__  /__  /"$DEF""
			echo -e ""$GREEN"   | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$GRAY"   / / /_ < /_ <  / /"$DEF""
			echo -e ""$GREEN"   | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$GRAY"  / /___/ /__/ / / /"$DEF""
			echo -e ""$GREEN"   |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$GRAY" /_//____/____/ /_/ "$GREEN"(A!)"$DEF""
			echo
			echo
			echo
			echo
			echo
			echo
			echo
			echo
			echo -e "               "$LIGHTGREEN"All systems operational! "$GRAY"$HOSTS"$LIGHTGREEN" of "$GRAY"$HOSTS "$LIGHTGREEN"hosts are up!"$DEF""
			echo
			echo
			echo
			tput sc
			COUNTDOWN=$REFRESHRATE
			until [ $COUNTDOWN == 0 ]; do
				echo -e ""$GRAY"                   Automatic check launching in $COUNTDOWN"$DEF" second(s)."$DEF""
				echo
				echo
				VALGET=NOPE
				read -t 1 -n 1 -s -p "          Press [w] to wait 3 minutes, [p] to pause, or [x] to exit" VALGET
					if [ "$VALGET" == "w" ]; then sleepin=YES ; gfx yellow; COUNTDOWN=1; fi
					if [ "$VALGET" == "p" ]; then sleepin=NO; gfx yellow; COUNTDOWN=1; fi
					if [ "$VALGET" == "x" ]; then exit ; fi
				COUNTDOWN=$(( COUNTDOWN - 1 ))
				tput rc
				tput el
			done
			;;
		yellow)
			clear
			echo -e ""$YELLOW"    _       _____  ______________  ______  ____  ______"$GRAY"    __________________"$DEF""
			echo -e ""$YELLOW"   | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$GRAY"  <  /__  /__  /__  /"$DEF""
			echo -e ""$YELLOW"   | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$GRAY"   / / /_ < /_ <  / /"$DEF""
			echo -e ""$YELLOW"   | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$GRAY"  / /___/ /__/ / / /"$DEF""
			echo -e ""$YELLOW"   |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$GRAY" /_//____/____/ /_/ "$YELLOW"(A!)"$DEF""
			echo
			echo
			echo
			echo
			echo
			echo
			echo
			echo
			echo -e "                   Watchdog 1337 (Alerts!) is currently suspended."
			if [ "$SLEEPIN" == "NO" ]; then
				read -n 1 -s -p "            Press any key to continue, or hold [Ctrl-C] to exit" VALGET
			else
				tput sc
				SLEEPTIME=180
				until [ "$SLEEPTIME" == "0" ]; do
					echo -e "            "$GRAY"Will resume in "$LIGHTYELLOW"$SLEEPTIME"$DEF" "$GRAY"second(s).    (Press [CTRL+C] to exit..)"$DEF""
					sleep 1
					SLEEPTIME=$(( SLEEPTIME - 1 ))
					tput rc
					tput el
				done
			fi
			;;

		red)
			clear
			echo -e ""$LIGHTRED"    _       _____  ______________  ______  ____  ______"$GRAY"    __________________"$DEF""
			echo -e ""$LIGHTRED"   | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$GRAY"  <  /__  /__  /__  /"$DEF""
			echo -e ""$LIGHTRED"   | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$GRAY"   / / /_ < /_ <  / /"$DEF""
			echo -e ""$LIGHTRED"   | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$GRAY"  / /___/ /__/ / / /"$DEF""
			echo -e ""$LIGHTRED"   |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$GRAY" /_//____/____/ /_/ "$LIGHTRED"(A!)"$DEF""
			echo
			echo
			echo
			echo
			echo
			echo
			echo
			echo
			echo -e "                       "$DEF""$LIGHTRED"WARNING!"$WHITE" $HOSTSDOWN "$DEF""$GRAY"of "$LIGHTRED""$WHITE"$HOSTS"$DEF""$GRAY" hosts are "$LIGHTRED"DOWN!"$DEF""
			echo
			echo
			echo
			echo
			echo "WARNING, $HOSTSDOWN of $HOSTS hosts are down!" > message
			festival --tts message
			tput sc
			COUNTDOWN=$REFRESHRATE
			until [ $COUNTDOWN == 0 ]; do
				echo -e ""$GRAY"                   Automatic check launching in $COUNTDOWN"$DEF" second(s)."$DEF""
				echo
				echo
				VALGET=NOPE
				read -t 1 -n 1 -s -p "          Press [w] to wait 3 minutes, [p] to pause, or [x] to exit" VALGET
					if [ "$VALGET" == "w" ]; then sleepin=YES ; gfx yellow; COUNTDOWN=1; fi
					if [ "$VALGET" == "p" ]; then sleepin=NO; gfx yellow; COUNTDOWN=1; fi
					if [ "$VALGET" == "x" ]; then exit ; fi
				COUNTDOWN=$(( COUNTDOWN - 1 ))
				tput rc
				tput el
			done
			;;

		alert)
			COUNTER=2
			until [ $COUNTER == 0 ]; do

				tput clear
				echo
				echo
				echo
				echo
				echo
				echo
				echo
				echo
				echo -e ""$WHITE".########..########.########........###....##.......########.########..########"
				echo -e ""$WHITE".##.....##.##.......##.....##......##.##...##.......##.......##.....##....##..."
				echo -e ""$WHITE".##.....##.##.......##.....##.....##...##..##.......##.......##.....##....##..."
				echo -e ""$WHITE".########..######...##.....##....##.....##.##.......######...########.....##..."
				echo -e ""$WHITE".##...##...##.......##.....##....#########.##.......##.......##...##......##..."
				echo -e ""$WHITE".##....##..##.......##.....##....##.....##.##.......##.......##....##.....##..."
				echo -e ""$WHITE".##.....##.########.########.....##.....##.########.########.##.....##....##..."
				sleep 0.1
				tput clear
				echo
				echo
				echo
				echo
				echo
				echo
				echo
				echo
				echo -e ""$LIGHTRED".########..########.########........###....##.......########.########..########"
				echo -e ""$LIGHTRED".##.....##.##.......##.....##......##.##...##.......##.......##.....##....##..."
				echo -e ""$LIGHTRED".##.....##.##.......##.....##.....##...##..##.......##.......##.....##....##..."
				echo -e ""$LIGHTRED".########..######...##.....##....##.....##.##.......######...########.....##..."
				echo -e ""$LIGHTRED".##...##...##.......##.....##....#########.##.......##.......##...##......##..."
				echo -e ""$LIGHTRED".##....##..##.......##.....##....##.....##.##.......##.......##....##.....##..."
				echo -e ""$LIGHTRED".##.....##.########.########.....##.....##.########.########.##.....##....##..."
				mplayer klax1.wav -af volume=-15 &> /dev/null

				tput clear
				echo
				echo
				echo
				echo
				echo
				echo
				echo
				echo
				echo -e ""$WHITE".########..########.########........###....##.......########.########..########"
				echo -e ""$WHITE".##.....##.##.......##.....##......##.##...##.......##.......##.....##....##..."
				echo -e ""$WHITE".##.....##.##.......##.....##.....##...##..##.......##.......##.....##....##..."
				echo -e ""$WHITE".########..######...##.....##....##.....##.##.......######...########.....##..."
				echo -e ""$WHITE".##...##...##.......##.....##....#########.##.......##.......##...##......##..."
				echo -e ""$WHITE".##....##..##.......##.....##....##.....##.##.......##.......##....##.....##..."
				echo -e ""$WHITE".##.....##.########.########.....##.....##.########.########.##.....##....##..."
				sleep 0.1
				tput clear
				echo
				echo
				echo
				echo
				echo
				echo
				echo
				echo
				echo -e ""$LIGHTRED".########..########.########........###....##.......########.########..########"
				echo -e ""$LIGHTRED".##.....##.##.......##.....##......##.##...##.......##.......##.....##....##..."
				echo -e ""$LIGHTRED".##.....##.##.......##.....##.....##...##..##.......##.......##.....##....##..."
				echo -e ""$LIGHTRED".########..######...##.....##....##.....##.##.......######...########.....##..."
				echo -e ""$LIGHTRED".##...##...##.......##.....##....#########.##.......##.......##...##......##..."
				echo -e ""$LIGHTRED".##....##..##.......##.....##....##.....##.##.......##.......##....##.....##..."
				echo -e ""$LIGHTRED".##.....##.########.########.....##.....##.########.########.##.....##....##..."
				COUNTER=$(( COUNTER - 1 ))
				mplayer klax1.wav -af volume=-15 &> /dev/null
			done
			;;
	esac
}

timeupdate() # Sets current time into different variables. Used for timestamping etc.
{
	DATE=$(date +"%d-%m-%Y")
	NOWSTAMP=$(date +"%Hh%Mm%Ss")
	HM=$(date +"%R")
	HMS=$(date +"%R:%S")
	HOUR=$(date +"%H")
	MINUTE=$(date +"%M")
	SEC=$(date +"%S")
}

trap "{ reset; clear;echo Watchdog1337 Alerts! $APPVERSION terminated at `date`; exit; }" SIGINT SIGTERM EXIT # Set trap for catching Ctrl-C and kills, so we can reset terminal upon exit

gfx splash

echo Loading configuration.. # Read from settings.cfg, if exists
if [ -f settings.cfg ] ; then
	source settings.cfg
fi

echo Validating configuration... # Check if important variables contain anything. If they are empty, default values will be set.
if [ -z "$REFRESHRATE" ]; then echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"REFRESHRATE not set, changing REFRESHRATE to 5 seconds."$DEF""; REFRESHRATE=5; sleep 2; fi

while true # The script will repeat below until CTRL-C is pressed
	do
		clear
		HOSTSDOWN=`cat export.txt | awk -F":" '{print $1}' $2`
		HOSTS=`cat export.txt | awk -F":" '{print $2}' $2`
#		echo $HOSTSDOWN
#		cat hostsdown
#		sleep 20
			if [ $HOSTSDOWN != 0 ]; then
				gfx alert
				gfx red
			else
				gfx green
			fi
	done
