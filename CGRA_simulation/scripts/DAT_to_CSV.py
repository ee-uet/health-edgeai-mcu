# Author: Muhammad Zain
# Date  : 24/4/2025

import wfdb
import pandas as pd

# --- Load ECG Record (first 5 seconds) ---
record = wfdb.rdrecord('../ecg_data/data100/100')
fs = record.fs
num_samples = int(5 * fs)

# Extract channel 0 (e.g., MLII)
ecg = record.p_signal[:num_samples, 0]

# As floats are not supported, multiply by 1000 and round to int
ecg = pd.Series(ecg)
ecg = (ecg * 1000).tolist()
ecg = list(map(round, ecg))

# Create a DataFrame
data = {
    'Address': list(range(1000, 1000 + (4 * num_samples), 4)),
    'Data': list(ecg),
}
df = pd.DataFrame(data)

df.to_csv('memory.csv', index=False)