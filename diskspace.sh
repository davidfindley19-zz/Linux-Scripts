#!/bin/sh
df -H | grep -vE '^Filesystem' | awk '{ print $5 " " $4 " " $1 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $3 }' )
  if [ $usep -ge 90 ]; then
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" |
    mail -s "Alert: Almost out of disk space $usep%" -aFrom:email@email.com email1@email.com,email2@email.com
    fi
done
