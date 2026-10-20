% Dati originali
b_stim_vec = [0.0011 7.4568e-04 5.7062e-04 4.8681e-04 4.0661e-04 3.5964e-04 2.4891e-04];
J_stim_vec = [8.1088e-05 8.0889e-05 8.0847e-05 8.1535e-05 8.1991e-05 7.9075e-05 7.3522e-05];
V_vec = [14 20 23 32 38 44 48];

% 1. Creo il terzo campo: un vettore di 100 punti tra il minimo e il massimo di V_vec
% Questo andrà al posto di "SoC_1"
V_interp = linspace(min(V_vec), max(V_vec), 100);

% 2. Calcolo le interpolazioni pchip
b_interp = interp1(V_vec, b_stim_vec, V_interp, 'pchip');
J_interp = interp1(V_vec, J_stim_vec, V_interp, 'pchip');

% 3. Disegno i grafici
figure;

% Primo grafico: b_stim_vec
subplot(2,1,1);
plot(V_vec, b_stim_vec, 'o','MarkerFaceColor', 'b', 'MarkerSize', 8); % Punti originali
hold on;
plot(V_interp, b_interp, '-', 'LineWidth', 3); % Curva interpolata
title('Interpolazione b_{stim} vs Voltaggio');
xlabel('Voltaggio (V)');
ylabel('b_{stim}');
legend('Dati originali', 'Interpolazione pchip');
grid on;

% Secondo grafico: J_stim_vec
subplot(2,1,2);
plot(V_vec, J_stim_vec, 'o', 'MarkerFaceColor', 'b', 'MarkerSize', 8); % Punti originali
hold on;
plot(V_interp, J_interp, 'r', 'LineWidth', 3); % Curva interpolata
title('Interpolazione J_{stim} vs Voltaggio');
xlabel('Voltaggio (V)');
ylabel('J_{stim}');
legend('Dati originali', 'Interpolazione pchip');
grid on;