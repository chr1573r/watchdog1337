#!/bin/bash

# Pretty colors!
DEF="\x1b[0m"
WHITE="\e[0;37m"
LIGHTBLACK="\x1b[30;01m"
BLACK="\x1b[30;11m"
LIGHTBLUE="\x1b[34;01m"
BLUE="\x1b[34;11m"
LIGHTCYAN="\x1b[36;01m"
CYAN="\x1b[36;11m"
LIGHTGRAY="\x1b[37;11m"
GRAY="\x1b[37;01m"
LIGHTGREEN="\x1b[32;01m"
GREEN="\x1b[32;11m"
LIGHTPURPLE="\x1b[35;01m"
PURPLE="\x1b[35;11m"
LIGHTRED="\x1b[31;01m"
RED="\x1b[31;11m"
LIGHTYELLOW="\x1b[33;01m"
YELLOW="\x1b[33;11m"

gfx ()
{
	# This function provides "[  OK  ]" and "[FAILED]" text output (followed by a line break)
	# SYNTAX: gfx [element] [element text, if applicable]
	# Valid elements:
	#	Feedback gfx:
	#			"ok" - Prints "[  OK  ]" with green text
	#			"failed" - Prints "[FAILED]" with red text
	#	Design gfx:
	#			"splash" - The splashscreen, logo made possible by http://www.network-science.de/ascii/
	#			"line" - Draws a red line (-----)
	#			"header" - adds a yellow line, echos param $2, adds a yellow line again
	#	Error gfx:
	#			
	# "gfx ok" will print "[  OK  ]", while "gfx failed" will print "[FAILED]"
	# 
	# Actions performed by gfx() are also logged depending on $LOGLEVEL
	local FUNCTIONNAME="gfx()"

	case "$1" in

		ok)
			echo -e "                         "$WHITE"[  "$GREEN"OK"$WHITE"  ]$DEF"
				echo
				;;	
			
		failed)
		        echo -e "                         "$WHITE"["$RED"FAILED"$WHITE"]$DEF"
				echo
				;;
		
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
			echo
			echo -e ""$RED"    _       _____  ______________  ______  ____  ______"$YELLOW"    __________________"$DEF""
			echo -e ""$RED"   | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$YELLOW"  <  /__  /__  /__  /"$DEF""
			echo -e ""$LIGHTRED"   | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$LIGHTYELLOW"   / / /_ < /_ <  / /"$DEF""
			echo -e ""$LIGHTRED"   | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$LIGHTYELLOW"  / /___/ /__/ / / /"$DEF""
			echo -e ""$LIGHTRED"   |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$LIGHTYELLOW" /_//____/____/ /_/"$DEF""
			echo
			echo -e "       "$RED"WATCHDOG "$YELLOW"1337 "$DEF"Version $APPVERSION - "$YELLOW"CSDNSERVER.COM"$DEF" (C) Past-Present-Future"$DEF
			sleep 2
			clear
			
			;;
		
		line)
			echo -e "$RED------------------------------$DEF"
			;;

		header)
			clear
			echo -e ""$RED"  _       _____  ______________  ______  ____  ______"$YELLOW"   __________________"$DEF""
			echo -e ""$RED" | |     / /   |/_  __/ ____/ / / / __ \/ __ \/ ____/ "$YELLOW" <  /__  /__  /__  /"$DEF""
			echo -e ""$RED" | | /| / / /| | / / / /   / /_/ / / / / / / / / __  "$YELLOW"  / / /_ < /_ <  / /"$DEF""
			echo -e ""$RED" | |/ |/ / ___ |/ / / /___/ __  / /_/ / /_/ / /_/ /  "$YELLOW" / /___/ /__/ / / /"$DEF""
			echo -e ""$RED" |__/|__/_/  |_/_/  \____/_/ /_/_____/\____/\____/   "$YELLOW"/_//____/____/ /_/"$DEF""
			echo
			echo -e "$BLUE""///"$GREEN" Watching over "$DEF"cjnet.lan"$GREEN" from "$DEF""$HOSTNAME" "$BLUE"/// "$GREEN"`date`"
			echo
			;;
		arrow)
			echo -e "$RED""--""$YELLOW""> ""$DEF""$2"
			echo
			;;
		subarrow)
			echo -e "$RED""----""$YELLOW""> ""$DEF""$2"
			;;
		fuarrow)
			echo -e "$APPNAME"":"$CYAN"$2"$YELLOW"> "$DEF"$3"
			;;
		subspace)
			echo -e "     $2"

			;;
		colourtest)
			echo "#### Colour test"
			echo -e "$WHITE" WHITE
			echo -e "$BLACK" BLACK
			echo -e "$LIGHTBLACK" LIGHTBLACK
			echo -e "$BLUE" BLUE
			echo -e "$LIGHTBLUE" LIGHTBLUE
			echo -e "$CYAN" CYAN
			echo -e "$LIGHTCYAN" LIGHTCYAN
			echo -e "$GRAY" GRAY
			echo -e "$LIGHTGRAY" LIGHTGRAY
			echo -e "$GREEN" GREEN
			echo -e "$LIGHTGREEN" LIGHTGREEN
			echo -e "$PURPLE" PURPLE
			echo -e "$LIGHTPURPLE" LIGHTPURPLE
			echo -e "$RED" RED
			echo -e "$LIGHTRED" LIGHTRED
			echo -e "$YELLOW" YELLOW
			echo -e "$LIGHTYELLOW" LIGHTYELLOW
			echo -e "$DEF" DEFAULT
			;;
		*)
			
	esac
}

timeupdate()
{
	DATE=$(date +"%d-%m-%Y")
	NOWSTAMP=$(date +"%Hh%Mm%Ss")
	HM=$(date +"%R")
	HOUR=$(date +"%H")
	MINUTE=$(date +"%M")
	SEC=$(date +"%S")
}
