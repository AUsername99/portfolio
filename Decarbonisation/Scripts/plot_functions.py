from carbonbase_func import *
import pandas as pd
import datetime as dt
import matplotlib.pyplot as plt
import matplotlib.axes as maxes
import matplotlib.transforms as mtrans

 
#carbon_data_now()
plt.close()
df = carbon_data_now()
df.plot(kind='bar', legend=False)
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('img0.png')
#plt.show()
 
#carbon_data_today()
plt.close()
df = carbon_data_today()
df.plot(x='to', legend=False)
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('img1.png')
#plt.show()
 
#carbon_data_date()
plt.close()
df = carbon_data_date(yr=2026,mn=6,dy=1)
df.plot(x='to', legend=False)
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('img2.png')
plt.show()
 
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
df = carbon_post_region_fw(post_region='SL2', yr=2026, mn=6, dy=1, fwh=48)
df['fuel_int'] = df['intensity.forecast'] * df['perc']/100
df['to_'] = df['to']
df = df[['fuel','fuel_int','to']].pivot(index='to',columns='fuel')
df.reset_index().plot(x='to',y='fuel_int', legend=False)
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('img12.png')
#plt.show()
 
#carbon_post_to()
plt.close()
carbon_post_to(yr=2026,mn=6,dy=1,post_region='SL2').plot(x='to',y='intensity.forecast')
plt.figure(1).set_figwidth(14)
plt.figure(1).legend(loc='upper right')
plt.figure(1).savefig('img13.png')
