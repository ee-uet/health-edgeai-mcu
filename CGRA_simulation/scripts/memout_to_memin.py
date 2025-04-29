# Author: Muhammad Zain
# Date  : 24/4/2025

# This file can be edited to perform desired calculations on memory_out.csv
# It's ouput can be plotted or used as memory_in for next simulation

import pandas as pd

df = pd.read_csv('memory_out.csv')
df = df.dropna()
df = list(df['Data'])
num_samples = len(df)
data = []

# Here we are dividing the data by 1000
for i in df:
    data.append((i/1000))

# Create a DataFrame
file_data = {
    'Address': list(range(1000, 1000 + (4 * num_samples), 4)),
    'Data': list(data),
}

df = pd.DataFrame(file_data)

df.to_csv('memory_in.csv', index=False)