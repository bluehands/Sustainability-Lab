# Carbon Aware Computing

## Grid carbon intensity

The correlation between electricity power and carbon emission is not a constant and vary over time. The higher the rate of renewables the lower the grid carbon emission.

See [https://app.electricitymaps.com/zone/DE/72h/hourly](https://app.electricitymaps.com/zone/DE/72h/hourly) and [https://www.energy-charts.info/charts/consumption_advice/chart.htm?l=de&c=DE](https://www.energy-charts.info/charts/consumption_advice/chart.htm?l=de&c=DE)

## Tooling & Data

There is free tooling and data. See [https://www.carbon-aware-computing.com/](https://www.carbon-aware-computing.com/) 

### Web API

Register for free to use the API.

Swagger: [https://forecast.carbon-aware-computing.com/swagger/UI](https://forecast.carbon-aware-computing.com/swagger/UI)

``` powershell
curl -X GET "https://forecast.carbon-aware-computing.com/emissions/forecasts/current?location=de&dataStartAt=2025-07-09T19%3A17%3A09.0000000%2B00%3A00&dataEndAt=2025-07-10T15%3A17%3A09.0000000%2B00%3A00&windowSize=10" -H  "accept: application/json" -H  "x-api-key: xxxxxxxxxxxxxxx  Put xour Key here  xxxxxxxxxxxxxxxxxxxxx"
```

### Powershell

```powershell
Install-module -Name CarbonAwareComputing.Cmdlets
```

``` powershell
$now = Get-Date
Get-CarbonAwareExecutionTime -Location de -EarliestExecutionTime $now -LatestExecutionTime ($now).AddHours(10) -EstimatedExecutionDuration "00:20:00" -FallbackExecutionTime $now.AddMinutes(5)
```

### Hangfire