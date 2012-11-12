#!/bin/bash
# Watchdog 1337 monitoring script
# Written by Christer Jonassen
# Licensed under CC BY-NC-SA 3.0 (check LICENCE file or http://creativecommons.org/licenses/by-nc-sa/3.0/ for details.)
# Made possible by the wise *nix people sharing their knowledge online
#
# Check README for instructions

# Variables
APPVERSION="1.0 Beta"
REDRAW=YES

# Pretty colors for the terminal:
DEF="\x1b[0m"
WHITE="\e[0;37m"
LIGHTBLACK="\x1b[30;01m"
BLACK="\x1b[30;11m"
LIGHTBLUE="\x1b[34;01m"
BLUE="\x1b[34;11m"
LIGHTCYAN="\x1b[36;01m"
CYAN="\x1b[36;11m"
LIGHTGRAY="\x1b[37;01m"
GRAY="\x1b[37;11m"
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
			echo -e ""$RED"    _       _____  ______________  ______  ____  ______"$YELLOW"    __________________"$DEF""
			echo -e ""$RED"   | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$YELLOW"  <  /__  /__  /__  /"$DEF""
			echo -e ""$LIGHTRED"   | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$LIGHTYELLOW"   / / /_ < /_ <  / /"$DEF""
			echo -e ""$LIGHTRED"   | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$LIGHTYELLOW"  / /___/ /__/ / / /"$DEF""
			echo -e ""$LIGHTRED"   |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$LIGHTYELLOW" /_//____/____/ /_/"$DEF""
			echo
			echo -e "          "$RED"WATCHDOG "$YELLOW"1337 "$GRAY"Version $APPVERSION - "$RED"Cj Designs"$GRAY"/"$YELLOW"CSDNSERVER.COM"$GRAY" - 2012"
			sleep 2
			clear
			
			;;
		
		line)
			echo -e "$RED--------------------------------------------------------------------------------$DEF"
			;;

		header)
			clear
			echo -e ""$RED"  _       _____  ______________  ______  ____  ______"$YELLOW"   __________________"$DEF""
			echo -e ""$RED" | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$YELLOW" <  /__  /__  /__  /"$DEF""
			echo -e ""$RED" | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$YELLOW"  / / /_ < /_ <  / /"$DEF""
			echo -e ""$RED" | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$YELLOW" / /___/ /__/ / / /"$DEF""
			echo -e ""$RED" |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$YELLOW"/_//____/____/ /_/"$DEF""
			echo
			;;
		subheader)
			timeupdate
			tput cup 6 0
			echo -e "$RED""///"$GRAY" Watching "$YELLOW"`hostname -d`"$GRAY" from "$YELLOW""`hostname -s`" "$RED"/// "$GRAY"Load:`uptime | awk -F'load average:' '{ print $2 }'`"$RED" ///"$GRAY" $HM"$DEF""
			echo
			echo
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
pinghosts() # Parses hosts.lst into variables, pings host, displays output based on ping result
{
	Y=10
	HOSTS=0
	HOSTSOK=0
	HOSTSDOWN=0

	if [ "$REDRAW" == "YES" ] ; then echo -e ""$LIGHTYELLOW"NAME           LOCATION             ADDRESS           AVG.LATENCY        STATUS"$DEF""; gfx line; fi
	while read -r HOSTENTRY
		do
			Y=$(( Y + 1 ))
			HOSTS=$(( HOSTS + 1))
			
			HOSTDESC=`echo $HOSTENTRY | awk -F":" '{print $1}' $2`
			HOSTLOC=`echo $HOSTENTRY | awk -F":" '{print $2}' $2`
			HOSTIP=`echo $HOSTENTRY | awk -F":" '{print $3}' $2`
			#echo YOLO $HOSTENTRY BRO $HOSTDESC $HOSTLOC $HOSTIP $Y
			if [ "$REDRAW" == "YES" ] ; then
				tput el
				upforward 0
				#echo "                                                                               "
				echo -e ""$GRAY"$HOSTDESC"
				upforward 14
				echo -e " "$GRAY"$HOSTLOC"
				upforward 35
				echo -e " "$GRAY"$HOSTIP"
			fi
			
			upforward 53	
			echo -e " "$WHITE"[   "$LIGHTYELLOW"Ping in progress..  "$WHITE"]"$DEF""
			
			ping -q -c 2 -n -i 0.2 -W1 $HOSTIP &> /dev/null
				if [ $? == 0 ]; then
					HOSTLAT=`ping -q -c 2 -n -i 0.2 -W1 $HOSTIP | tail -1| awk '{print $4}' | cut -d '/' -f 2`
					HOSTLAT="$HOSTLAT ms"
					upforward 53
					tput el
					echo -e " "$GRAY"$HOSTLAT"
					upforward 63
					echo -e "          "$GREEN"[ "$LIGHTGREEN"UP"$GREEN""$DEF" ]"
					HOSTSOK=$(( HOSTSOK + 1))
				else
					PINGCODE=$?
					tput el
#					tput bold
#					tput setab 1
#					tput setaf 7
#					upforward 0
#					echo "                                                                               "
					upforward 0
					echo -e ""$LIGHTRED"$HOSTDESC"
					upforward 14
					echo -e " "$LIGHTRED"$HOSTLOC"
					upforward 35
					echo -e " "$LIGHTRED"$HOSTIP"
					upforward 53
					echo -e " "$LIGHTRED"Ping exitcode: $PINGCODE"
					upforward 70
					echo -e "   "$RED"["$LIGHTRED"DOWN"$RED"] "$DEF""
					HOSTSDOWN=$(( HOSTSDOWN + 1))
					REDRAW=YES # Redraw next host pinged
				fi
		done < hosts.lst
		if [ "$HOSTSOK" == "$HOSTS" ] ; then REDRAW=NO; else REDRAW=YES; fi # If any hosts failed, we want to redraw next round
}

