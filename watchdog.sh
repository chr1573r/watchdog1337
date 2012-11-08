#!/bin/bash
# Watchdog 1337 console script
# Displays results from watchdogd.sh

# Variables
APPVERSION=0.1
FIRSTDRAW=YES
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
FIRSTDRAW=NO
summarynext
done
