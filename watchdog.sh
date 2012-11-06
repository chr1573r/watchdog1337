#!/bin/bash
# Watchdog 1337 console script
# Displays results from watchdogd.sh

# Variables
APPVERSION=0.1

clear
echo Loading library..
source watchdoglib.sh
echo Loading configuration and hostlist..
source settings.cfg

gfx splash
timeupdate
gfx header
interpethosts