upforward() # Move up one line in terminal and jump to horisontal posistion specified
{
	#
	tput cup $Y $1
}
summarynext() #Displays a status summary and statistics and waits the number of seconds determined by REFRESHRATE
{
	echo
	tput el
	if [ "$HOSTSOK" == "$HOSTS" ] ; then
		echo -e "$RED""///"$YELLOW" SUMMARY @ $HMS: "$DEF""$LIGHTGRAY"$HOSTSOK"$DEF""$GRAY" of "$DEF""$LIGHTGRAY"$HOSTS"$DEF""$GRAY" hosts are "$LIGHTGREEN"UP"$DEF" "
	else
		echo -e "$RED""///"$YELLOW" SUMMARY @ $HMS: "$DEF""$LIGHTGRAY"$HOSTSDOWN"$DEF""$GRAY" of "$DEF""$LIGHTGRAY"$HOSTS"$DEF""$GRAY" hosts are "$LIGHTRED"DOWN"$DEF" "
	fi
	tput sc
	COUNTDOWN=$REFRESHRATE
	COUNTERWITHINACOUNTER=10 			#yodawg
	until [ $COUNTDOWN == 0 ]; do
		echo -e -n "$RED""--""$YELLOW""> "$GRAY"Next check is scheduled in "$LIGHTYELLOW"$COUNTDOWN"$DEF" "$GRAY"second(s).    (Press [CTRL+C] to exit..)"$DEF""
		sleep 1
		if [ $COUNTERWITHINACOUNTER == 0 ]; then gfx subheader; COUNTERWITHINACOUNTER=10; fi
		COUNTDOWN=$(( COUNTDOWN - 1 ))
		COUNTERWITHINACOUNTER=$(( COUNTERWITHINACOUNTER - 1 ))
		tput rc
		tput el
	done
}


# FUNCTIONS END:
##################


# The actual runscript:

trap "{ reset; echo Watchdog1337 $APPVERSION terminated at `date`; exit; }" SIGINT SIGTERM EXIT # Set trap for catching Ctrl-C and kills, so we can reset terminal upon exit

clear
gfx splash # Display splash screen with logo

echo Loading configuration.. # Read from settings.cfg, if exists
if [ -f settings.cfg ] ; then
	source settings.cfg
else
	echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"No settings.cfg, defaulting refreshrate to 5 seconds"$DEF""
	sleep 2
	REFRESHRATE=5
fi

echo Checking hosts.lst..   # Read from hosts.lst, if exists. Otherwise terminate script
if [ -f hosts.lst ] ; then
	continue
else
	echo -e ""$RED"WATCHDOG ERROR: "$GRAY"Could not locate hosts.lst, terminating script.."$DEF""
	sleep 3
	exit
fi

clear
gfx header # Display top logo

while true # The script will repeat below until CTRL-C is pressed
	do
		gfx subheader # Display information line below logo
		pinghosts # Read hosts.lst, ping hosts and output results
		summarynext # Show summary, wait, continue
	done
