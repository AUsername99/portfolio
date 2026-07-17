from carbonbase_func import *
import pandas as pd
import numpy as np
import datetime
import matplotlib.pyplot as plt
import matplotlib.axes as maxes
import matplotlib.transforms as mtrans
import datetime as dt
import calendar
import random

'''
This is the script that runs to generate the visualisations with the latest data
'''

date_string = str(datetime.date.today())
year, month, day = map(int, date_string.split("-"))
num_days = calendar.monthrange(year, month)[1]

#carbon_data_now()
plt.close()
df1 = carbon_data_now()
df1.plot(kind='bar', legend=False)
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Current Carbon Data.png')
#plt.show()
 
#carbon_data_today()
plt.close()
df2 = carbon_data_today()
df2.plot(x='to', legend=False)
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Carbon Data Now.png')
#plt.show()
 
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
df4 = carbon_post_region_fw(post_region='SL2', yr=year, mn=month, dy=day, fwh=48)
df4['carbon_perc'] = np.where(df4['fuel'] == 'biomass', df4['perc'], np.where(df4['fuel'] == 'gas', df4['perc'], np.where(df4['fuel'] == 'imports', df4['perc'], np.where(df4['fuel'] == 'other', df4['perc'], np.where(df4['fuel'] == 'coal', df4['perc'], 0)))))
df4_sum = pd.DataFrame({'to':df4.groupby(df4['to'])['carbon_perc'].sum().index, 'carbs':df4.groupby(df4['to'])['carbon_perc'].sum().values})
df4.set_index('to').join(df4_sum.set_index('to'))
print(df4.groupby(df4['to'])['carbon_perc'].sum())
df4['fuel_int'] = df4['intensity.forecast'] * df4['carbon_perc']/np.where(df4.groupby(df4['to'])['carbon_perc'].sum() == df4['to'], df4.groupby(df4['to'])['carbon_perc'].sum()[1], 1)
df4.to_csv("test.csv")
df4['to_'] = df4['to']
df4 = df4[['fuel','fuel_int','to']].pivot(index='to',columns='fuel')
df4.reset_index().plot(x='to',y='fuel_int', legend=False, xlabel='Time', ylabel='Predicted Carbon Intensity (g/kWh)', title=f'Predicted Carbon Intensity over time for {postcode[post_ref].strip()} across generation methods')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Predicted Carbon Intensity Postcode.png')
#plt.show()
 
#carbon_post_to()
plt.close()
post_ref = random.randrange(1,2921)
date_string = str(datetime.date.today()-datetime.timedelta(days=14))
year, month, day = map(int, date_string.split("-"))
num_days = calendar.monthrange(year, month)[1]
df5 = carbon_post_to(yr=year,mn=month,dy=day,post_region=postcode[post_ref].strip(),to=13)
df5.plot(x='to',y='intensity.forecast', title=f'Predicted Carbon Intensity over time for {postcode[post_ref].strip()}')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('Decarbonisation\\Data\\Predicted Carbon Intensity Postcode2.png')
