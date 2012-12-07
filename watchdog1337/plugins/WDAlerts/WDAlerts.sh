#!/bin/bash
# WDAlerts - Watchdog 1337 (Alerts!)
# Plugin for Watchdog 1337 that provides visual and audible feedback on host statuses
# Written by Christer Jonassen
# Licensed under CC BY-NC-SA 3.0 (check LICENCE file or http://creativecommons.org/licenses/by-nc-sa/3.0/ for details.)
# Made possible by the wise *nix people sharing their knowledge and work online

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
		
		splash) # Used on startup.
			clear
			echodeluxe
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

		green) # Used if all hosts are available
			clear
			echo -e ""$GREEN"    _       _____  ______________  ______  ____  ______"$GRAY"    __________________"$DEF""
			echo -e ""$GREEN"   | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$GRAY"  <  /__  /__  /__  /"$DEF""
			echo -e ""$GREEN"   | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$GRAY"   / / /_ < /_ <  / /"$DEF""
			echo -e ""$GREEN"   | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$GRAY"  / /___/ /__/ / / /"$DEF""
			echo -e ""$GREEN"   |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$GRAY" /_//____/____/ /_/ "$GREEN"(A!)"$DEF""
			echodeluxe
			echo -e "                 "$LIGHTGREEN"All systems operational! "$GRAY"$HOSTS"$LIGHTGREEN" of "$GRAY"$HOSTS "$LIGHTGREEN"hosts are up!"$DEF""
			echo
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
					if [ "$VALGET" == "w" ]; then SLEEPIN=YES ; gfx yellow; COUNTDOWN=1; fi
					if [ "$VALGET" == "p" ]; then SLEEPIN=NO; gfx yellow; COUNTDOWN=1; fi
					if [ "$VALGET" == "x" ]; then exit ; fi
				COUNTDOWN=$(( COUNTDOWN - 1 ))
				tput rc
				tput el
			done
			;;
		yellow) # Used when wdalerts is on pause.
			clear
			echo -e ""$YELLOW"    _       _____  ______________  ______  ____  ______"$GRAY"    __________________"$DEF""
			echo -e ""$YELLOW"   | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$GRAY"  <  /__  /__  /__  /"$DEF""
			echo -e ""$YELLOW"   | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$GRAY"   / / /_ < /_ <  / /"$DEF""
			echo -e ""$YELLOW"   | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$GRAY"  / /___/ /__/ / / /"$DEF""
			echo -e ""$YELLOW"   |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$GRAY" /_//____/____/ /_/ "$YELLOW"(A!)"$DEF""
			echodeluxe
			echo -e "                 Watchdog 1337 (Alerts!) is currently "$YELLOW"suspended"$DEF"."
			echo
			echo
			echo
			echo
			if [ "$SLEEPIN" == "NO" ]; then
				read -n 1 -s -p "               Press any key to continue, or hold [Ctrl-C] to exit" VALGET
			else
				tput sc
				SLEEPTIME=180
				until [ "$SLEEPTIME" == "0" ]; do
					echo -e "          "$GRAY"Will resume in "$LIGHTYELLOW"$SLEEPTIME"$DEF" "$GRAY"second(s).    (Press [CTRL+C] to exit..)"$DEF""
					sleep 1
					SLEEPTIME=$(( SLEEPTIME - 1 ))
					tput rc
					tput el
				done
			fi
			;;

		red) # Used after "RED ALERT" has been flashed, reports number of offline hosts both visually and audible.
			clear
			echo -e ""$LIGHTRED"    _       _____  ______________  ______  ____  ______"$GRAY"    __________________"$DEF""
			echo -e ""$LIGHTRED"   | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$GRAY"  <  /__  /__  /__  /"$DEF""
			echo -e ""$LIGHTRED"   | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$GRAY"   / / /_ < /_ <  / /"$DEF""
			echo -e ""$LIGHTRED"   | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$GRAY"  / /___/ /__/ / / /"$DEF""
			echo -e ""$LIGHTRED"   |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$GRAY" /_//____/____/ /_/ "$LIGHTRED"(A!)"$DEF""
			echodeluxe
			echo -e "                       "$DEF""$LIGHTRED"WARNING!"$WHITE" $HOSTSDOWN "$DEF""$GRAY"of "$LIGHTRED""$WHITE"$HOSTS"$DEF""$GRAY" hosts are "$LIGHTRED"DOWN!"$DEF""
			echo
			echo
			echo
			echo
			echo "WARNING, $HOSTSDOWN of $HOSTS hosts are down!" > wdamessage # Generate message to be read by the Festival Speech Synthesis System
			festival --tts wdamessage # Read message
			tput sc
			COUNTDOWN=$REFRESHRATE
			until [ $COUNTDOWN == 0 ]; do
				echo -e ""$GRAY"                   Automatic check launching in $COUNTDOWN"$DEF" second(s)."$DEF""
				echo
				echo
				VALGET=NOPE
				read -t 1 -n 1 -s -p "          Press [w] to wait 3 minutes, [p] to pause, or [x] to exit" VALGET
					if [ "$VALGET" == "w" ]; then SLEEPIN=YES ; gfx yellow; COUNTDOWN=1; fi
					if [ "$VALGET" == "p" ]; then SLEEPIN=NO; gfx yellow; COUNTDOWN=1; fi
					if [ "$VALGET" == "x" ]; then exit ; fi
				COUNTDOWN=$(( COUNTDOWN - 1 ))
				tput rc
				tput el
			done
			;;

		alert) # Flash the text "RED ALERT" while playing a file called alarm.mp3 in the current directory
			COUNTER=4
			until [ $COUNTER == 0 ]; do

				tput clear
				echodeluxe
				echo -e ""$WHITE".########..########.########........###....##.......########.########..########"
				echo -e ""$WHITE".##.....##.##.......##.....##......##.##...##.......##.......##.....##....##..."
				echo -e ""$WHITE".##.....##.##.......##.....##.....##...##..##.......##.......##.....##....##..."
				echo -e ""$WHITE".########..######...##.....##....##.....##.##.......######...########.....##..."
				echo -e ""$WHITE".##...##...##.......##.....##....#########.##.......##.......##...##......##..."
				echo -e ""$WHITE".##....##..##.......##.....##....##.....##.##.......##.......##....##.....##..."
				echo -e ""$WHITE".##.....##.########.########.....##.....##.########.########.##.....##....##..."
				sleep 0.1
				tput clear
				echodeluxe
				echo -e ""$LIGHTRED".########..########.########........###....##.......########.########..########"
				echo -e ""$LIGHTRED".##.....##.##.......##.....##......##.##...##.......##.......##.....##....##..."
				echo -e ""$LIGHTRED".##.....##.##.......##.....##.....##...##..##.......##.......##.....##....##..."
				echo -e ""$LIGHTRED".########..######...##.....##....##.....##.##.......######...########.....##..."
				echo -e ""$LIGHTRED".##...##...##.......##.....##....#########.##.......##.......##...##......##..."
				echo -e ""$LIGHTRED".##....##..##.......##.....##....##.....##.##.......##.......##....##.....##..."
				echo -e ""$LIGHTRED".##.....##.########.########.....##.....##.########.########.##.....##....##..."
				mplayer $ALERTSOUND -af volume=-15 &> /dev/null
				COUNTER=$(( COUNTER - 1 ))
			done
			;;
	esac
}

