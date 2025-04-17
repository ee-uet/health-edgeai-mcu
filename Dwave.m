clc; clear; close all;

%% 1. Load and Prepare ECG Data
load('230m.mat'); 
ECG1 = (val(1,:) - 1024)/200; 
ECG2 = (val(2,:) - 1024)/200; 
Fs = 360; % Sampling frequency 
t = (0:length(ECG1)-1)/Fs;
length(ECG1)/Fs

%% 2. Plot Raw ECG Signals
figure('Name','Raw ECG Signals');
subplot(2,1,1);
plot(t, ECG1)
title('Channel 1'); 
ylabel('Amplitude (mV)'); 
grid on;
xlim([0 10]); 

subplot(2,1,2);
plot(t, ECG2);
title('Channel 2'); 
xlabel('Time (s)'); ylabel('Amplitude (mV)'); 
grid on;
xlim([0 10]);

%% 3. Wavelet Analysis - 6 Level Decomposition
wavelet_name = 'sym4';
level = 6;
[C1, L1] = wavedec(ECG1, level, wavelet_name);


A6 = appcoef(C1, L1, wavelet_name, level); % Level 6 approximation
[D1, D2, D3, D4, D5, D6] = deal(...
    detcoef(C1, L1, 1), ...
    detcoef(C1, L1, 2), ...
    detcoef(C1, L1, 3), ...
    detcoef(C1, L1, 4), ...
    detcoef(C1, L1, 5), ...
    detcoef(C1, L1, 6)); 

%% 4. Plot Complete 6-Level Decomposition
figure;

% Original Signal
subplot(8,1,1);
plot(t, ECG1);
title('Original ECG Signal');
ylabel('mV');
grid on;
xlim([0 10]);

% Approximation Coefficients (A6)
subplot(8,1,2);
a6_time = linspace(0,max(t),length(A6));
plot(a6_time, A6);
title('Level 6 Approximation (A6)'); ylabel('mV'); grid on;

% Detail Coefficients (D6-D1)
subplot(8,1,3);
plot(linspace(0,max(t),length(D6)), D6);
title('Level 6 Details (D6)'); ylabel('mV'); grid on;

subplot(8,1,4);
plot(linspace(0,max(t),length(D5)), D5);
title('Level 5 Details (D5)'); ylabel('mV'); grid on;

subplot(8,1,5);
plot(linspace(0,max(t),length(D4)), D4);
title('Level 4 Details (D4)'); ylabel('mV'); grid on;

subplot(8,1,6);
plot(linspace(0,max(t),length(D3)), D3);
title('Level 3 Details (D3)'); ylabel('mV'); grid on;

subplot(8,1,7);
plot(linspace(0,max(t),length(D2)), D2);
title('Level 2 Details (D2)'); ylabel('mV'); grid on;

subplot(8,1,8);
plot(linspace(0,max(t),length(D1)), D1);
title('Level 1 Details (D1) - High Frequency Noise'); 
xlabel('Time (s)'); ylabel('mV'); grid on;

%% 5. Reconstruct Individual Levels
A6_rec = wrcoef('a', C1, L1, wavelet_name, level);
D1_rec = wrcoef('d', C1, L1, wavelet_name, 1);
D2_rec = wrcoef('d', C1, L1, wavelet_name, 2);
D3_rec = wrcoef('d', C1, L1, wavelet_name, 3);
D4_rec = wrcoef('d', C1, L1, wavelet_name, 4);
D5_rec = wrcoef('d', C1, L1, wavelet_name, 5);
D6_rec = wrcoef('d', C1, L1, wavelet_name, 6);

%% 6. Plot Reconstructed Components
figure('Name','Reconstructed Components', 'Position', [100 100 900 1200]);

subplot(7,1,1);
plot(t, A6_rec);
title('Reconstructed A6 (Approximation)'); ylabel('mV'); grid on;
xlim([0 10]);

subplot(7,1,2);
plot(t, D6_rec);
title('Reconstructed D6'); ylabel('mV'); grid on;
xlim([0 10]);

subplot(7,1,3);
plot(t, D5_rec);
title('Reconstructed D5'); ylabel('mV'); grid on;
xlim([0 10]);

subplot(7,1,4);
plot(t, D4_rec);
title('Reconstructed D4'); ylabel('mV'); grid on;
xlim([0 10]);

subplot(7,1,5);
plot(t, D3_rec);
title('Reconstructed D3'); ylabel('mV'); grid on;
xlim([0 10]);

subplot(7,1,6);
plot(t, D2_rec);
title('Reconstructed D2'); ylabel('mV'); grid on;
xlim([0 10]);

subplot(7,1,7);
plot(t, D1_rec);
title('Reconstructed D1 (Noise)'); 
xlabel('Time (s)'); ylabel('mV'); grid on;
xlim([0 10]);

%% 7. Denoising Using Wavelet Thresholding

denoised_ECG = wden(ECG1, 'modwtsqtwolog', 's', 'mln', level, wavelet_name);

%% 8. Plot Denoising Results
figure;
plot(t, ECG1,'g'); 
hold on;
title('Original ECG Signal'); 
ylabel('Amplitude (mV)'); grid on;
xlim([0 10]);

 plot(t, denoised_ECG,'r'); 
title('Denoised ECG Signal (Wavelet Thresholding)'); 
xlabel('Time (s)'); ylabel('Amplitude (mV)'); grid on;
xlim([0 10]);
%% Calculate Mean Square Error (MSE) between Original and Denoised ECG
mse = mean((ECG1 - denoised_ECG).^2);
fprintf('Mean Square Error (MSE) between original and denoised ECG: %.4f\n', mse);
%% Compute Both MSE and MAE
mse = mean((ECG1 - denoised_ECG).^2);
mae = mean(abs(ECG1 - denoised_ECG));

fprintf('Mean Square Error (MSE): %.4f mV?\n', mse);
fprintf('Mean Absolute Error (MAE): %.4f mV\n', mae);
rmse = sqrt(mse);
fprintf('Root Mean Square Error (RMSE): %.4f mV\n', rmse);

