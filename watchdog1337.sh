#!/bin/bash
# Watchdog 1337 monitoring script
# Written by Christer Jonassen
# Licensed under CC BY-NC-SA 3.0 (check LICENCE file or http://creativecommons.org/licenses/by-nc-sa/3.0/ for details.)
# Made possible by the wise *nix people sharing their knowledge online
#
# Check README for instructions

# Variables
export APPVERSION="2.1"
export REDRAW=YES
export LOOP=true
export DOMAIN=$(hostname -d) # Reads the domain part of the hostname, e.g. network.lan
if [ -z "$DOMAIN" ]; then export DOMAIN=hosts; fi # If domain part of hostname is blank, set text to "hosts"
export PREVIOUSCOLUMNS=$(tput cols)
export PREVIOUSLINES=$(tput lines)
# Pretty colors for the terminal:

## Palette for splash logo usage (not part of theme)
export DEF="\x1b[0m"
export GRAY="\x1b[37;11m"
export LIGHTRED="\x1b[31;01m"
export RED="\x1b[31;11m"
export LIGHTYELLOW="\x1b[33;01m"
export YELLOW="\x1b[33;11m"


######

### Default/failover theme palette:

### System/terminal default color. Also used to disable highlights
export DEF="\x1b[0m"

### Red
export MAINCOLOR1="\x1b[31;11m"

### Yellow
export MAINCOLOR2="\x1b[33;11m"

### Gray
export MAINTEXTCOLOR="\x1b[37;11m"

### White
export HIGHLIGHT_MAINTEXTCOLOR="\x1b[37;1m"
### Green
export COLOR_OK="\x1b[32;11m"

### Light green
export HIGHLIGHT_COLOR_OK="\x1b[32;01m"

### Light red
export HIGHLIGHT_ERROR="\x1b[31;01m"

### Light yellow
export HIGHLIGHT_LABEL_PING="\x1b[33;01m"

######


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
			echo -e "          "$RED"WATCHDOG "$YELLOW"1337 "$GRAY"Version $APPVERSION - "$RED"Cj Designs"$GRAY"/"$YELLOW"CSDNSERVER.COM"$GRAY" - 2015"
			sleep 2
			clear
			
			;;
		
		line)
			echo -e ""$DEF""$MAINCOLOR1"--------------------------------------------------------------------------------"$DEF""
			;;

		header)
			clear
			if [[ "$SLIM" != "1" ]]; then
				if [[ -n "$HEADER1" ]]; then
					echo -e "$HEADER1"
					if [[ -n "$HEADER2" ]]; then echo -e "$HEADER2"; else echo; fi
					if [[ -n "$HEADER3" ]]; then echo -e "$HEADER3"; else echo; fi
					if [[ -n "$HEADER4" ]]; then echo -e "$HEADER4"; else echo; fi
					if [[ -n "$HEADER5" ]]; then echo -e "$HEADER5"; else echo; fi
				else
				echo -e ""$MAINCOLOR1"  _       _____  ______________  ______  ____  ______"$MAINCOLOR2"   __________________"$DEF""
				echo -e ""$MAINCOLOR1" | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$MAINCOLOR2" <  /__  /__  /__  /"$DEF""
				echo -e ""$MAINCOLOR1" | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$MAINCOLOR2"  / / /_ < /_ <  / /"$DEF""
				echo -e ""$MAINCOLOR1" | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$MAINCOLOR2" / /___/ /__/ / / /"$DEF""
				echo -e ""$MAINCOLOR1" |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$MAINCOLOR2"/_//____/____/ /_/"$DEF""
				fi
			echo
			fi
			;;

		subheader)
			if [[ "$SLIM" != "1" ]]; then
				timeupdate
				tput cup 6 0
				echo -e ""$MAINCOLOR1"///"$MAINTEXTCOLOR" Watching "$MAINCOLOR2"$DOMAIN"$MAINTEXTCOLOR" from "$MAINCOLOR2""$(hostname -s)" "$MAINCOLOR1"/// "$MAINTEXTCOLOR"Load: $(uptime | awk -F': ' '{ print $2 }')"$MAINCOLOR1" ///"$MAINTEXTCOLOR" $HM"$DEF""
				echo
				echo
			else
				timeupdate
				tput cup 0 0
				if [[ -n "$SLIMHEADER" ]]; then
					echo -e "$SLIMHEADER"
				else
				echo -e ""$MAINCOLOR1"/// Watchdog "$MAINCOLOR2"1337 "$MAINCOLOR1"///"$MAINTEXTCOLOR" Watching "$MAINCOLOR2"$DOMAIN"$MAINTEXTCOLOR" from "$MAINCOLOR2""$(hostname -s)""
				fi
			fi
			;;
	esac
}

