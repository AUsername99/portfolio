import requests
import pandas as pd
import datetime as dt

'''
WORK IN PROGRESS:

This is a set of functions to extract information for the UK energy generation.

Data Source: https://developer.data.elexon.co.uk/api-details#api=prod-insol-insights-api&operation

Credits:
    - https://grid.iamkate.com/
    - https://github.com/KateMorley/grid

'''

BASE_URL = 'https://data.elexon.co.uk/bmrs/api/v1/'
