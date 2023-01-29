# domoticz_energy_prices 

## v0.3c  2023-01-24
 - small change in enever api url for collecting prices.

## v0.3b  2023-01-24
 - Enever.nl announced that starting feb 15 2023 you will need a token (still free) to get data from their feed. The script collect_prices.sh has been updated to facilitate this.

## v0.3a  2023-01-22
- Corrected calculation of daily costs with tax return (which is negative value)

## v0.3  2023-01-21
- Change of plan on calculating electricity costs (see readme.md)


## v0.2  2023-01-13
- Added Mijn Domein energy provider
- Several small cleanup/typo corrections
- Added script to calculate costs with variable prices for multiple providers
- Renamed update_domoticz.sh to update_domoticz_prices.sh
- Extended the readme with instructions to start with cost calculation


## v0.1  2023-01-05
- First release