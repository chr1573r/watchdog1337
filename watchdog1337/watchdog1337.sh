#!/bin/bash
# Watchdog 1337 monitoring script
# Written by Christer Jonassen
# Licensed under CC BY-NC-SA 3.0 (check LICENCE file or http://creativecommons.org/licenses/by-nc-sa/3.0/ for details.)
# Made possible by the wise *nix people sharing their knowledge online
#
# Check README for instructions

# Variables
APPVERSION="1.2"
REDRAW=YES
DOMAIN=$(hostname -d) # Reads the domain part of the hostname, e.g. network.lan
if [ -z "$DOMAIN" ]; then DOMAIN=hosts; fi # If domain part of hostname is blank, set text to "hosts"
PREVIOUSCOLUMNS=$(tput cols)
PREVIOUSLINES=$(tput lines)
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
			echo -e "          "$RED"WATCHDOG "$YELLOW"1337 "$GRAY"Version $APPVERSION - "$RED"Cj Designs"$GRAY"/"$YELLOW"CSDNSERVER.COM"$GRAY" - 2014"
			sleep 2
			clear
			
			;;
		
		line)
			echo -e ""$DEF""$RED"--------------------------------------------------------------------------------"$DEF""
			;;

		header)
			clear
			if [[ "$SLIM" != "1" ]]; then
				echo -e ""$RED"  _       _____  ______________  ______  ____  ______"$YELLOW"   __________________"$DEF""
				echo -e ""$RED" | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$YELLOW" <  /__  /__  /__  /"$DEF""
				echo -e ""$RED" | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$YELLOW"  / / /_ < /_ <  / /"$DEF""
				echo -e ""$RED" | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$YELLOW" / /___/ /__/ / / /"$DEF""
				echo -e ""$RED" |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$YELLOW"/_//____/____/ /_/"$DEF""
				echo
			fi
			;;
		subheader)
			if [[ "$SLIM" != "1" ]]; then
				timeupdate
				tput cup 6 0
				echo -e "$RED""///"$GRAY" Watching "$YELLOW"$DOMAIN"$GRAY" from "$YELLOW""$(hostname -s)" "$RED"/// "$GRAY"Load:$(uptime | awk -F'load average:' '{ print $2 }')"$RED" ///"$GRAY" $HM"$DEF""
				echo
				echo
			else
				timeupdate
				tput cup 0 0 
				echo -e ""$RED"/// Watchdog "$YELLOW"1337 "$RED"///"$GRAY" Watching "$YELLOW"$DOMAIN"$GRAY" from "$YELLOW""$(hostname -s)""
				#tput cup 1 0
				#echo -e "$RED""///"$GRAY" Watching "$YELLOW"$DOMAIN"$GRAY" from "$YELLOW""$(hostname -s)" "$RED"/// "$GRAY"Load:$(uptime | awk -F'load average:' '{ print $2 }')"$RED" ///"$GRAY" $HM"$DEF""
			fi
			;;
	esac
}

timeupdate() # Sets current time into different variables. Used for timestamping etc.
{
	DATE=$(date +"%d-%m-%Y")
	UNIXSTAMP=$(date +%s)
	NOWSTAMP=$(date +"%Hh%Mm%Ss")
	HM=$(date +"%R")
	HMS=$(date +"%R:%S")
	HOUR=$(date +"%H")
	MINUTE=$(date +"%M")
	SEC=$(date +"%S")
}

printheader() # Draw the header (column labels)
{
	if [[ "$SLIM" != "1" ]]; then
		HEADYPOS=9
	else
		HEADYPOS=2
	fi
	tput cup $HEADYPOS 0
	echo -e ""$DEF""$LIGHTYELLOW"NAME"
	tput cup $HEADYPOS 15
	echo -e "$COL2"
	tput cup $HEADYPOS 36
	echo -e "ADDRESS"
	tput cup $HEADYPOS 54
	echo -e "AVG.LATENCY"
	tput cup $HEADYPOS 73
	echo -e "STATUS"$DEF""
	gfx line
}


upforward() # Move up one line in terminal and jump to horisontal posistion specified
{
	#
	tput cup $Y $1
}

termreset()
{
		echo Terminal size changed, resetting...
		PREVIOUSCOLUMNS=$(tput cols)
		PREVIOUSLINES=$(tput lines)
		REDRAW=YES
		reset
		gfx header
}


