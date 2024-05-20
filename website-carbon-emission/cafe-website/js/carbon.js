import tgwf from 'https://cdn.skypack.dev/@tgwf/co2';

export async function getEstimatedCarbonEmissions(location) {
    let carbonIntensity = await getCarbonIntensity(location);
    let bytesSent = getTransferSize();
    const emissions = new tgwf.co2();
    let result = emissions.perByteTrace(
        bytesSent,
        false,
        {
            gridIntensity: {
                device: carbonIntensity,
                dataCenter: carbonIntensity,
                networks: carbonIntensity,
            }
        }
    )
    let estimatedCO2 = parseFloat(result.co2.toFixed(2));
    return estimatedCO2;
}

const getTransferSize = () => {
    let totalTransferSize = 0;

    performance.getEntriesByType('resource').map((resource) => {
        const data = resource.toJSON();
        totalTransferSize += data.transferSize;
    });

    return totalTransferSize;
};

async function getCarbonIntensity(location) {
    let forecast = await fetchData(location);
    let emissions = forecast.Emissions;
    let now = Date.now();
    for (let i = emissions.length - 1; i > 0; i--) {
        let rating = emissions[i].Rating;
        let time = Date.parse(emissions[i].Time);
        if (rating > 0 && now >= time) {
            return rating;
        }
    }
    return null;

}

async function fetchData(location) {
    let response = await fetch(`https://carbonawarecomputing.blob.core.windows.net/forecasts/${location}.json`);
    let data = await response.json();
    return data;

} 