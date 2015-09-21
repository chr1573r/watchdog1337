Watchdog1337 README v.2.4.1
=========================
http://csdnserver.com - http://github.com/chr1573r/watchdog1337

Written by Christer Jonassen - Cj Designs

Watchdog1337 is licensed under CC BY-NC-SA 3.0.

(check LICENCE file or http://creativecommons.org/licenses/by-nc-sa/3.0/ for details.)


What is Watchdog1337?
---------------------

Watchdog1337 is a simple network monitoring script written in bash. 
It pings the desired hosts in a fixed time interval and displays the status. 
If there are 10 or less hosts, the output fits nicely within a standard 80x24 terminal window.


Install instructions
----------------------

Providing that you have downloaded and unzipped Watchdog1337 on your computer:

### 1. Adding hosts
Add the hosts you want to monitor to the file named "hosts.lst" in the following format:
`<name>:<location>:<ip>`
One host per line.


### 2. Check settings
Revise default options set in `settings.cfg` and change them if you need to.
You can also add a custom command in `settings.cfg` that will be executed after each ping round.
(Read more about the custom cmd further below)

### 3. Permit and execute
Give watchdog1337.sh permission to run by executing the following command:
`chmod +x watchdog1337.sh`

That's pretty much it! You can now start Watchdog1337 by executing the following:
`./watchdog1337.sh`


How does it work?
-----------------

Watchdog reads host information from the file hosts.lst and settings from settings.cfg. 
It then pings all the hosts from hosts.lst in order and returns the exit code of the ping.
You can choose whether this is done in parallel or sequential (default)

If a host does not respond, the host is highlighted in red until it responds or are removed from hosts.lst. 

After pinging all hosts, Watchdog1337 provides a short summary
and waits a specified number of seconds* before pinging them again.
(* Set in settings.cfg or directly upon execution, e.g `./watchdog1337.sh 300` for 5 minute intervals) 

Watchdog1337 continues to run until interrupted by `Ctrl-C` or killed otherwise. 
 

Custom command execution
------------------------

As stated previously, Watchdog1337 can be set to execute a custom commands.
Currently they can be invoked for every host status update (up/down) and after each ping round.

Examples are provided in settings.cfg, and are by default compatible with included plugins
WDMap and WDAlerts.


Technical details:
------------------

Written in bash, uses ping to determine host status. 
Besides bash, the following common binaries are used:
`ping`, `uptime`, `hostname`, `tput`, `date`, `sleep`, `awk`, `tail`, `cut`.
For parallel mode, install GNU parallel

Should run on the most common Linux distros, 
but it has only been tested properly on the RedHat-based
distro ClearOS (www.clearfoundation.com), Raspian and Ubuntu


Limitations
-----------

There are no limitation on the number of hosts, but keep in mind that hosts are pinged one at a time(*),
and thus you won't know the status of the first host again before the last host is pinged (and after the set wait period)

Each host consumes one(1) line in the console output,
so keep this in mind if you want to display all hosts at the same time.

While only tested briefly, Watchdog1337 does not run _natively_ on Mac OS X or pfSense.

If you somehow should get an empty line or partially missing text when the last host is pinged,
try adding a blank line at the end of `hosts.lst`.
 
Also remember that Watchdog1337 is very simple and only determines host status by ping. 
It can not tell if apache is denying connections on your webserver, unfortunately ;)

* From version 2.0 and up, you can activate that all hosts are pinged in parallel (experimental)