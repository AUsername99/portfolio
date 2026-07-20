# Decarbonisation

---

## Summary
This is my collection of carbon tracking scripts, data points and documentation. The aim of this is to help others make data driven decisions on what to focus on regarding the reduction of carbon emmissions. This would be from emmissions from power generation methods, of which there are numoerous APIs for this, to tracking data from live datasets given by the government or third party sources. I have a list of them that is ever growing and will be added to this list as I link them here.

At the moment it is just restricted to within the UK but I do have plans to expand this to measure other countries' carbon emmissions in detail too (where there is data that is).

Another reason I want to track this is also to see how many data sources I can coalate together and this was and still is something that I am passionate about personally.

A lot of the resources for energy generation data is taken from the sources of Kate Morley's dashboard. This dashboard tracks carbon emmissions and cost of the energy generated in the UK and refeshes every 30 mins. It is something that I wanted to do in Python but on a larger scale. So I must give credit and a big thank you to Kate for making the dashboard open source and have all the links and resources available, it is very much appreciated. The link for said dashboard is below.

The list of resources and where I get them from and/or their documentations are linked at the bottom of this page.

---

I've set this page up so everytime I run the [plot_functions.py](Scripts\plot_functions.py), it will fetch a new set of data from the APIs it connects to and refreshes this page and the [Markdown Documents in the Visualisations directories](Decarbonisation\Visualisations\Visualisations.md).

---

## Contents:

1) [UK Carbon Intensity API](#uk-carbon-intensity-api)
2) [UK Energy Production API](#uk-energy-production)
3) [Sources](#sources)


### UK Carbon Intensity API
This is the first instance of the carbon tracking I looked into after doing some reasearch online.

The UK Carbon API tracks the carbon emmissions per kilowatt hour (kWh) in grams (or gCO2/kWh). It breaks it down by region and generation type every 30 mins. See some examples of some of the functions in the visualisations below.

Note this does not include the amount of energy produced, only how much carbon is generated per unit of energy from the power stations.

#### - Carbon Data Now:
This is the carbon data at the 30 min block you requested the information. It has a predicted value and an actual value for the entire UK.

![Current Carbon Data](<Data/Current Carbon Data.png>)

#### - Carbon Data Today:
This is the carbon data tracked across the current day (date it was measured). It has a predicted value for each 30 min interval and tracks the actual value once it is measured

![Carbon Data Now](<Data/Carbon Data Now.png>)

#### - Carbon Data of a selected date:
The API also has access to previous days where the carbon data was recorded. The data is recorded back to 2017-09-12 and has been recorded every day since.

![Carbon Data Selected Date](<Data/Carbon Data Selected Date.png>)

#### - Carbon Data of a selected date & time:
As well as previous dates, it can also focus in on certain 30 min blocks, meaning you can compare different times on the same day or different days but at the same time as well.

![Carbon Data Selected Time](<Data/Carbon Data Select Time.png>)

![Carbon Data Selected Time 2](<Data/Carbon Data Select Time2.png>)

#### - Carbon Data of an entire postcode:
All of the power generation and carbon intensity is measured against the regions of Great Britain and all of the postcodes in those areas are tied to it as well. All the postcodes in those regions have the exact same data as the region as a whole, making that level of detail not as meaningful as it could be but it is nice to be able to see how carbon intense your own postcode is.

I've made a quick graph that shows the breakdown of the predicted carbon intensity over the course of a day in a postcode that is randomly chosen from. This graph may be empty if it is one from the north of Scotland as their power generation all comes from wind, which produces 0gCO2/kWh.

![Predicted Carbon Intensity Postcode](<Data/Predicted Carbon Intensity Postcode.png>)

This can also be done for an up to (almost) 14 day period as well:

![Predicted Carbon Intensity Postcode2](<Data/Predicted Carbon Intensity Postcode2.png>)

---

### UK Energy Production

This is a work in progress at the moment while I construct the base functions to put into the plotting file.

---

### Sources

Carbon Intensity API: https://carbon-intensity.github.io/api-definitions/?python#carbon-intensity-api-v2-0-0
Kate Morley's Live Dashboard: https://grid.iamkate.com/