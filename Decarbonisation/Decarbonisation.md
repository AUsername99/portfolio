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

![Current Carbon Data](relative%20/Decarbonisation/Data/Current Carbon Data.png?raw=true)

#### - Carbon Data Today:
This is the carbon data tracked across the current day (date it was measured). It has a predicted value for each 30 min interval and tracks the actual value once it is measured

![Carbon Data Now](relative%20Decarbonisation/Data/Carbon Data Now.png?raw=true)

#### - Carbon Data of a selected date:
The API also has access to previous days where the carbon data was recorded. The data is recorded back to 2017-09-12.

![Carbon Data Selected Date](relative%20Decarbonisation/Data/Carbon Data Selected Date.png?raw=true)