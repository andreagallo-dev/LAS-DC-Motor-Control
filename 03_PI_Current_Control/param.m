%LUDO_LODO
%DC Motor Parameters


%Inductance 
L = 0.0041; %H
R = 3.20; %Ohm 
Km = 0.11; %N*m/A (=Kt)
J = 0.0000352; %Kg*m^2
Iv = 0.3; %[A] corrente a vuoto
Nv = 1750 ; %[rpm]velocita a vuoto
Nn = 1500; %[rpm] velocita nominale
Cn =  0;%0.22; %[Nm] coppia a velocita nominale (COPPIA RESISTENTE PER W NOMINALE)
Cr=0;
%IL MOTORE HA COPPIA NOMINALE QUANDO HA COPPIA RESISTENTE NOMINALE
% PERCHE E' BILNCIATO IN STEADY STATE (STESSA COSA PER LE VELOCITA)

%Conversion Rad2Rpm
RadToRpm = 60/(2*pi);

%PI regulations
TSample=0.0001;
ti=0.0001;%8.5*10^-3; %10 volte piu veloce di taum
tm=85*10^-3;
Tii=L/R;
Kpi=L/ti;
b=J/tm; %Adimensionale (attrito viscoso)
EnableSaturation=1;
