#!/bin/bash

# Script shows actual prices as they would be send to Domoticz

mydir=`dirname $0`
myDate=$mydir/$(date +'%Y%m%d')
myHour=$(date +'%H')


# Extract prices from today's pricelist in <date>.json
myPrices=$(cat $myDate.json |jq -r --arg myHour "$myHour" '.data[$myHour |tonumber]|[.datum, .prijs, .prijsZP, .prijsEE, .prijsTI, .prijsFR, .prijsAIP, .prijsEZ, .prijsZG, .prijsNE, .prijsGSL, .prijsANWB, .prijsVON]|@csv'| tr -d '"')

# Extract price for each Energy provider
myDatum=$(echo $myPrices|cut -d, -f1)
myPrice=$(echo $myPrices|cut -d, -f2)
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

# Show prices
echo "Datum/tijd:    "$myDatum
echo "=================================="
echo "Beursprijs:    "$myPrice
echo "Zonneplan:     "$myPriceZP
echo "Easy Energy:   "$myPriceEE
echo "Tibber:        "$myPriceTI
echo "Frank Energie: "$myPriceFR
echo "All in power:  "$myPriceAIP
echo "EnergyZero:    "$myPriceEZ
echo "ZonderGas:     "$myPriceZG
echo "NextEnergy:    "$myPriceNE
echo "Groenestroom:  "$myPriceGSL
echo "ANWB:          "$myPriceANWB
echo "Vrij op Naam:  "$myPriceVON

