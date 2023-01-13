#!/bin/bash
##########################################
#
# Script to collect the electricity usage of the previous hour
# and multiply this with the electricity tarig for that hour.
#
# Result is written to Domoticz
#
#########################################


# Modify variables below to your situation
#####################################
SetUp () {
  myDomoticzURL="http://192.168.xxx.xxx:8080"
  myDomoticzPowerIdx=XXX
}


# Process parameters
#####################################
CheckParameters () {
  myDebug=$1
}


# Set enviroment
#####################################
setEnvironment () {
  mydir=`dirname $0`
  myTempFile=$mydir/usage.json
}


# Debug info
#####################################
Echo () {
 if [[ "$myDebug" == "Y" ]]; then
    echo $1 $2 $3 $4 $5
 fi
}


# Processing starts here
#####################################

CheckParameters $@
SetUp
setEnvironment

myHourStart=$(date -d "now - 60 minutes"  +'%Y-%m-%d %H:00')
myTSStart=$(date -d "$myHourStart")
myHourEnd=$(date -d "now"  +'%Y-%m-%d %H:00')
myDate=$mydir/$(date +'%Y%m%d')
myHour=$(date -d"- 60 minutes" +'%H')

Echo "-----"
Echo "myHourStart: "$myHourStart
Echo "myTSStart:   "$myTSStart
Echo "HourEnd:     "$myHourEnd
Echo "myDate:      "$myDate
Echo "myHour:      "$myHour

# Extract prices from today's pricelist in <date>.json
myPrices=$(cat $myDate.json |jq -r --arg myHour "$myHour" '.data[$myHour |tonumber]|[.datum, .prijs, .prijsZP, .prijsEE, .prijsTI, .prijsFR, .prijsAIP, .prijsEZ, .prijsZG, .prijsNE, .prijsGSL, .prijsANWB, .prijsVON, .prijsMDE]|@csv'| tr -d '"')

#Calculate electricity usage last hour
curl -s -o $myTempFile "$myDomoticzURL/json.htm?type=graph&sensor=counter&idx=$myDomoticzPowerIdx&range=day"

Echo "-----"
Echo "HourStart:      "$myHourStart
Echo "HourEnd:        "$myHourEnd


myStartValue=$(cat $myTempFile |jq -r --arg myHourStart "$myHourStart" '.result[]|select(.d | startswith($myHourStart))'|jq -r '[.eu]|@csv'|tr ' ' _ |tr -d '"')
myEndValue=$(cat $myTempFile |jq -r --arg myHourEnd "$myHourEnd" '.result[]|select(.d | startswith($myHourEnd))'|jq -r '[.eu]|@csv'|tr ' ' _ |tr -d '"')

myStartValueReturn=$(cat $myTempFile |jq -r --arg myHourStart "$myHourStart" '.result[]|select(.d | startswith($myHourStart))'|jq -r '[.eg]|@csv'|tr ' ' _ |tr -d '"')
myEndValueReturn=$(cat $myTempFile |jq -r --arg myHourEnd "$myHourEnd" '.result[]|select(.d | startswith($myHourEnd))'|jq -r '[.eg]|@csv'|tr ' ' _ |tr -d '"')

Echo "-----"
Echo "myStartValue: "$myStartValue
Echo "MyEndValue:   "$myEndValue
Echo "MyReturnStart:"$myStartValueReturn
Echo "MyReturnEnd:  "$myEndValueReturn


myUsageWH="$(($myEndValue-$myStartValue))"
myUsageKWH=$(echo "scale=4; $myUsageWH/1000" | bc)
Echo "-----"
Echo "myUsageWH:    "$myUsageWH
Echo "UsageKWH:     "$myUsageKWH

for provider in $(cat $mydir/enever.conf |grep -v "^#")
do
 myProviderID=$(echo $provider|cut -d, -f1)
 myProvider=$(echo $provider|cut -d, -f3)
 myProviderCostsDayIDX=$(echo $provider|cut -d, -f5)
 myProviderCostsMonthIDX=$(echo $provider|cut -d, -f6)
 myProviderCostsYearIDX=$(echo $provider|cut -d, -f7)
 myPrice=$(echo $myPrices|cut -d, -f$myProviderID)
 myCosts=$(echo "scale=4; $myUsageKWH*$myPrice" | bc)

 Echo "-----"
 Echo "Price:        "$myPrice
 Echo "UsageKWH:     "$myUsageKWH
 Echo "Costs:        "$myCosts

 # Retreive cost counters
 myDayCost=$(curl -s "$myDomoticzURL/json.htm?type=graph&sensor=Percentage&idx=$myProviderCostsDayIDX&range=day"|jq -r '.result[-1]|.v')
 Echo "myDayCost: "$myDayCost

 # Calculate new value
 myNewCosts=$(printf "%.2f" $(echo "scale=2; $myDayCost+$myCosts" | bc))
 Echo "myNewCosts: "$myNewCosts

 # Update cost counters
 curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myProviderCostsDayIDX&nvalue=0&svalue=$myNewCosts"


done

