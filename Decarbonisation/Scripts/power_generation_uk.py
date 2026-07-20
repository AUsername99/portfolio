import requests
import pandas as pd
import datetime as dt

'''
WORK IN PROGRESS:

This ~~is~~ will be a set of functions to extract information for the UK energy generation.

Data Source: https://developer.data.elexon.co.uk/api-details

Credits:
    - https://grid.iamkate.com/
    - https://github.com/KateMorley/grid

'''

BASE_URL = 'https://data.elexon.co.uk/bmrs/api/v1/'

# Base Get & Error Check functions

response = requests.get(url= BASE_URL, params={})
if response.status_code == 200:
    data = response.json()

print(data)

# Request Shells

# To Do List:
# 1) Work out general get function
# 2) Determine error checks
# 3) Construct Request Shells
# 4) Create plotting functions
# 5) Create more detailed plotting functions

# Balance Mechanism Dynamic:
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/dynamic?bmUnit={bmUnit}&snapshotAt={snapshotAt}[&until][&snapshotAtSettlementPeriod][&untilSettlementPeriod][&dataset][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/dynamic/dynamicParameters?bmUnit={bmUnit}&from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&dataset][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/dynamic/all?settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&bmUnit][&dataset][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/dynamic/dynamicParameters/all?settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&bmUnit][&dataset][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/dynamic/rates/all?settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&bmUnit][&dataset][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/dynamic/rates?bmUnit={bmUnit}&snapshotAt={snapshotAt}[&until][&snapshotAtSettlementPeriod][&untilSettlementPeriod][&dataset][&format]

# Balance Mechanism Physical:
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/physical/all?dataset={dataset}&settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/physical?bmUnit={bmUnit}&from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&dataset][&format]

# Balance Services Adjustment - Disaggregated:
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/nonbm/disbsad/details?settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/nonbm/disbsad/summary?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&format]

# Balance Services Adjustment - Net:
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/nonbm/netbsad/events?count={count}[&before][&settlementPeriodBefore][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/nonbm/netbsad?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&includeZero][&format]

# Bid-Offer:
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/bid-offer?bmUnit={bmUnit}&from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/bid-offer/all?settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&bmUnit][&format]

# Bid-Offer Acceptances:
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/acceptances/{acceptanceNumber}[?format]
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/acceptances?bmUnit={bmUnit}&from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/acceptances/all/latest[?format]
# - https://data.elexon.co.uk/bmrs/api/v1/balancing/acceptances/all?settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&bmUnit][&format]