echodeluxe() # Sets current time into different variables. Used for timestamping etc.
{
ECHOLOOP=8
until [ $ECHOLOOP == 0 ]; do
	echo
	ECHOLOOP=$(( ECHOLOOP - 1 ))
done
}
# FUNCTIONS END:
##################


# The actual runscript:

trap "{ reset; clear;echo Watchdog1337 Alerts! $APPVERSION terminated at `date`; exit; }" SIGINT SIGTERM EXIT # Set trap for catching Ctrl-C and kills, so we can reset terminal upon exit

gfx splash 

echo Loading configuration.. # Read from settings.cfg, if exists
if [ -f settings.cfg ] ; then
	source settings.cfg
fi


echo Validating configuration... # Check if important variables contain anything. If they are empty, default values will be set.
if [ -z "$REFRESHRATE" ]; then echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"REFRESHRATE not set, changing REFRESHRATE to 5 seconds."$DEF""; REFRESHRATE=5; sleep 2; fi
if [ -z "$WDEXPORTFILE" ]; then echo -e ""$RED"WATCHDOG ERROR: "$GRAY"WDEXPORTFILE not set, terminating script.."$DEF""; exit; fi
if [ -z "$ALERTSOUND" ]; then echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"ALERTSOUND not set, changing ALERTSOUND to "alert.mp3"."$DEF""; ALERTSOUND=alert.mp3; sleep 2; fi

if [ -f "$WDEXPORTFILE" ] ; then
	echo WDEXPORT file seems fine
else
	echo -e ""$RED"WATCHDOG ERROR: "$GRAY"WDEXPORTFILE "$WDEXPORTFILE" not found, terminating script.."$DEF""
	sleep 2
	exit
fi

if [ -f "$ALERTSOUND" ] ; then
	echo Alertsound seems fine
else
	echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"ALERTSOUND file "$ALERTSOUND" not found, this will cause errors in the script"$DEF""
	sleep 2
fi


while true # The script will repeat below until CTRL-C is pressed
	do
		clear
		HOSTSDOWN=`cat $WDEXPORTFILE | awk -F":" '{print $1}' $2` #Extract hostsdown number from export.txt generated by watchdog1337
		HOSTS=`cat $WDEXPORTFILE | awk -F":" '{print $2}' $2` #Excract total number of hosts from export.txt..

			if [ $HOSTSDOWN != 0 ]; then # If the number of offline hosts are higher than 0, then:
				gfx alert # Display alert and play alert sound
				gfx red # Display hosts down and announce it by speech synthesis
			else # or, if all hosts are up:
				gfx green # Display message telling all hosts are up
			fi
	done
