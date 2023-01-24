#!/bin/bash

myToken=xxxxxxxxx
mydir=`dirname $0`
myFileName=$mydir/$(date --date="tomorrow" +'%Y%m%d').json

wget -O $myFileName https://enever.nl/feed/stroomprijs_morgen.php?token=$myToken
