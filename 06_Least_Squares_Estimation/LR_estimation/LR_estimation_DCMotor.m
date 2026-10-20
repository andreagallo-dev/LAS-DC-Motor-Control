%clear all;
close;

%% DATASHEET DC MOTOR PARAMETER
L = 4.1e-3;         % Inductance (H)
R = 3.2;            % Resistance (Ohm) 
In = 1.9;           % Nominal current (A)
Cn = 0.22;          % Nominal Torque (Nm)
Km = 0.11;          % Torque constant (Nm/A)
Jm = 0.352e-4;      % Rotor Inertia (kg m2)    
Nn = 1500;          % Nominal speed in rpm 
Wn = Nn*2*pi/60;    % Nominal speed in rad/s 
b =0;        	    % Coefficient of friction


Jbl = 0.38e-4;      % Brushless Rotor Inertia (kg m2)

J=Jm+Jbl;           % Total inertia (kg m2)

%% CONVERSION
RadToRpm=60/(2*pi); %Convert rad->RPM
RpmToRads = 2*pi/60;

%% TSample
TSample=0.0001;

%% load into workspace aquired data
load('LR_Data_Aquisition.mat')

% Number of samples used
N=1000; 

% select data to be analyzed
% With step input pay attention at N: motor start running (BEMF)

data=simout_RL;% ----------Nostri parametri stimati RL (motore fermo)
%data=T8ms_duty50_24Vpp;  ----------Parametri stimati DAL PROF RL (motore fermo)

%data=simout;

%% PLOT AVAILABLE DATA AND USED DATA
time=(0:TSample:(length(data)-1)*TSample);
xgraph=time;
xgraph(N+2:length(xgraph))=[];
ygraph=data(:,2);
ygraph(N+2:length(ygraph))=[];
y2graph=data(:,1);
y2graph(N+2:length(y2graph))=[];

f1=figure('Name','Dataset');
tiledlayout(3,1)

% Top plot
ax1 = nexttile;
hold on
plot(time,data(:,2))
plot(xgraph,ygraph,'LineWidth',3)
hold off
title(ax1,'FullData (blu) vs UsedData (red)')
ylabel(ax1,'Current [A]')
xlabel(ax1,'Time [s]')

% middle plot
ax2 = nexttile;
hold on
plot(xgraph,ygraph,'LineWidth',3)
plot(xgraph,y2graph,'LineWidth',3)
hold off
title(ax2,'Aquired Data: Input (red) Output (blu)')
ylabel(ax2,'Voltage [V],Current [A]')
xlabel(ax2,'Time [s]')

% bottom plot
ax3 = nexttile;
plot(xgraph,ygraph,'LineWidth',3)
title(ax3,'Output')
ylabel(ax3,'Current [A]')
xlabel(ax3,'Time [s]')




%% DATA PROCESSING
% input and output data
in=data(:,1);
out=data(:,2);

[alpha,phi]= least_square(in(1:N+1),out(1:N+1),N);
%alpha
Lstim=alpha(1,1)/alpha(2,1)*TSample
Rstim=(1-alpha(1,1))/(alpha(2,1))

Lstim = cast(Lstim,"double");
Rstim = cast(Rstim,"double");


%% Transfer funcion
% 
% s=tf('s');
% Gs_datasheet=1/(L*s+R);
% Gz_datasheet= c2d(Gs_datasheet,TSample);
% [numz_datasheet,denz_datasheet]=tfdata(Gz_datasheet,'v');
% 
% Gs_estimated=1/(Lstim*s+Rstim);
% Gz_estimated= c2d(Gs_estimated,TSample);
% [numz_estimated,denz_estimated]=tfdata(Gz_estimated,'v');

%% RUN SIMULATION
SimulationTime=xgraph(length(xgraph));

input_ts = timeseries(in,time);
output_ts = timeseries(out,time);
sim("LR_Model.slx");

%% PLOT SIMULATION DATA

f2=figure('Name','Model Output with Datasheet/Esimated parameters');
tiledlayout(2,1)

% Top plot
ax1 = nexttile;
hold on
plot(time,i_out_datasheet,'LineWidth',2)
plot(xgraph,ygraph,'LineWidth',2)
hold off
title(ax1,'Datasheet Parameters')
ylabel(ax1,'Current [A]')
xlabel(ax1,'Time [s]')
legend('Model','Real System','Location','northwest')
% bottom plot
ax2 = nexttile;
hold on
plot(time,i_out_estimated,'LineWidth',2)
plot(xgraph,ygraph,'LineWidth',2)
hold off
title(ax2,'Estimated Parameters')
ylabel(ax2,'Current [A]')
xlabel(ax2,'Time [s]')
legend('Model','Real System','Location','northwest')


%% LMS FUNCTION
function [alpha,phi]= least_square(u,y,N)
for i=2:N
   
    phi(i,1)=y(i-1);
    phi(i,2)=u(i);
end
phiT=transpose(phi);
%alpha=inv(phiT*phi)*phiT*y(1:N); 

%pinv(phi) is "equal" to inv(phiT*phi)*phiT
alpha=pinv(phi)*y(1:N); 
end


