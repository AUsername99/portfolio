from carbonbase_func import *
import pandas as pd
import numpy as np
import datetime
import matplotlib.pyplot as plt
import calendar
import random

'''
This is the script that runs to generate the visualisations with the latest data.

At the moment this usually takes about 50 seconds, depending on internet connection and computer processing speeds
'''

date_string = str(datetime.date.today())
year, month, day = map(int, date_string.split("-"))
num_days = calendar.monthrange(year, month)[1]

time_string = str(datetime.datetime.now().time())

fuelTypeNames = {
    'COAL':'coal',
    'CCGT':'ccgt',
    'OCGT':'ocgt',
    'NUCLEAR':'nuclear',
    'OIL':'oil',
    'WIND':'wind',
    'NPSHYD':'hydro',
    'PS':'pumped',
    'BIOMASS':'biomass',
    'BESS':'battery',
    'OTHER':'other',
    'INTFR':'ifa',
    'INTIRL':'moyle',
    'INTNED':'britned',
    'INTEW':'ewic',
    'INTNEM':'nemo',
    'INTIFA2':'ifa2',
    'INTNSL':'nsl',
    'INTELEC':'eleclink',
    'INTVKL':'viking',
    'INTGRNL':'greenlink'
    }

#carbon_data_now()
plt.close()
df1 = carbon_data_now()
df1.plot(kind='bar', legend=False, ylabel='Carbon Intensity (g/kWh)', title=f'Carbon Data Now {year}-{month}-{day} {time_string}')
plt.figure(1).legend(loc='upper right', ncol=2)
plt.figure(1).savefig('Decarbonisation\\Data\\Visualisations\\Current Carbon Data.png')

#carbon_data_today()
plt.close()
df2 = carbon_data_today()
df2.plot(x='to', legend=False, xlabel='time', ylabel='Carbon Intensity (g/kWh)')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right', ncol=2)
plt.figure(1).savefig('Decarbonisation\\Data\\Visualisations\\Carbon Data Now.png')

#carbon_data_date()
plt.close()
i = 1
while i <= num_days:
    df3 = carbon_data_date(yr=year, mn=month, dy=i, df=True)
    if not df3.empty:
        if i == 1:
            df0 = df3
        else:
            frames = [df0, df3]
            df0 = pd.concat(frames)
    i = i + 1
df0.plot(x='to', legend=False, xlabel='Time', ylabel='Carbon Intensity (g/kWh)', title='Carbon Data over the next month')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right', labels=['Forecast', 'Actual'], ncol=2)
plt.figure(1).savefig('Decarbonisation\\Data\\Visualisations\\Carbon Data Selected Date.png')
#plt.show()

#carbon_date_time()
plt.close()
df4_0 = carbon_date_time(yr=year, mn=month, dy=1, hr=1, min=0)
df4_1 = carbon_date_time(yr=year, mn=month, dy=1, hr=12, min=0)
df4_2 = carbon_date_time(yr=year, mn=month, dy=1, hr=19, min=0)
df4 = pd.concat([df4_0, df4_1, df4_2])

fig, ax = plt.subplots(layout='constrained')
df4 = df4[['intensity.forecast', 'intensity.actual']]
res = ax.grouped_bar(df4, tick_labels=(f'{year}-{month}-1 01:00',f'{year}-{month}-1 12:00',f'{year}-{month}-1 19:00'), group_spacing=1)
for container in res.bar_containers:
    ax.bar_label(container, padding=3)

ax.set_ylabel('Carbon Intensity (g/kWh)')
ax.set_title(f'Carbon Data For {year}-{month}-1')
ax.legend(loc='upper right', ncols=2)
ax.set_ybound(upper=(df4.max(axis=None, numeric_only=True)+df4.max(axis=None, numeric_only=True)*0.2))
plt.figure(1).savefig('Decarbonisation\\Data\\Visualisations\\Carbon Data Select Time.png')

plt.close()
df5_0 = carbon_date_time(yr=(year-2), mn=month, dy=1, hr=12, min=0)
df5_1 = carbon_date_time(yr=(year-1), mn=month, dy=1, hr=12, min=0)
df5_2 = carbon_date_time(yr=year, mn=month, dy=1, hr=12, min=0)
df5 = pd.concat([df5_0, df5_1, df5_2])

fig, ax = plt.subplots(layout='constrained')
df5 = df5[['intensity.forecast', 'intensity.actual']]
res = ax.grouped_bar(df5, tick_labels=(f'{year-2}-{month}-1 12:00',f'{year-1}-{month}-1 12:00',f'{year}-{month}-1 12:00'), group_spacing=1)
for container in res.bar_containers:
    ax.bar_label(container, padding=3)

ax.set_ylabel('Carbon Intensity (g/kWh)')
ax.set_title(f'Carbon Data For {year}, {year-1} & {year-2} for {month}-1')
ax.legend(loc='upper right', ncols=2)
ax.set_ybound(upper=(df5.max(axis=None, numeric_only=True)+df5.max(axis=None, numeric_only=True)*0.2))
plt.figure(1).savefig('Decarbonisation\\Data\\Visualisations\\Carbon Data Select Time2.png')
 
#carbon_post_region_fw()
plt.close()
post_ref = random.randrange(1,2921)
with open('Decarbonisation\\Data\\postcodes.txt', 'r', encoding='utf-8') as postcodes:
    postcode = postcodes.readlines()
