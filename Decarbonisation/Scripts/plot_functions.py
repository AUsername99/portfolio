from carbonbase_func import *
import pandas as pd
import numpy as np
import datetime
import matplotlib.pyplot as plt
import calendar
import random

'''
This is the script that runs to generate the visualisations with the latest data
'''

date_string = str(datetime.date.today())
year, month, day = map(int, date_string.split("-"))
num_days = calendar.monthrange(year, month)[1]

time_string = str(datetime.datetime.now().time())

#carbon_data_now()
plt.close()
df1 = carbon_data_now()
df1.plot(kind='bar', legend=False, ylabel='Carbon Intensity (g/kWh)', title=f'Carbon Data Now {year}-{month}-{day} {time_string}')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Current Carbon Data.png')

 
#carbon_data_today()
plt.close()
df2 = carbon_data_today()
df2.plot(x='to', legend=False, xlabel='time', ylabel='Carbon Intensity (g/kWh)')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Carbon Data Now.png')

 
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
plt.figure(1).legend(loc='upper right', labels=['Forecast', 'Actual'])
plt.figure(1).savefig('Decarbonisation\\Data\\Carbon Data Selected Date.png')
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
plt.figure(1).savefig('Decarbonisation\\Data\\Carbon Data Select Time.png')

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
plt.figure(1).savefig('Decarbonisation\\Data\\Carbon Data Select Time2.png')

#carbon_factors()

#carbon_from()
 
#carbon_pt24h()
 
#carbon_to()
 
#carbon_to_block()
 
#carbon_regional()
 
#carbon_postcode()
 
#carbon_region_fw()
 
#carbon_post_region_fw()
plt.close()
carbon_fuels = ['biomass', 'coal', 'gas', 'imports', 'other']
post_ref = random.randrange(1,2921)
with open('Decarbonisation\\Data\\postcodes.txt', 'r', encoding='utf-8') as postcodes:
    postcode = postcodes.readlines()
df4 = carbon_post_region_fw(post_region=postcode[post_ref].strip(), yr=year, mn=month, dy=day, fwh=48)
df4['carbon_perc'] = np.where(df4['fuel'] == 'biomass', df4['perc'], np.where(df4['fuel'] == 'gas', df4['perc'], np.where(df4['fuel'] == 'imports', df4['perc'], np.where(df4['fuel'] == 'other', df4['perc'], np.where(df4['fuel'] == 'coal', df4['perc'], 0)))))
df4_sum = pd.DataFrame({'to':df4.groupby(df4['to'])['carbon_perc'].sum().index, 'carbs':df4.groupby(df4['to'])['carbon_perc'].sum().values})
df4 = df4.join(df4_sum.set_index('to'), on='to')
df4['fuel_int'] = df4['intensity.forecast'] * df4['carbon_perc']/df4['carbs']
df4['to_'] = df4['to']
df4 = df4[['fuel','fuel_int','to']].pivot(index='to',columns='fuel')
df4.reset_index().plot(x='to',y='fuel_int', legend=False, xlabel='Time', ylabel='Predicted Carbon Intensity (g/kWh)', title=f'Predicted Carbon Intensity over time for {postcode[post_ref].strip()} across generation methods')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Predicted Carbon Intensity Postcode.png')

 
#carbon_post_to()
plt.close()
post_ref = random.randrange(1,2921)
date_string = str(datetime.date.today()-datetime.timedelta(days=14))
year, month, day = map(int, date_string.split("-"))
num_days = calendar.monthrange(year, month)[1]
df5 = carbon_post_to(yr=year,mn=month,dy=day,post_region=postcode[post_ref].strip(),to=13)
df5.plot(x='to',y='intensity.forecast', xlabel='Time', ylabel='Predicted Carbon Intensity (g/kWh)', title=f'Predicted Carbon Intensity over time for {postcode[post_ref].strip()}')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Predicted Carbon Intensity Postcode2.png')
