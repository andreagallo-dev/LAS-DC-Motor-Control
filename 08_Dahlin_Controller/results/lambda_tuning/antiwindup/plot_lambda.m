% 1. Pulizia
clear; clc; close all;

% 2. Definisci il tempo di campionamento Ts!
% IMPORTANTE: inserisci il valore di Ts che hai usato in Simulink per il Dahlin.
% Se lo hai già definito nel Workspace di base, puoi commentare questa riga.
Ts = 1/10e3;

% 3. Caricamento dei file .mat
dati_1 = load('lambda_0.002.mat');
dati_2 = load('lambda_0.02.mat');
dati_3 = load('lambda_0.2.mat');

% 4. Estrazione robusta della matrice
% Estraiamo il primo elemento salvato nei file, a prescindere da come
% si chiama la variabile all'interno (out, simout, ans, ecc.)
campi_1 = fieldnames(dati_1); mat_1 = dati_1.(campi_1{1});
campi_2 = fieldnames(dati_2); mat_2 = dati_2.(campi_2{1});
campi_3 = fieldnames(dati_3); mat_3 = dati_3.(campi_3{1});

% (Se la variabile salvata fosse un oggetto Simulink.SimulationOutput, 
% ne estraiamo la sottomatrice dei dati)
if isobject(mat_1) || isstruct(mat_1)
    mat_1 = mat_1.simout; mat_2 = mat_2.simout; mat_3 = mat_3.simout;
end

% 5. Ricostruzione del vettore tempo (uguale per tutti)
N = size(mat_1, 1);
t = (0:N-1)' * Ts;

% 6. Estrazione dei segnali
% C'è una sola colonna nei tuoi file, che rappresenta l'uscita!
out_1 = mat_1(:,1);
out_2 = mat_2(:,1);
out_3 = mat_3(:,1);

% 7. Creazione del grafico
figure('Color','w')

% (Ho rimosso il plot del riferimento perché non è salvato nei file. 
% Se vuoi plottarlo dovrai crearlo a mano, es: rif = 800 * ones(size(t)); )

% Plot delle tre prove di Dahlin
plot(t, out_1, 'b', 'LineWidth', 1.5);
hold on;
plot(t, out_2, 'r', 'LineWidth', 1.5);
plot(t, out_3, 'g', 'LineWidth', 1.5);

grid on;
box on;

xlabel('Time [s]');
ylabel('Speed [rad/s]');
title('Dahlin Control With Antiwindup and varying \lambda');

% Legenda aggiornata senza il riferimento
legend('\lambda = 0.002', ...
       '\lambda = 0.02', ...
       '\lambda = 0.2', ...
       'Location', 'best');

hold off;