pinghosts() # Parses hosts.lst into variables, pings host, displays output based on ping result
{
	if [[ "$SLIM" != "1" ]]; then
		Y=10
	else
		Y=3
	fi
	HOSTS=0
	HOSTSOK=0
	HOSTSDOWN=0
	if [ "$REDRAW" == "YES" ] ; then printheader; fi
		#if [ "$REDRAW" == "YES" ] ; then echo -e ""$DEF""$LIGHTYELLOW"NAME           LOCATION             ADDRESS           AVG.LATENCY        STATUS"$DEF""; gfx line; fi

	while read -r HOSTENTRY
		do
			Y=$(( Y + 1 ))
			HOSTS=$(( HOSTS + 1))
			
			HOSTDESC=$(echo $HOSTENTRY | awk -F":" '{print $1}' $2)
			HOSTLOC=$(echo $HOSTENTRY | awk -F":" '{print $2}' $2)
			HOSTIP=$(echo $HOSTENTRY | awk -F":" '{print $3}' $2)
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
			# Currently, we execute ping up to two times per host. This is due to parcing replacing the exit code from ping. Hopefully a better solution will be found later.
			ping -q -c $PING_COUNT -n -i $PING_INTERVAL -W $PING_TIMEOUT $HOSTIP &> /dev/null	# Ping first to get exit code
				if [ $? == 0 ]; then
					HOSTLAT=$(ping -q -c $PING_COUNT -n -i $PING_INTERVAL -W $PING_TIMEOUT $HOSTIP | tail -1 | awk '{print $4}' | cut -d '/' -f 2) &> /dev/null # ping again to get avg latency parced
					HOSTLAT="$HOSTLAT ms"
					upforward 53
					tput el
					echo -e " "$GRAY"$HOSTLAT"
					upforward 63
					echo -e "          "$DEF""$GRAY"[ "$GREEN"UP"$DEF""$GRAY" ] "$DEF""
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
					echo -e ""$DEF""$LIGHTRED"$HOSTDESC"
					upforward 14
					echo -e " "$DEF""$LIGHTRED"$HOSTLOC"
					upforward 35
					echo -e " "$DEF""$LIGHTRED"$HOSTIP"
					upforward 53
					echo -e " "$DEF""$LIGHTRED"Ping exitcode: $PINGCODE"
					upforward 70
					echo -e "   "$DEF""$GRAY"["$DEF""$LIGHTRED"DOWN"$DEF""$GRAY"] "$DEF""
					HOSTSDOWN=$(( HOSTSDOWN + 1))
					REDRAW=YES # Redraw next host pinged
				fi
		done < hosts.lst
		if [ "$HOSTSOK" == "$HOSTS" ] ; then REDRAW=NO; else REDRAW=YES; fi # If any hosts failed, we want to redraw next round
}


summarynext() #Displays a status summary and statistics and waits the number of seconds determined by REFRESHRATE
{
	echo
	if [ "$CUSTOMCMDENABLE" == "1" ] ; then # Execute a custom command, if enabled in settings.cfg
		timeupdate
		eval "$CUSTOMCMD"
	fi
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
	CURRENTCOLUMNS=$(tput cols)
	CURRENTLINES=$(tput lines)
	if [ "$PREVIOUSCOLUMNS" != "$CURRENTCOLUMNS" ]; then
		termreset

	elif [ "$PREVIOUSLINES" != "$CURRENTLINES" ]; then
		termreset
	fi
}


# FUNCTIONS END:
##################


# The actual runscript:

trap "{ reset; clear;echo Watchdog1337 $APPVERSION terminated at $(date); exit; }" SIGINT SIGTERM EXIT # Set trap for catching Ctrl-C and kills, so we can reset terminal upon exit

clear
gfx splash # Display splash screen with logo

echo Loading configuration.. # Read from settings.cfg, if exists
if [ -f settings.cfg ] ; then source settings.cfg; fi
if [ -n "$1" ]; then REFRESHRATE=$1; fi # Sets $1 as refreshrate, if it is not null. Overrides value set in settings.cfg

echo Validating configuration... # Check if important variables contain anything. If they are empty, default values will be set.
if [ -z "$COL2" ]; then echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"COL2 not set, changing COL2 to "LOCATION"."$DEF""; COL2=LOCATION; sleep 1; fi
if [ -z "$REFRESHRATE" ]; then echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"REFRESHRATE not set, changing REFRESHRATE to 5 seconds."$DEF""; REFRESHRATE=5; sleep 1; fi
if [ -z "$CUSTOMCMDENABLE" ]; then echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"CUSTOMCMDENABLE not set, changing CUSTOMCMDENABLE to 0."$DEF""; CUSTOMCMDENABLE=0; sleep 1; fi
if [ -z "$CUSTOMCMD" ]; then echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"CUSTOMCMD not set, changing CUSTOMCMDENABLE to 0."$DEF""; CUSTOMCMDENABLE=0; sleep 1; fi
if [ -z "$PING_COUNT" ]; then echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"PING_COUNT not set, changing PING_COUNT to 3."$DEF""; PING_COUNT=3; sleep 1; fi
if [ -z "$PING_INTERVAL" ]; then echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"PING_INTERVAL not set, changing PING_INTERVAL to 0.3."$DEF""; PING_INTERVAL=0.3; sleep 1; fi
if [ -z "$PING_TIMEOUT" ]; then echo -e ""$YELLOW"WATCHDOG Warning: "$GRAY"PING_TIMEOUT not set, changing PING_TIMEOUT to 1."$DEF""; PING_TIMEOUT=1; sleep 1; fi

echo Checking hosts.lst..   # Read from hosts.lst, if exists. Otherwise terminate script
if [ -f hosts.lst ]; then echo "Starting Watchdog1337.."; else echo -e ""$RED"WATCHDOG ERROR: "$GRAY"Could not locate hosts.lst, terminating script.."$DEF""; sleep 3; exit; fi

clear
gfx header # Display top logo

while true # The script will repeat below until CTRL-C is pressed
	do
		gfx subheader # Display information line below logo
		pinghosts # Read hosts.lst, ping hosts and output results
		summarynext # Show summary, wait, continue
	done
