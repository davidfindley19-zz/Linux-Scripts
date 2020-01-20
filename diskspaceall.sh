#!/bin/sh

#used to call the diskspace.sh script to check on multiple servers 

echo "Checking disk space on all servers..."

nodelist="server1,server2,server3,etc"
date=$(date +"%m_%d_%Y")
pdsh -w $nodelist "/diskspace.sh" | dshbak -c > /path/to/directory/diskspace_$date
