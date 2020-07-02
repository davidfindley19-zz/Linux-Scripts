#!/bin/bash

# Purpose: Quick system summary.
# Description: Script that quickly gives an overview of the system.
# Date: 7/2/2020
# Version: 1.0

echo -e "
System:

Hostname        : `hostname`
Kernel Version  : `uname -r`
Uptime          : `uptime | sed 's/.*up \([^,]*\), .*/\1/'`
Last Reboot     : `who -b | awk '{print $3,$4}'`
Git Status      : `git status`
"

# Shows available memory of host
printf "Memory Usage:\n"
echo
free -mh
echo 

# Shows disk space

printf "Disk Usage:\n"
echo
df -h 
echo

printf "Report Date: `date`\n"
