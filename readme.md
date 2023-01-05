# domoticz_energy_prices v0.1
## _Jeroen Gouma_

Domoticz_Energy_Prices (aka DEP) is a small set of script to perform a hourly update of the electricity prices used for costcalculation in Domoticz. 

Scripts are intended for and tested on a raspberry Pi or other linux environment.

This is the first edition send into the world. Imporvements can (and will) be made. Suggestions are welcome!

## To Do: 
- Modify my cost calculation script to use this hourly price. Will be done within the coming days I hope
- Implement error handling

## Scripts
- collect_prices.sh
Collects the prices for tomorrow and saves them for future use by the other scripts
- show_prices.sh
Script to check what the actual prices are that would be send to Domoticz
- update_domoticz.sh
Performs the actual update of the dummy-device in Domoticz every hour with the actual price.

## Installation

- Create a dummy sensor in Domoticz of type "Custom Sensor" and take a note of the index number
- Create a folder on your domoticz environment and put the 3 .sh files in there. 
 I use ```/home/pi/domoticz/scripts/energy_prices/ ```
- Make the executable (```chmod 755 *.sh```)
- Execute the command below in the same folder to collect today's pricing:
    ``` wget -O $(date +'%Y%m%d').json2 https://enever.nl/feed/stroomprijs_vandaag.php```
- Execute the show_prices script to validate the output:
``` ./show_prices.sh ```
- If all looks fine open the script update_dmoticz.sh and make the following modifcations:
```
- on line 8:     change the URL to your own Domoticz IP
- on line 14-25: Change the idx number of the used energy provider to the idx of the sensor created in Domoticz
- on line 50-61: Remove the # in front of the line which mentions our energy provider
```
- Save the file and close it.
- The moment of truth: Run the update_domoticz.sh script and check the results:
``` ./update_domotiz.sh ```
- If the feedback contains ``` "status": "OK" ``` everything works as designed.

## Automation
Of course nobody want to run these script manually, that's why we have crontab at our disposal. Add the following lines to the crontab the user running domoticz (and change the path to your environment):
```
   # Collect variable electricity prices for tomorrow
      30    17    *    *    *     /home/pi/domoticz/scripts/energy_prices/collect_prices.sh >/dev/null 2>&1
   # Update variable electricity prices in Domoticz
       0     *     *    *     *   /home/pi/domoticz/scripts/energy_prices/update_domoticz.sh  >/dev/null 2>&1
```

