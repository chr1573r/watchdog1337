#!/bin/bash
# Watchdog 1337 console script
# Displays results from watchdogd.sh

# Variables
APPVERSION=0.1
REDRAW=YES

# Set trap for catching Ctrl-C and kills
trap "{ reset; echo Watchdog1337 $APPVERSION terminated at `date`; exit; }" SIGINT SIGTERM

clear
echo Loading library..
source watchdoglib.sh
echo Loading configuration..
source settings.cfg

gfx splash

gfx header

while true
	do
		gfx subheader
		pinghosts
		summarynext
	done