timeupdate() # Sets current time into different variables. Used for timestamping etc.
{
	now=$(date -u +%s)
	export DATE=$(date -d @$now +"%d-%m-%Y")
	export UNIXSTAMP=$(date -d @$now +%s)
	export NOWSTAMP=$(date -d @$now +"%Hh%Mm%Ss")
	export HM=$(date -d @$now +"%R")
	export HMS=$(date -d @$now +"%R:%S")
	export HOUR=$(date -d @$now +"%H")
	export MINUTE=$(date -d @$now +"%M")
	export SEC=$(date -d @$now +"%S")
}

printheader() # Draw the header (column labels)
{
	if [[ "$SLIM" != "1" ]]; then
		HEADYPOS=9
	else
		HEADYPOS=2
	fi
	tput cup $HEADYPOS 0
	echo -e ""$DEF""$HIGHLIGHT_LABEL_PING"NAME"
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
		PREVIOUSHOSTS=$HOSTS
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
	HOSTLAT=none
	if [ "$REDRAW" == "YES" ] ; then printheader; fi
		#if [ "$REDRAW" == "YES" ] ; then echo -e ""$DEF""$HIGHLIGHT_LABEL_PING"NAME           LOCATION             ADDRESS           AVG.LATENCY        STATUS"$DEF""; gfx line; fi

	while read -r HOSTENTRY
		do
			Y=$(( Y + 1 ))
			HOSTS=$(( HOSTS + 1))
			
			HOSTDESC=$(echo $HOSTENTRY | awk -F":" '{print $1}' $2)
			HOSTLOC=$(echo $HOSTENTRY | awk -F":" '{print $2}' $2)
			HOSTIP=$(echo $HOSTENTRY | awk -F":" '{print $3}' $2)

			if [ "$REDRAW" == "YES" ] ; then
				tput el
				upforward 0
				#echo "                                                                               "
				echo -e ""$MAINTEXTCOLOR"$HOSTDESC"
				upforward 14
				echo -e " "$MAINTEXTCOLOR"$HOSTLOC"
				upforward 35
				echo -e " "$MAINTEXTCOLOR"$HOSTIP"
			fi
			
			upforward 53	
			echo -e " "$DEF""$HIGHLIGHT_MAINTEXTCOLOR"[   "$HIGHLIGHT_LABEL_PING"Ping in progress..  "$HIGHLIGHT_MAINTEXTCOLOR"]"$DEF""
			# Currently, we execute ping up to two times per host. This is due to parcing replacing the exit code from ping. Hopefully a better solution will be found later.
			ping -q -c $PING_COUNT -n -i $PING_INTERVAL -W $PING_TIMEOUT $HOSTIP &> /dev/null	# Ping first to get exit code
				if [ $? == 0 ]; then
					PINGCODE=$?
					HOSTLAT=$(ping -q -c $PING_COUNT -n -i $PING_INTERVAL -W $PING_TIMEOUT $HOSTIP | tail -1 | awk '{print $4}' | cut -d '/' -f 2) &> /dev/null # ping again to get avg latency parced
					HOSTLATINT=$(echo $HOSTLAT | awk -F"." '{print $1}')
					HOSTLAT="$HOSTLAT ms"
					upforward 53
					tput el
					if [[ $HOSTLATINT -gt 20 ]]; then
					echo -e " "$HIGHLIGHT_LABEL_PING"$HOSTLAT"
					else
					echo -e " "$MAINTEXTCOLOR"$HOSTLAT"
					fi
					
					upforward 65
					echo -e "        "$DEF""$MAINTEXTCOLOR"[ "$COLOR_OK"UP"$DEF""$MAINTEXTCOLOR" ] "$DEF""
					HOSTSOK=$(( HOSTSOK + 1))
				else
					PINGCODE=$?
					HOSTLAT=none
					tput el
					upforward 0
					echo -e ""$DEF""$HIGHLIGHT_ERROR"$HOSTDESC"
					upforward 14
					echo -e " "$DEF""$HIGHLIGHT_ERROR"$HOSTLOC"
					upforward 35
					echo -e " "$DEF""$HIGHLIGHT_ERROR"$HOSTIP"
					upforward 53
					echo -e " "$DEF""$HIGHLIGHT_ERROR"Ping exitcode: $PINGCODE"
					upforward 70
					echo -e "   "$DEF""$MAINTEXTCOLOR"["$DEF""$HIGHLIGHT_ERROR"DOWN"$DEF""$MAINTEXTCOLOR"] "$DEF""
					HOSTSDOWN=$(( HOSTSDOWN + 1))
					REDRAW=YES # Redraw next host pinged
				fi

				if [[ "$CUSTOMCMDENABLE" == "1" ]]; then
					timeupdate
					if [[ "$PINGCODE" == "0" ]]; then
						eval "$CUSTOMCMDUP"
					else
						eval "$CUSTOMCMDDOWN"
					fi
				fi

		done < hosts.lst
		if [ "$HOSTSOK" == "$HOSTS" ] ; then REDRAW=NO; else REDRAW=YES; fi # If any hosts failed, we want to redraw next round
}

