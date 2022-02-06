#!/bin/bash

# For more information about connecting to your reMarkable check out: https://www.simplykyra.com/2021/02/03/learn-how-to-access-your-remarkable-through-the-command-line/

myConnect="YOUR IP ADDRESS"
myDate=`date +%Y-%m-%d`

echo "Using \"$myConnect\" I'm about to back up your reMarkable to the file \"$myDate\". If this doesn't work you may need to (1) enter your IP Address above, (2) use a public key so you don't need to enter your password or (3) turn on your reMarkable. "

mkdir $myDate
cd $myDate
# How I originally back up my device. As shown on https://www.simplykyra.com/2021/02/03/learn-how-to-access-your-remarkable-through-the-command-line/
scp -r $myConnect:/usr/share/remarkable/ .
# Next lines from the reMarkable wiki at https://remarkablewiki.com/tech/ssh
mkdir -p remarkable-backup/files
scp -r $myConnect:~/.local/share/remarkable/xochitl/ remarkable-backup/files/
scp $myConnect:~/.config/remarkable/xochitl.conf remarkable-backup/
scp $myConnect:/usr/bin/xochitl remarkable-backup/

echo "All Done!"
