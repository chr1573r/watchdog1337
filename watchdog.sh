#!/bin/bash
# Watchdog 1337 console script
# Displays results from watchdogd.sh

# Variables
APPVERSION=0.1

clear
echo Loading library..
source watchdoglib.sh
echo Loading configuration..
source settings.cfg

gfx splash

while true
do
timeupdate
gfx header
pinghosts
summarynext
done