pingprep()
{
	if [[ "$SLIM" != "1" ]]; then
		Y=10
	else
		Y=3
	fi
	HOSTS=0
	HOSTSOK=0
	echo -n > .hosts-ok
	HOSTSDOWN=0
	echo -n > .hosts-down
	HOSTLAT=none
	if [ "$REDRAW" == "YES" ] ; then printheader; fi
	
	export -f pinghostsparallel
	export -f upforward
	export -f timeupdate
	export CUSTOMCMDENABLE
	export CUSTOMCMDUP
	export CUSTOMCMDDOWN
	export PING_COUNT
	export PING_INTERVAL
	export PING_TIMEOUT
	export REDRAW
	export Y
#STAPH
	rm hosts-autogen.lst &> /dev/null
	while read -r HOSTENTRY; do
		Y=$(( Y + 1 ))
		echo $HOSTENTRY:$Y >> hosts-autogen.lst
	done < hosts.lst

	export PROGRESSPRINT=YES
	parallel -k -j0 pinghostsparallel :::: hosts-autogen.lst
	export PROGRESSPRINT=NO
	parallel -k -j0 pinghostsparallel :::: hosts-autogen.lst

	while read -r HOSTSTAT
		do
			HOSTSOK=$(( HOSTSOK + 1))
		done < .hosts-ok

	while read -r HOSTSTAT
		do
			HOSTSDOWN=$(( HOSTSDOWN + 1))
		done < .hosts-down

	HOSTS=$(( HOSTSDOWN + HOSTSOK ))

	if [ "$HOSTSOK" == "$HOSTS" ] ; then REDRAW=NO; else REDRAW=YES; fi # If any hosts failed, we want to redraw next round
}

pinghostsparallel()
{
	HOSTENTRY=$1
	HOSTDESC=$(echo $HOSTENTRY | awk -F":" '{print $1}' $2)
	HOSTLOC=$(echo $HOSTENTRY | awk -F":" '{print $2}' $2)
	HOSTIP=$(echo $HOSTENTRY | awk -F":" '{print $3}' $2)
	Y=$(echo $HOSTENTRY | awk -F":" '{print $NF}' $2)

	if [[ "$PROGRESSPRINT" == "YES" ]]; then

		if [ "$REDRAW" == "YES" ] ; then
		tput el
		upforward 0
		echo -e ""$MAINTEXTCOLOR"$HOSTDESC"
		upforward 14
		echo -e " "$MAINTEXTCOLOR"$HOSTLOC"
		upforward 35
		echo -e " "$MAINTEXTCOLOR"$HOSTIP"
		fi

		upforward 53	
		echo -e " "$DEF""$HIGHLIGHT_MAINTEXTCOLOR"[   "$HIGHLIGHT_LABEL_PING"Ping in progress..  "$HIGHLIGHT_MAINTEXTCOLOR"]"$DEF""

	else

		upforward 54
		ping -q -c 2 -n -i 0.2 -W1 $HOSTIP &> /dev/null
			if [ $? == 0 ]; then
				PINGCODE=$?
				HOSTLAT=`ping -q -c $PING_COUNT -n -i $PING_INTERVAL -W $PING_TIMEOUT $HOSTIP | tail -1| awk '{print $4}' | cut -d '/' -f 2`
				HOSTLATINT=$(echo $HOSTLAT | awk -F"." '{print $1}')
				HOSTLAT="$HOSTLAT ms"
				upforward 53
				tput el
					if [[ $HOSTLATINT -gt 20 ]]; then
					echo -e " "$HIGHLIGHT_LABEL_PING"$HOSTLAT"
					else
					echo -e " "$MAINTEXTCOLOR"$HOSTLAT"
					fi
				upforward 65
				echo -e "        "$DEF""$MAINTEXTCOLOR"[ "$COLOR_OK"UP"$DEF""$MAINTEXTCOLOR" ] "$DEF""
				echo 1 >> .hosts-ok
			else
				PINGCODE=$?
				HOSTLAT=none
				tput el
				upforward 0
				echo -e ""$DEF""$HIGHLIGHT_ERROR"$HOSTDESC"
				upforward 14
				echo -e " "$DEF""$HIGHLIGHT_ERROR"$HOSTLOC"
				upforward 35&& 
				echo -e " "$DEF""$HIGHLIGHT_ERROR"$HOSTIP"
				upforward 53
				echo -e " "$DEF""$HIGHLIGHT_ERROR"Ping exitcode: $PINGCODE"
				upforward 70
				echo -e "   "$DEF""$MAINTEXTCOLOR"["$DEF""$HIGHLIGHT_ERROR"DOWN"$DEF""$MAINTEXTCOLOR"] "$DEF""
				echo 1 >> .hosts-down
				export REDRAW=YES # Redraw next host pinged
			fi

			if [[ "$CUSTOMCMDENABLE" == "1" ]]; then
				timeupdate
				if [[ "$PINGCODE" == "0" ]]; then
					eval "$CUSTOMCMDUP"
				else
					eval "$CUSTOMCMDDOWN"
				fi
			fi

	fi
}

