# Decarbonisation
---
## Summary
This is my collection of carbon tracking scripts, data points and documentation. The aim of this is to help others make data driven decisions on what to focus on regarding the reduction of carbon emmissions.

At the moment it is just restricted to within the UK but I do have plans to expand this to measure other countries' carbon emmissions in detail too.

Another reason I want to track this is also to see how many data sources I can coalate together and this was something that I am passionate about personally.

---

### UK Carbon Intensity API
This is the first instance of the carbon tracking I looked into after doing some reasearch online.

The UK Carbon API tracks the carbon emmissions per kilowatt hour (kWh) in grams. It breaks it down by region and generation type every 30 mins. See some of the functions in the visualisations below.

#### - Carbon Data Now:
This is the carbon data at the 30 min block you requested the information. It has a predicted value and an actual value.

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