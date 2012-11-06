#!/bin/bash
# Watchdog 1337 console script
# Displays results from watchdogd.sh

# Variables
APPVERSION=0.1

clear
echo Loading library..
source watchdoglib.sh

gfx splash
timeupdate
gfx header