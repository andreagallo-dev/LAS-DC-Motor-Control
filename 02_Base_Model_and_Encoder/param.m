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
%IL MOTORE HA COPPIA NOMINALE QUANDO HA COPPIA RESISTENTE NOMINALE
% PERCHE E' BILNCIATO IN STEADY STATE (STESSA COSA PER LE VELOCITA)

%Conversion Rad2Rpm
RadToRpm = 60/(2*pi);

b = (Km*Iv)/(Nv/RadToRpm); %Adimensionale (attrito viscoso)

%% Transfer function
s = tf('s');
z = tf('z',TSample);

%DC Motor continous transfer function
Gmot=tf([Km],[L*J R*J+b*L Km*Km+b*R]);

% I need two poles
pole1=1/(1+0.002*s);
pole2=1/(1+0.001*s);


GmotInv=1/Gmot;
GmotInv=GmotInv*pole1*pole1;

% GmotInv Discretization
GmotInvz=c2d(GmotInv,TSample);