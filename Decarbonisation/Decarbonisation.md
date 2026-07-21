# Decarbonisation

---

## Summary
This is my collection of carbon tracking scripts, data points and documentation. The aim of this is to track with as much detail as possible how much carbon the UK is producing, how much it is offset by through national and international objectives and to allow others to take these data sources and make data driven descisions on what the UK can focus on when it comes to reducing carbon emmissions.

At the moment I have intergrated (or in the process of intergrating) API endpoints for electricity generation with plans for adding in statisitcs of transportation (private and commercial), forestry data as well as other points of measure including air quality and average temperature across the UK.

Hopefully, with enough data sources and research, this project can expand to measure other countries' carbon emmissions in detail.

A lot of the resources for energy generation data is taken from the sources of Kate Morley's dashboard. This dashboard tracks carbon emmissions and cost of the energy generated in the UK and refeshes every 30 mins. So I must give credit and a big thank you to Kate for making the dashboard open source and have all the links and resources available, it is very much appreciated. The link for said dashboard is below.

The list of resources and where I get them from and/or their documentations are linked at the bottom of this page.

I've set this page up so everytime I run the [plot_functions.py](Scripts\plot_functions.py), it will fetch a new set of data from the APIs it connects to and refreshes this page and the [Markdown Documents in the Visualisations directories](Decarbonisation\Visualisations\Visualisations.md) which (will) have more detailed visualisations.

---

## Contents:

Initial Data Sources
1) [UK Carbon Intensity API](#uk-carbon-intensity-api)
2) [UK Energy Production API](#uk-energy-production)
3) [Sources](#sources)

---

### UK Carbon Intensity API
This is the first instance of the carbon tracking I looked into after doing some reasearch online.

The UK Carbon API tracks the carbon emmissions per kilowatt hour (kWh) in grams (or gCO2/kWh). It breaks it down by region and generation type every 30 mins. See some examples of some of the functions in the visualisations below.

Note this does not include the amount of energy produced, only how much carbon is generated per unit of energy from the power stations.

#### - Carbon Data Now:
This is the carbon data at the 30 min block you requested the information. It has a predicted value and an actual value for the entire UK.

![Current Carbon Data](<Data/Visualisations/Current Carbon Data.png>)

Note this does not necessarily mean every kWh you use produces this much CO2, only that on average the UK produces this much per kWh. As you will see further down, the intensity is broken down by area.

#### - Carbon Data Today:
This is the carbon data tracked across the current day (date it was measured). It has a predicted value for each 30 min interval and tracks the actual value once it is measured. This is mainly the carbon data now function but just across the entire day.

![Carbon Data Now](<Data/Visualisations/Carbon Data Now.png>)

#### - Carbon Data of a selected date:
The API also has access to previous days where the carbon data was recorded. The data is recorded back to 2017-09-12 and has been recorded every day since. It can also show the predicted values for up to the next 3 days as well.

![Carbon Data Selected Date](<Data/Visualisations/Carbon Data Selected Date.png>)

#### - Carbon Data of a selected date & time:
As well as previous dates, it can also focus in on certain 30 min blocks, meaning you can compare different times on the same day or different days but at the same time as well.

![Carbon Data Selected Time](<Data/Visualisations/Carbon Data Select Time.png>)

![Carbon Data Selected Time 2](<Data/Visualisations/Carbon Data Select Time2.png>)

#### - Carbon Data of an entire postcode:
All of the power generation and carbon intensity is measured against the regions of Great Britain and all of the postcodes in those areas are tied to it as well. All the postcodes in those regions have the exact same data as the region as a whole, making that level of detail not as meaningful as it could be but it is nice to be able to see how carbon intense your own postcode is.

I've made a couple of quick graphs that shows the breakdown of the predicted carbon intensity over the course of a day in a postcode that is randomly chosen from. One of more of these graphs may be empty if it is drawing data from a postcode from the north of Scotland, as their power generation pretty much comes all from wind, which produces 0gCO2/kWh.

![Predicted Carbon Intensity Postcode](<Data/Visualisations/Predicted Carbon Intensity Postcode.png>)

![Predicted Carbon Intensity Postcode](<Data/Visualisations/Predicted Carbon Intensity Postcode1.png>)

![Predicted Carbon Intensity Postcode](<Data/Visualisations/Predicted Carbon Intensity Postcode2.png>)

This can also be done for an up to (almost) 14 day period as well:

![Predicted Carbon Intensity Postcode2](<Data/Visualisations/Predicted Carbon Intensity Postcode3.png>)

---

### UK Energy Production

The UK Energy Production API is an API that tracks a multitude of data directly or indirectly related to the energy production within the UK.

There are a plethora GET requests, of which can fetch massive data sets but for the purposes of this page, I will be using 3 of them.

#### - Energy Demand:

The first one is the Initial National Demand outturn which measures the half an hour average megawatt (MW) demand metered by the Transmission Company. This is the data I will be using to normalise against the carbon intensity from the grid.

![Energy Demand](<Data/Visualisations/Energy Demand.png>)

The downside to this is that it does not take into account location of the demand. To rectify this I will need to assume the demand is even across each region and divide the total demand by the number of regions (of which there are 18 of them).

#### - Fuel Type Demand:

Similar to the fuel types of the Carbon Intensity API, this tracks the actual demand of each fuel type across the power grid in MW every 30 mins.

![Fuel Type Demand](<Data/Visualisations/fueltypeDemand.png>)

Similar to the energy demand API endpoint, it does not give specific locations for each fuel type demand, making this tricky to normalise the data against.

#### - Temperature Data:

The third one is the temperature data for the UK, as recorded by 6 weather stations across Great Britain. This is more of an API to show how much the UK is heating up over the timeperiod that this has been recording for.

![Temperature over Time](<Data/Visualisations/Temperature over Time.png>)

---

### Further improvements

Tracking and centralising all of this data is good for being able to see how much CO2 and other gases the UK is actually producing on a daily, monthly and yearly level but since Climate Change isn't a country by country issue, it becomes hard to see how much the UK is actually impacting the environment as a whole. If I had the exact same data outputs from every other country in the world then it would be a lot easier to measure said fact.

There is a possible way by normalising this data to the estimated amount of greenhouse gases in the atmosphere and removing the amount added in from natural disaters (at least the ones not derived from climate change that is).

---

### Sources

Carbon Intensity API: https://carbon-intensity.github.io/api-definitions/?python#carbon-intensity-api-v2-0-0
UK Energy Production API: https://developer.data.elexon.co.uk/api-details
NO2 Statistics: https://www.gov.uk/government/statistics/air-quality-statistics/ntrogen-dioxide
Vehicle Data:https://www.gov.uk/government/statistical-data-sets/vehicle-licensing-statistics-data-tables
Kate Morley's Live Dashboard: https://grid.iamkate.com/