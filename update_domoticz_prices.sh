#!/bin/bash

# Write actual kWh price to Domoticz for calculations
# Script needs to be executed every hour at minute 0 to update prices

# Change variables here
####################################################
myDomoticzURL="http://192.168.xxx.xxx:8080"

# Domoticz Index specific provider counters
# Change 99999 into the correct IDX of the device in Domoticz
#     for the selected provider
#####################################################
myTradeidx=99999
myZPidx=99999
myEEidx=99999
myTIidx=99999
myFRidx=99999
myAIPidx=99999
myEZidx=99999
myZGidx=99999
myNEidx=99999
myGSLidx=99999
myANWBidx=9999
myVONidx=99999
myMDEidx=99999

#######################################################
mydir=`dirname $0`
myDate=$mydir/$(date +'%Y%m%d')
myHour=$(date +'%H')

# Extract prices from today's pricelist in <date>.json
myPrices=$(cat $myDate.json |jq -r --arg myHour "$myHour" '.data[$myHour |tonumber]|[.datum, .prijs, .prijsZP, .prijsEE, .prijsTI, .prijsFR, .prijsAIP, .prijsEZ, .prijsZG, .prijsNE, .prijsGSL, .prijsANWB, .prijsVON, .prijsMDE]|@csv'| tr -d '"')

# Extract price for each Energy provider
myPriceTrade=$(echo $myPrices|cut -d, -f2)
myPriceZP=$(echo $myPrices|cut -d, -f3)
myPriceEE=$(echo $myPrices|cut -d, -f4)
myPriceTI=$(echo $myPrices|cut -d, -f5)
myPriceFR=$(echo $myPrices|cut -d, -f6)
myPriceAIP=$(echo $myPrices|cut -d, -f7)
myPriceEZ=$(echo $myPrices|cut -d, -f8)
myPriceZG=$(echo $myPrices|cut -d, -f9)
myPriceNE=$(echo $myPrices|cut -d, -f10)
myPriceGSL=$(echo $myPrices|cut -d, -f11)
myPriceANWB=$(echo $myPrices|cut -d, -f12)
myPriceVON=$(echo $myPrices|cut -d, -f13)
myPriceMDE=$(echo $myPrices|cut -d, -f14)

# Execute curl to update prices in Domoticz
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myTradeidx&nvalue=0&svalue=$myPriceTrade"
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myZPidx&nvalue=0&svalue=$myPriceZP"
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myEEidx&nvalue=0&svalue=$myPriceEE"
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myTIidx&nvalue=0&svalue=$myPriceTI"
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myFRidx&nvalue=0&svalue=$myPriceFR"
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myAIPidx&nvalue=0&svalue=$myPriceAIP"
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myEZidx&nvalue=0&svalue=$myPriceEZ"
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myZGidx&nvalue=0&svalue=$myPriceZG"
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myNEidx&nvalue=0&svalue=$myPriceNE"
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myGSLidx&nvalue=0&svalue=$myPriceGSL"
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myANWBidx&nvalue=0&svalue=$myPriceANWB"
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myVONidx&nvalue=0&svalue=$myPriceVON"
#curl -s "$myDomoticzURL/json.htm?type=command&param=udevice&idx=$myMDEidx&nvalue=0&svalue=$myPriceMDE"

