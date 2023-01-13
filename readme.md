# domoticz_energy_prices v0.2
## _Jeroen Gouma_

Domoticz_Energy_Prices (aka DEP) is a small set of scripts to perform a hourly update of the electricity prices used for costcalculation in Domoticz. 

Scripts are intended for and tested on a Raspberry Pi or other linux environment.

This is the first update. Improvements can (and will) be made. Suggestions are welcome!

Note: Currently scripts calculate only on the variabel tarif. Monthly and yearly fees are not included (yet).

## To Do: 
- Finetuning and cleanup
- Implement error handling

## Scripts
- collect_prices.sh
Collects the prices for tomorrow and saves them for future use by the other scripts
- show_prices.sh
Script to check what the actual prices are that would be send to Domoticz
- update_domoticz_prices.sh
Performs the actual update of the dummy-device in Domoticz every hour with the actual price.
- update_domoticz_costs.sh
Calculates the electricity costs for the selected provider(s) per hour

## Installation part 1 (price gathering)

- Create a dummy sensor in Domoticz of type "Custom Sensor" and take a note of the index number. Give it a proper name indicating it's holding the actual price of electricity.
- Create a folder on your domoticz environment and put all files in there. 
 I use ```/home/pi/domoticz/scripts/energy_prices/ ```
- Make the scripts executable (```chmod 755 *.sh```)
- Execute the command below in the same folder to collect today's pricing:
    ``` wget -O $(date +'%Y%m%d').json2 https://enever.nl/feed/stroomprijs_vandaag.php```
- Execute the show_prices script to validate the output:
``` ./show_prices.sh ```
- If all looks fine open the script update_domoticz_prices.sh and make the following modifcations:
```
- on line 8:     change the URL to your own Domoticz IP
- on line 14-25: change the idx number of the used energy provider to the idx of the sensor created in Domoticz
- on line 50-61: remove the # in front of the line which mentions our energy provider
```
- Save the file and close it.
- The moment of truth: Run the update_domoticz_prices.sh script and check the results:
``` ./update_domotiz_prices.sh ```
- If the feedback contains ``` "status": "OK" ``` everything works as designed.

## Automation
Of course nobody want to run these scripts manually, that's why we have crontab at our disposal. Add the following lines to the crontab the user running domoticz (and change the path to your environment):
```
   # Collect variable electricity prices for tomorrow
      30    19    *    *    *     /home/pi/domoticz/scripts/energy_prices/collect_prices.sh >/dev/null 2>&1
   # Update variable electricity prices in Domoticz
       0     *     *    *     *   /home/pi/domoticz/scripts/energy_prices/update_domoticz_prices.sh  >/dev/null 2>&1
```
The update script is scheduled on minut 0 of every hour to ensure the dashboard always shows the actual price.

## Installation part 2 (Cost calculation)

- Create a dummy sensor in Domoticz of type "Custom Sensor" and take a note of the index number. Give it a proper name indicating it's holding the costs of electricity. You can create multiple for multiple providers if required.
- Open the script update_domoticz_costs.sh and make the following modifcations:
```
- on line 15: change the URL to your own Domoticz IP
- on line 16: change the idx number you use in Domoticz to read data from your meter (aka "Power")
```
- Open the file enever.conf in your favourite editor and find the line of the provider(s) you're interested in:
```
- Remove the # in front of the line
- Replace the last 0 on the line with the id of the Custom sensor created earlier
- Save the file
```
- The moment of truth: Run the update_domoticz_costs.sh script and check the results:
``` ./update_domotiz_costs.sh ```
- If the feedback contains ``` "status": "OK" ``` everything works as designed.

## Automation
Also for cost calculation we don't want to act manual if we have crontab. Add the following lines to the crontab the user running domoticz (and change the path to your environment):
```
   # Calculate electricity costs of the last (clock)hour
       2     *     *    *     *   /home/pi/domoticz/scripts/energy_prices/update_domoticz_costs.sh  >/dev/null 2>&1
```
The script is scheduled on minute 2 of every (clock)hour because it needs to total usage of the past hour to enable proper calculation. Do not run it multiple times within 1 hour, because is adds the costs of the previous hour to the costs already on the custom sensor.