df6 = carbon_post_region_fw(post_region=postcode[post_ref].strip(), yr=year, mn=month, dy=day, fwh=48)
df6['carbon_perc'] = np.where(df6['fuel'] == 'biomass', df6['perc'], np.where(df6['fuel'] == 'gas', df6['perc'], np.where(df6['fuel'] == 'imports', df6['perc'], np.where(df6['fuel'] == 'other', df6['perc'], np.where(df6['fuel'] == 'coal', df6['perc'], 0)))))
df6_sum = pd.DataFrame({'to':df6.groupby(df6['to'])['carbon_perc'].sum().index, 'carbs':df6.groupby(df6['to'])['carbon_perc'].sum().values})
df6 = df6.join(df6_sum.set_index('to'), on='to')
df6['fuel_int'] = df6['intensity.forecast'] * df6['carbon_perc']/df6['carbs']
df6['to_'] = df6['to']
df6 = df6[['fuel','fuel_int','to']].pivot(index='to',columns='fuel')
df6.reset_index().plot(x='to',y='fuel_int', legend=False, xlabel='Time', ylabel='Predicted Carbon Intensity (g/kWh)', title=f'Predicted Carbon Intensity over time for {postcode[post_ref].strip()} across generation methods')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Visualisations\\Predicted Carbon Intensity Postcode.png')

plt.close()
post_ref = random.randrange(1,2921)
with open('Decarbonisation\\Data\\postcodes.txt', 'r', encoding='utf-8') as postcodes:
    postcode = postcodes.readlines()
df7 = carbon_post_region_fw(post_region=postcode[post_ref].strip(), yr=year, mn=month, dy=day, fwh=48)
df7['carbon_perc'] = np.where(df7['fuel'] == 'biomass', df7['perc'], np.where(df7['fuel'] == 'gas', df7['perc'], np.where(df7['fuel'] == 'imports', df7['perc'], np.where(df7['fuel'] == 'other', df7['perc'], np.where(df7['fuel'] == 'coal', df7['perc'], 0)))))
df7_sum = pd.DataFrame({'to':df7.groupby(df7['to'])['carbon_perc'].sum().index, 'carbs':df7.groupby(df7['to'])['carbon_perc'].sum().values})
df7 = df7.join(df7_sum.set_index('to'), on='to')
df7['fuel_int'] = df7['intensity.forecast'] * df7['carbon_perc']/df7['carbs']
df7['to_'] = df7['to']
df7 = df7[['fuel','fuel_int','to']].pivot(index='to',columns='fuel')
df7.reset_index().plot(x='to',y='fuel_int', legend=False, xlabel='Time', ylabel='Predicted Carbon Intensity (g/kWh)', title=f'Predicted Carbon Intensity over time for {postcode[post_ref].strip()} across generation methods')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Visualisations\\Predicted Carbon Intensity Postcode1.png')

plt.close()
post_ref = random.randrange(1,2921)
with open('Decarbonisation\\Data\\postcodes.txt', 'r', encoding='utf-8') as postcodes:
    postcode = postcodes.readlines()
df8 = carbon_post_region_fw(post_region=postcode[post_ref].strip(), yr=year, mn=month, dy=day, fwh=48)
df8['carbon_perc'] = np.where(df8['fuel'] == 'biomass', df8['perc'], np.where(df8['fuel'] == 'gas', df8['perc'], np.where(df8['fuel'] == 'imports', df8['perc'], np.where(df8['fuel'] == 'other', df8['perc'], np.where(df8['fuel'] == 'coal', df8['perc'], 0)))))
df8_sum = pd.DataFrame({'to':df8.groupby(df8['to'])['carbon_perc'].sum().index, 'carbs':df8.groupby(df8['to'])['carbon_perc'].sum().values})
df8 = df8.join(df8_sum.set_index('to'), on='to')
df8['fuel_int'] = df8['intensity.forecast'] * df8['carbon_perc']/df8['carbs']
df8['to_'] = df8['to']
df8 = df8[['fuel','fuel_int','to']].pivot(index='to',columns='fuel')
df8.reset_index().plot(x='to',y='fuel_int', legend=False, xlabel='Time', ylabel='Predicted Carbon Intensity (g/kWh)', title=f'Predicted Carbon Intensity over time for {postcode[post_ref].strip()} across generation methods')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Visualisations\\Predicted Carbon Intensity Postcode2.png')

#carbon_post_to()
plt.close()
post_ref = random.randrange(1,2921)
date_string = str(datetime.date.today()-datetime.timedelta(days=14))
year, month, day = map(int, date_string.split("-"))
num_days = calendar.monthrange(year, month)[1]
df9 = carbon_post_to(yr=year,mn=month,dy=day,post_region=postcode[post_ref].strip(),to=13)
df9.plot(x='to',y='intensity.forecast', xlabel='Time', legend=False, ylabel='Predicted Carbon Intensity (g/kWh)', title=f'Predicted Carbon Intensity over time for {postcode[post_ref].strip()}')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right', ncol=2)
plt.figure(1).savefig('Decarbonisation\\Data\\Visualisations\\Predicted Carbon Intensity Postcode3.png')

#fueltype_demand()
plt.close()
df10 = fueltype_demand()
df10.replace(inplace=True, to_replace=fuelTypeNames)
df10_pivot = pd.pivot_table(df10, values='outputUsable', index=['forecastDate'], columns=['fuelType'])
df10_pivot.plot(legend=False, ylabel='Generation Units')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Visualisations\\fueltypeDemand.png')

#energy_demand()
plt.close()
df11 = energy_demand()
df11 = df11[['startTime', 'initialDemandOutturn', 'initialTransmissionSystemDemandOutturn']]
df11.plot(legend=False, x='startTime', ylabel='Demand in MegaWatts (MW)')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Visualisations\\Energy Demand.png')

#temp_data()
plt.close()
df12 = temp_data()
df12.plot(x='measurementDate', y='temperature', legend=False)
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Visualisations\\Temperature over Time.png')