summarynext() #Displays a status summary and statistics and waits the number of seconds determined by REFRESHRATE
{
	echo
	if [ "$CUSTOMCMDENABLE" == "1" ] ; then # Execute a custom command, if enabled in settings.cfg
		timeupdate
		eval "$CUSTOMCMDROUND"
	fi
	tput el
	if [ "$HOSTSOK" == "$HOSTS" ] ; then
		echo -e "$MAINCOLOR1""///"$MAINCOLOR2" SUMMARY @ $HMS: "$DEF""$HIGHLIGHT_MAINTEXTCOLOR"$HOSTSOK"$DEF""$MAINTEXTCOLOR" of "$DEF""$HIGHLIGHT_MAINTEXTCOLOR"$HOSTS"$DEF""$MAINTEXTCOLOR" hosts are "$HIGHLIGHT_COLOR_OK"UP"$DEF" "
	else
		echo -e "$MAINCOLOR1""///"$MAINCOLOR2" SUMMARY @ $HMS: "$DEF""$HIGHLIGHT_MAINTEXTCOLOR"$HOSTSDOWN"$DEF""$MAINTEXTCOLOR" of "$DEF""$HIGHLIGHT_MAINTEXTCOLOR"$HOSTS"$DEF""$MAINTEXTCOLOR" hosts are "$HIGHLIGHT_ERROR"DOWN"$DEF" "
	fi
	tput sc
	COUNTDOWN=$REFRESHRATE
	COUNTERWITHINACOUNTER=10 			#yodawg
	until [ $COUNTDOWN == 0 ]; do
		echo -e -n "$MAINCOLOR1""--""$MAINCOLOR2""> "$MAINTEXTCOLOR"Next check is scheduled in "$HIGHLIGHT_LABEL_PING"$COUNTDOWN"$DEF" "$MAINTEXTCOLOR"second(s).    (Press [CTRL+C] to exit..)"$DEF""
		sleep 1
		if [ $COUNTERWITHINACOUNTER == 0 ]; then gfx subheader; COUNTERWITHINACOUNTER=10; fi
		COUNTDOWN=$(( COUNTDOWN - 1 ))
		COUNTERWITHINACOUNTER=$(( COUNTERWITHINACOUNTER - 1 ))
		tput rc
		tput el
	done
	CURRENTCOLUMNS=$(tput cols)
	CURRENTLINES=$(tput lines)
	CURRENTHOSTS=$HOSTS
	if [ "$PREVIOUSCOLUMNS" != "$CURRENTCOLUMNS" ]; then
		termreset
	elif [ "$PREVIOUSLINES" != "$CURRENTLINES" ]; then
		termreset
	elif [ -n "$PREVIOUSHOSTS" ]; then
		if [ "$PREVIOUSHOSTS" != "$CURRENTHOSTS" ]; then
		termreset
		fi
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
if [ -z "$RUN_ONCE" ]; then echo -e ""$MAINCOLOR2"WATCHDOG Warning:"; echo -e ""$MAINTEXTCOLOR"RUN_ONCE not set, changing RUN_ONCE to 0."$DEF""; RUN_ONCE=0; sleep 1; fi
if [ "$PARALLEL" == "1" ]; then echo -e ""$MAINCOLOR2"WATCHDOG Warning: "$MAINTEXTCOLOR"PARALLEL activated, this feature is experimental."$DEF""; else PARALLEL=0; sleep 1; fi
if [ -z "$SLIM" ]; then echo -e ""$MAINCOLOR2"WATCHDOG Warning: "$MAINTEXTCOLOR"SLIM not set, changing SLIM to 0."$DEF""; SLIM=0; sleep 1; fi 
if [ -z "$COL2" ]; then echo -e ""$MAINCOLOR2"WATCHDOG Warning: "$MAINTEXTCOLOR"COL2 not set, changing COL2 to "LOCATION"."$DEF""; COL2=LOCATION; sleep 1; fi 
if [ -n "$THEME" ]; then if [ -f "$THEME" ]; then source $THEME; else echo -e ""$MAINCOLOR2"WATCHDOG Warning:"; echo -e ""$MAINTEXTCOLOR"Theme "$THEME" could not be found, fallback to built-in theme."$DEF""; fi; fi 
if [ -z "$REFRESHRATE" ]; then echo -e ""$MAINCOLOR2"WATCHDOG Warning: "$MAINTEXTCOLOR"REFRESHRATE not set, changing REFRESHRATE to 5 seconds."$DEF""; REFRESHRATE=5; sleep 1; fi
if [ -z "$CUSTOMCMDENABLE" ]; then echo -e ""$MAINCOLOR2"WATCHDOG Warning: "$MAINTEXTCOLOR"CUSTOMCMDENABLE not set, changing CUSTOMCMDENABLE to 0."$DEF""; CUSTOMCMDENABLE=0; sleep 1; fi
if [ -z "$CUSTOMCMDUP" ]; then echo -e ""$MAINCOLOR2"WATCHDOG Warning: "$MAINTEXTCOLOR"CUSTOMCMDUP not set, changing CUSTOMCMDENABLE to 0."$DEF""; CUSTOMCMDENABLE=0; sleep 1; fi
if [ -z "$CUSTOMCMDDOWN" ]; then echo -e ""$MAINCOLOR2"WATCHDOG Warning: "$MAINTEXTCOLOR"CUSTOMCMDDOWN not set, changing CUSTOMCMDENABLE to 0."$DEF""; CUSTOMCMDENABLE=0; sleep 1; fi
if [ -z "$CUSTOMCMDROUND" ]; then echo -e ""$MAINCOLOR2"WATCHDOG Warning: "$MAINTEXTCOLOR"CUSTOMCMDROUND not set, changing CUSTOMCMDENABLE to 0."$DEF""; CUSTOMCMDENABLE=0; sleep 1; fi
if [ -z "$PING_COUNT" ]; then echo -e ""$MAINCOLOR2"WATCHDOG Warning: "$MAINTEXTCOLOR"PING_COUNT not set, changing PING_COUNT to 3."$DEF""; PING_COUNT=3; sleep 1; fi
if [ -z "$PING_INTERVAL" ]; then echo -e ""$MAINCOLOR2"WATCHDOG Warning: "$MAINTEXTCOLOR"PING_INTERVAL not set, changing PING_INTERVAL to 0.3."$DEF""; PING_INTERVAL=0.3; sleep 1; fi
if [ -z "$PING_TIMEOUT" ]; then echo -e ""$MAINCOLOR2"WATCHDOG Warning: "$MAINTEXTCOLOR"PING_TIMEOUT not set, changing PING_TIMEOUT to 1."$DEF""; PING_TIMEOUT=1; sleep 1; fi

echo Checking hosts.lst..   # Read from hosts.lst, if exists. Otherwise terminate script
if [ -f hosts.lst ]; then echo "Starting Watchdog1337.."; else echo -e ""$HIGHLIGHT_ERROR"WATCHDOG ERROR: "$MAINTEXTCOLOR"Could not locate hosts.lst, terminating script.."$DEF""; sleep 3; exit; fi

clear
gfx header # Display top logo

while [[ "$LOOP" == true ]]; do # The script will repeat below until CTRL-C is pressed
	gfx subheader # Display information line below logo
	if [[ "$PARALLEL" == "1" ]]; then
		pingprep
	else
		pinghosts
	fi
	# Read hosts.lst, ping hosts and output results
	if [[ "$RUN_ONCE" == "1" ]]; then
		LOOP=false
	fi
	summarynext # Show summary, wait, continue
done
