# Author: Muhammad Zain
# Date  : 24/4/2025

import wfdb
import matplotlib.pyplot as plt
import pywt
import numpy as np

# --- Load ECG Record (first 5 seconds) ---
record = wfdb.rdrecord('../ecg_data/data100/100')
fs = record.fs
num_samples = int(5 * fs)

# Extract channel 0 (e.g., MLII)
ecg = record.p_signal[:num_samples, 0]
time = [i / fs for i in range(num_samples)]

# --- Plot Original ECG ---
plt.figure(figsize=(12, 4))
plt.plot(time, ecg, label='Original ECG')
plt.xlabel('Time (s)')
plt.ylabel('Amplitude (mV)')
plt.title('Original ECG Signal - First 5 Seconds')
plt.grid(True)
plt.legend()
plt.tight_layout()

# --- Perform DWT ---
wavelet = 'sym4'
level = 5
coeffs = pywt.wavedec(ecg, wavelet, level=level)

# --- Denoising: Zero out high-frequency noise (D1 and D2) ---
coeffs_denoised = coeffs.copy()
coeffs_denoised[-1] = [0] * np.zeros_like(coeffs_denoised[-1])  # D1
coeffs_denoised[-2] = [0] * np.zeros_like(coeffs_denoised[-2])  # D2

# --- Inverse DWT to reconstruct denoised signal ---
reconstructed = pywt.waverec(coeffs_denoised, wavelet)

# Match length (because of padding in wavelet transform)
reconstructed = reconstructed[:num_samples]

# --- Plot Denoised ECG ---
plt.figure(figsize=(12, 4))
plt.plot(time, reconstructed, label='Denoised ECG (No D1, D2)', color='orange')
plt.xlabel('Time (s)')
plt.ylabel('Amplitude (mV)')
plt.title('Denoised ECG Signal (First 5 Seconds)')
plt.grid(True)
plt.legend()
plt.tight_layout()

# --- Compare Original and Denoised Together ---
plt.figure(figsize=(12, 4))
plt.plot(time, ecg, label='Original ECG', alpha=0.6)
plt.plot(time, reconstructed, label='Denoised ECG', color='orange', alpha=0.8)
plt.xlabel('Time (s)')
plt.ylabel('Amplitude (mV)')
plt.title('Comparison: Original vs Denoised ECG')
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