# BMRS Datasets:
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/UOU2T14D[?fuelType][&publishDateTimeFrom][&publishDateTimeTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/UOU2T14D/stream[?fuelType][&publishDateTimeFrom][&publishDateTimeTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/FOU2T14D[?fuelType][&publishDate][&publishDateTimeFrom][&publishDateTimeTo][&biddingZone][&interconnector][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NOU2T14D[?publishDate][&publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/UOU2T3YW[?fuelType][&publishDateTimeFrom][&publishDateTimeTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/UOU2T3YW/stream[?fuelType][&publishDateTimeFrom][&publishDateTimeTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/FOU2T3YW[?fuelType][&publishDate][&publishDateTimeFrom][&publishDateTimeTo][&week][&year][&biddingZone][&interconnector][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NOU2T3YW[?publishDate][&publishDateTimeFrom][&publishDateTimeTo][&week][&year][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/OCNMFD2[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/OCNMFD2/stream[?publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/OCNMFD[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/OCNMFD/stream[?publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NDFD[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NDFD/stream[?publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/TSDFD[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/TSDFD/stream[?publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/OCNMF3Y2[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/OCNMF3Y2/stream[?publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/OCNMF3Y[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/OCNMF3Y/stream[?publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NDFW[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NDFW/stream[?publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/TSDFW[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/TSDFW/stream[?publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/AOBE?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/AOBE/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/AGPT?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/AGPT/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/B1610?settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/B1610/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/AGWS?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/AGWS/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/ATL?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/ATL/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/ABUC?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/ABUC/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/BEB?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/BEB/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/QAS?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/QAS/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/BOALF?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/BOALF/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/BOD?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/BOD/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/CCM?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/CCM/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/CDN?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&bscPartyId][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/CDN/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&bscPartyId]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/CBS?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/CBS/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/INDDEM[?boundary][&publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/INDDEM/stream[?boundary][&publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/INDGEN[?boundary][&publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/INDGEN/stream[?boundary][&publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/IMBALNGC[?boundary][&publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/IMBALNGC/stream[?boundary][&publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MELNGC[?boundary][&publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MELNGC/stream[?boundary][&publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NDF[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NDF/stream[?publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/TSDF[?boundary][&publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/TSDF/stream[?boundary][&publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/DAG?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/DAG/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/DGWS?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/DGWS/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/DATL?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/DATL/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/DCI[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/DCI/stream[?publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/DISBSAD?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/DISBSAD/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/FEIB?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/FEIB/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/FUELHH[?publishDateTimeFrom][&publishDateTimeTo][&settlementDateFrom][&settlementDateTo][&settlementPeriod][&fuelType][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/FUELHH/stream[?publishDateTimeFrom][&publishDateTimeTo][&settlementDateFrom][&settlementDateTo][&settlementPeriod][&fuelType]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/INDO[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/INDOD?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/INDOD/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/ITSDO[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/IGCA?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/IGCA/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/IGCPU?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/IGCPU/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/FUELINST[?publishDateTimeFrom][&publishDateTimeTo][&settlementDateFrom][&settlementDateTo][&settlementPeriod][&fuelType][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/FUELINST/stream[?publishDateTimeFrom][&publishDateTimeTo][&settlementDateFrom][&settlementDateTo][&settlementPeriod][&fuelType]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/LOLPDRM?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/LOLPDRM/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MID?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&dataProviders][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MID/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&dataProviders]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MDB?settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MDB/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MDO?settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MDO/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MDP?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MDP/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MDV?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MDV/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MELS?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MELS/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MILS?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MILS/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MNZT?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MNZT/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MZT?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MZT/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MATL?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/MATL/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NETBSAD?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NETBSAD/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NONBM[?from][&to][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NONBM/stream[?from][&to]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NTB?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NTB/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NTO?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NTO/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NDZ?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/NDZ/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/PN?settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/PN/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/PPBR?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/PPBR/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/PBC?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/PBC/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/QPN?settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/QPN/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/RZDF?submissionDateTimeFrom={submissionDateTimeFrom}&submissionDateTimeTo={submissionDateTimeTo}[&region][&gspGroupId][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/RZDF/stream?submissionDateTimeFrom={submissionDateTimeFrom}&submissionDateTimeTo={submissionDateTimeTo}[&region][&gspGroupId]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/RZDR?submissionDateTimeFrom={submissionDateTimeFrom}&submissionDateTimeTo={submissionDateTimeTo}[&region][&gspGroupId][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/RZDR/stream?submissionDateTimeFrom={submissionDateTimeFrom}&submissionDateTimeTo={submissionDateTimeTo}[&region][&gspGroupId]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/metadata/latest[?format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/RDRE?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/RDRE/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/RDRI?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/RDRI/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/RURE?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/RURE/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/RURI?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/RURI/stream?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/SOSO?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/SOSO/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/SEL[?from][&to][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/SEL/stream[?from][&to][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/SIL[?from][&to][&bmUnit][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/SIL/stream[?from][&to][&bmUnit]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/FREQ[?measurementDateTimeFrom][&measurementDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/FREQ/stream[?measurementDateTimeFrom][&measurementDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/SYSWARN[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/SYSWARN/stream[?publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/TEMP[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/REMIT?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/REMIT/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/TUDM?settlementDate={settlementDate}&settlementPeriod={settlementPeriod}[&tradingUnitName][&tradingUnitType][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/TUDM/stream?settlementDateFrom={settlementDateFrom}&settlementPeriodFrom={settlementPeriodFrom}&settlementDateTo={settlementDateTo}&settlementPeriodTo={settlementPeriodTo}[&tradingUnitName][&tradingUnitType]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/WATL?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/WATL/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/WINDFOR[?publishDateTimeFrom][&publishDateTimeTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/WINDFOR/stream[?publishDateTimeFrom][&publishDateTimeTo]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/YAFM?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/YAFM/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/YATL?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}[&format]
# - https://data.elexon.co.uk/bmrs/api/v1/datasets/YATL/stream?publishDateTimeFrom={publishDateTimeFrom}&publishDateTimeTo={publishDateTimeTo}

# Credit Default Notice:
# - https://data.elexon.co.uk/bmrs/api/v1/CDN[?format]

# Data Status:
# - https://data.elexon.co.uk/bmrs/api/v1/data-status/BOALF[?settlementDateFrom][&settlementDateTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/data-status/BOAV[?settlementDateFrom][&settlementDateTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/data-status/BOD[?settlementDateFrom][&settlementDateTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/data-status/DISBSAD[?settlementDateFrom][&settlementDateTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/data-status/DISEBSP[?settlementDateFrom][&settlementDateTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/data-status/DISPTAV[?settlementDateFrom][&settlementDateTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/data-status/EBOCF[?settlementDateFrom][&settlementDateTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/data-status/FREQ[?settlementDateFrom][&settlementDateTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/data-status/ISPSTACK[?settlementDateFrom][&settlementDateTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/data-status/NETBSAD[?settlementDateFrom][&settlementDateTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/data-status/PN[?settlementDateFrom][&settlementDateTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/data-status/REMIT[?source][&settlementDateFrom][&settlementDateTo][&format]

# Demand:
# - https://data.elexon.co.uk/bmrs/api/v1/demand/actual/total?from={from}&to={to}[&settlementPeriodFrom][&settlementPeriodTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/demand/peak/indicative?data={data}[&triadSeasonStartYear][&from][&to][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/demand/outturn[?settlementDateFrom][&settlementDateTo][&settlementPeriod][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/demand/outturn/stream[?settlementDateFrom][&settlementDateTo][&settlementPeriod]
# - https://data.elexon.co.uk/bmrs/api/v1/demand/outturn/daily[?settlementDateFrom][&settlementDateTo][&format]
# - https://data.elexon.co.uk/bmrs/api/v1/demand/outturn/daily/stream[?settlementDateFrom][&settlementDateTo]
# - https://data.elexon.co.uk/bmrs/api/v1/demand/peak/indicative/operational/{triadSeason}[?format]