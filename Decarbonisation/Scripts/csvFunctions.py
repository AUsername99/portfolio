import pandas as pd
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
FILENAME = 'Decarbonisation\\Data\\veh9901.csv'

# Step 1)
def co2_of_vehicles(csvFile: str = ''):
    df_vehicle = pd.read_csv(csvFile)
    df_vehicle = df_vehicle[df_vehicle.CO2_Band !='[x]']
    df_vehicle['lowerBoundCO2'] = df_vehicle['CO2_Band'].map(LOWERBOUNDS)
    df_vehicle['upperBoundCO2'] = df_vehicle['CO2_Band'].map(UPPERBOUNDS)

# Step 2)

# Step 3)

if __name__ == '__main__':
    co2_of_vehicles(FILENAME)