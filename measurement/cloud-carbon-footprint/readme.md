# Measurement of carbon emissions

## Cloud Carbon Footprint

See [https://www.cloudcarbonfootprint.org/](https://www.cloudcarbonfootprint.org/)

### Cloud

``` cmd
cd .\app\packages
yarn start
```

Data is stored in json. See ".\app\packages\api\estimates.cache.day.json"

### OnPrem

Get a list of resources an the uptime.

``` cmd
cd .\app\packages\cli
yarn run estimate-on-premise-data --onPremiseInput on_premise_data_input.csv --onPremiseOutput out.csv
```
