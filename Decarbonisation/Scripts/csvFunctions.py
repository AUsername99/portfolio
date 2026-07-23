import pandas as pd
import numpy as np
import regex as re
import datetime as dt
import os

# Step 1) Gather CO2 of vehicles
# Step 2) Gather distance driven by vehicles
# Step 3) Relate the distance traveled with the CO2 produced

LOWERBOUNDS = {
    'A: 0':0,
    'B: 1 to 50':1,
    'C: 51 to 75':51,
    'D: 76 to 90':76,
    'E: 91 to 100':91,
    'F: 101 to 110':101,
    'G: 111 to 130':111,
    'H: 131 to 150':131,
    'I: 151 to 170':151,
    'J: 171 to 190':171,
    'K: 191 to 225':191,
    'L: 226 to 255':226,
    'M: 256+':256
    }
UPPERBOUNDS = {
    'A: 0':0,
    'B: 1 to 50':50,
    'C: 51 to 75':75,
    'D: 76 to 90':90,
    'E: 91 to 100':100,
    'F: 101 to 110':110,
    'G: 111 to 130':130,
    'H: 131 to 150':150,
    'I: 151 to 170':170,
    'J: 171 to 190':190,
    'K: 191 to 225':225,
    'L: 226 to 255':255,
    'M: 256+':300
}
VEHICLE_CO2 = 'Decarbonisation\\Data\\veh0105.csv'
JOIN_FILE = 'Decarbonisation\\Data\\Join_table_Region_Codes.csv'
VEHICLE_DISTANCE = 'Decarbonisation\\Data\\region_traffic_by_vehicle_type.csv'

# Step 1) Obtain the Carbon Emmissions per kilometer per vehicle type by region
# Data may not be sufficient due to not taking into account BodyType correctly
# Keeping function here just in case
def co2_of_vehicles_9901(csvFile: str = ''):
    df_vehicle = pd.read_csv(csvFile) # Imports data from CSV file
    df_vehicle = df_vehicle[df_vehicle.CO2_Band !='[x]'] # Removes unsuable lines (where CO2 emmissions rating is not there)
    df_vehicle = df_vehicle[~df_vehicle['ONS Code'].str.contains('K')] # Removes lines for entire country (where necessary)
    df_vehicle = df_vehicle[~df_vehicle['ONS Code'].str.contains('E92') | ~df_vehicle['ONS Code'].str.contains('S92') | ~df_vehicle['ONS Code'].str.contains('W92')]
    df_vehicle = df_vehicle.iloc[:,[0,5,6,7,8,9,10]] # Removes unnecessary columns
    df_vehicle['lowerBoundCO2'] = df_vehicle['CO2_Band'].map(LOWERBOUNDS) # Maps lowerbound values to each entry
    df_vehicle['upperBoundCO2'] = df_vehicle['CO2_Band'].map(UPPERBOUNDS) # Maps upperbound values to each entry
    df_vehicle = df_vehicle.reset_index() # Resets index for easier manipluation

    df_join = pd.read_csv(JOIN_FILE) # Imports Join Table
    df_join = df_join.iloc[:,[0,7]]
    df_join = df_join.set_index('ONS Code') # Sets index for joining

    dfV_joined = df_vehicle.join(df_join,on='ONS Code') # Joins region tables
    dfV_joined.loc[dfV_joined['ONS Code'].str.contains('W'), ['Parent_Code']] = 'W92000004' # Replaces NaN with Wales Code
    dfV_joined.loc[dfV_joined['ONS Code'].str.contains('S'), ['Parent_Code']] = 'S92000003' # Replaces NaN with Scotland Code
    dfV_joined.dropna(inplace=True) # Drops extras that were created
    dfV_joined.reset_index(inplace=True)
    dfV_joined = dfV_joined[dfV_joined.columns[2:]] # Removes extra columns created by index resets
    # V Combines Company and Private vehicle counts due to miles of each not being counted
    dfV_grouped = pd.DataFrame(dfV_joined.groupby(['ONS Code', 'BodyType', 'Fuel', 'CO2_Band', 'YearFirstReg', 'lowerBoundCO2', 'upperBoundCO2', 'Parent_Code'])[dfV_joined.columns[6]].sum())
    dfV_grouped.reset_index(inplace=True) # Flattens data again
    return dfV_grouped

# Step 1) Obtain the Carbon Emmissions per kilometer per vehicle type by region
def co2_of_vehicles(csvFile: str = ''):
    df_vehicle = pd.read_csv(csvFile)
    df_vehicle = df_vehicle[df_vehicle['ONS Code'] !='[z]']
    df_vehicle = df_vehicle[~df_vehicle['ONS Code'].str.contains('K')] # Removes lines for entire country (where necessary)
    df_vehicle = df_vehicle[~df_vehicle['ONS Code'].str.contains('E92') & ~df_vehicle['ONS Code'].str.contains('S92') & ~df_vehicle['ONS Code'].str.contains('W92')]
    df_vehicle = df_vehicle[~df_vehicle['ONS Code'].str.contains('N')]
    df_vehicle = df_vehicle[~df_vehicle['ONS Code'].str.contains('E12')]
    df_vehicle.replace('[low]',0.05, inplace=True)
    df_vehicle.replace('[x]',0.0, inplace=True)
    df_vehicle.reset_index(inplace=True)
    df_vehicle = df_vehicle[df_vehicle.columns[1:]]

    dfV_Long = pd.melt(df_vehicle, id_vars=df_vehicle.columns.to_list()[:6], value_vars=df_vehicle.columns.to_list()[7:])
    dfV_Long['adjusted_vehicle'] = dfV_Long['value'].astype('float')
    dfV_Long['vehicles'] = dfV_Long['adjusted_vehicle']*1000
    dfV_Long = dfV_Long.iloc[:,[1,2,3,4,5,6,9]]
    return dfV_Long


# Step 2) Obtain total distance travelled over time per vehicle type by region
def vehicleDistance(csvFile: str = ''):
    df_distance = pd.read_csv(csvFile) # Imports data from CSV file
    df_distance = df_distance.iloc[:,[0,2,3,7,8,9,10,11]] # Removes unnecessary columns
    df_distance['id'] = df_distance['region_ons_code'] + '-' + df_distance['year'].astype('str')
    df_distance = pd.melt(df_distance, id_vars=['region_ons_code', 'year'], value_vars=['two_wheeled_motor_vehicles', 'cars_and_taxis', 'buses_and_coaches', 'LGVs', 'all_HGVs'])
    df_distance['value'].astype('float64') # Change value to float
    df_distance['value'] = df_distance['value']*1.609344 # Change distance from miles to km
    df_distance.rename(columns={'region_ons_code':'Parent_Code', 'variable':'BodyType', 'value':'kilometers'}, inplace=True) # Rename columns so they can be joined
    return df_distance

# Step 3) Relate distance Travelled with CO2 Produced
def co2_combo(co2_df: pd.DataFrame, distance_df: pd.DataFrame):

    return

if __name__ == '__main__':
    print(co2_of_vehicles(VEHICLE_CO2).head())
    co2_of_vehicles(VEHICLE_CO2).to_csv('test1.csv')
    print(vehicleDistance(VEHICLE_DISTANCE).head())
    vehicleDistance(VEHICLE_DISTANCE).to_csv('test2.csv')
    #print(vehicleDistance(VEHICLE_DISTANCE).info())