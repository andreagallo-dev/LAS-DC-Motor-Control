% 1. Initialization
clear; clc; close all;

% 2. Sample Time
Ts = 1/10e3; 

% 3. Load Data
d1 = load('antiwindup_load.mat');
d2 = load('antiwindup_no_load.mat');
d3 = load('no_antiwindup_load.mat');
d4 = load('no_antiwindup_no_load.mat');

% 4. Extract Matrices
f1 = fieldnames(d1); m1 = d1.(f1{1}); if isstruct(m1) || isobject(m1), m1 = m1.simout; end
f2 = fieldnames(d2); m2 = d2.(f2{1}); if isstruct(m2) || isobject(m2), m2 = m2.simout; end
f3 = fieldnames(d3); m3 = d3.(f3{1}); if isstruct(m3) || isobject(m3), m3 = m3.simout; end
f4 = fieldnames(d4); m4 = d4.(f4{1}); if isstruct(m4) || isobject(m4), m4 = m4.simout; end

% 5. Separate Reference and Measurement
ref1 = m1(:,1); meas1 = m1(:,2); t1 = (0:size(m1, 1)-1)' * Ts;
ref2 = m2(:,1); meas2 = m2(:,2); t2 = (0:size(m2, 1)-1)' * Ts;
ref3 = m3(:,1); meas3 = m3(:,2); t3 = (0:size(m3, 1)-1)' * Ts;
ref4 = m4(:,1); meas4 = m4(:,2); t4 = (0:size(m4, 1)-1)' * Ts;

% =========================================================
% 6. ALIGNMENT TO THE FIRST RISING STEP AFTER 5 SECONDS
% =========================================================
idx1 = find(t1(1:end-1) >= 5 & ref1(1:end-1) < 500 & ref1(2:end) >= 500, 1, 'first') + 1;
idx2 = find(t2(1:end-1) >= 5 & ref2(1:end-1) < 500 & ref2(2:end) >= 500, 1, 'first') + 1;
idx3 = find(t3(1:end-1) >= 5 & ref3(1:end-1) < 500 & ref3(2:end) >= 500, 1, 'first') + 1;
idx4 = find(t4(1:end-1) >= 5 & ref4(1:end-1) < 500 & ref4(2:end) >= 500, 1, 'first') + 1;

plot_step_time = 5; 

t1_aligned = t1 - t1(idx1) + plot_step_time;
t2_aligned = t2 - t2(idx2) + plot_step_time;
t3_aligned = t3 - t3(idx3) + plot_step_time;
t4_aligned = t4 - t4(idx4) + plot_step_time;

% =========================================================
% 7. PLOTTING BY LOAD CONDITION
% =========================================================
fig = figure('Color','w');

% --- TOP PLOT: WITH LOAD (Files 1 and 3) ---
ax1 = subplot(2, 1, 1); 
plot(t1_aligned, ref1, 'k--', 'LineWidth', 1.5); 
hold on;
plot(t1_aligned, meas1, 'b', 'LineWidth', 1.5);  % Con Antiwindup (d1)
plot(t3_aligned, meas3, 'r', 'LineWidth', 1.5);  % Senza Antiwindup (d3)
grid on; box on;
title('DEADBEAT: WITH Load');
ylabel('Speed [rpm]');
legend('Reference', 'Motor (With Anti-windup)', 'Motor (No Anti-windup)', 'Location', 'best');
xlim([4.5, 10]); 
hold off;

% --- BOTTOM PLOT: WITHOUT LOAD (Files 2 and 4) ---
ax2 = subplot(2, 1, 2); 
plot(t2_aligned, ref2, 'k--', 'LineWidth', 1.5); 
hold on;
plot(t2_aligned, meas2, 'b', 'LineWidth', 1.5);  % Con Antiwindup (d2)
plot(t4_aligned, meas4, 'r', 'LineWidth', 1.5);  % Senza Antiwindup (d4)
grid on; box on;
title('DEADBEAT: WITHOUT Load');
xlabel('Time [s]'); 
ylabel('Speed [rpm]');
legend('Reference', 'Motor (With Anti-windup)', 'Motor (No Anti-windup)', 'Location', 'best');
xlim([4.5, 10]); 
hold off;

linkaxes([ax1, ax2], 'xy');