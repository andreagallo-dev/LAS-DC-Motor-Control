%% MCU Parameters
% MCU frequency
MCU_Frequency = 200e6;
MCU_Period = 1/MCU_Frequency;
%PWM Switching frequency
PWM_Frequency 	= 10e3; %10^4   			
PWM_Period      = 1/PWM_Frequency;  %s  	// PWM switching time period
%PWM register
TBPRD  = uint16 (MCU_Frequency/(2*PWM_Frequency)); % Time Base Period Register

%%Sample Period
TSample=PWM_Period;

%% Analog Reading
%input sensing
ADCResolution = 2^12;
ADCCount=ADCResolution-1;
VrefADC=3;
GainVsense=4.99/(62+4.99);
GainCurrentSense=10;
RShunt=0.007;

%Current Offset
OffsetADCINC4=2279;

%%Encoder
PulseNumber = 2048*4;
RadiantsPerCount=2*pi/(PulseNumber-1);

%% CONVERSION
RadToRpm=60/(2*pi); %Convert rad->RPM
RpmToRads = 2*pi/60;

%% Filter
%Offset Current Filter
TaoFilterOffsetCurrent=1; 

% Omega filter - To Be Defined
TaoFilterOmega=0.002;%1e-3; % Choose right value <-----------------

%% PI Current parameters
%DC Motor Parameters
%Inductance 
L = 0.0041; %H
R = 3.20; %Ohm 
Km = 0.11; %N*m/A (=Kt)
J = 0.0000352; %Kg*m^2
J=J*2; % HO DUE MOTORI
Iv = 0.3; %[A] corrente a vuoto
Nv = 1750 ; %[rpm]velocita a vuoto
Nn = 1500; %[rpm] velocita nominale
Cn =  0;%0.22; %[Nm] coppia a velocita nominale (COPPIA RESISTENTE PER W NOMINALE)
Cr=0;
%IL MOTORE HA COPPIA NOMINALE QUANDO HA COPPIA RESISTENTE NOMINALE
% PERCHE E' BILNCIATO IN STEADY STATE (STESSA COSA PER LE VELOCITA)

%Conversion Rad2Rpm
RadToRpm = 60/(2*pi);

% %PI regulations Current
% TSample=0.0001;
% ti=0.0001;%8.5*10^-3; %10 volte piu veloce di taum
% tm=85*10^-3;
% Tii=L/R;
% Kpi=L/ti;
% b=J/tm; %Adimensionale (attrito viscoso)
% EnableSaturation=1;
% 
% %PI regulations Speed
% %TSample=0.0001;
% tw=6/(10*ti);%---------------------------
% tm=85*10^-3;
% Tiw=tm;
% Kpw=J/(tm*Km);
% b=J/tm; %Adimensionale (attrito viscoso)
% EnableSaturation=1;

%% PI regulations Current
%TSample = 0.0001; % 100 microseconds =  PWM PERIOD TSample=PWM_Period;
ti = 1e-3; % Meglio se più grande di TSample per stabilità discreta (es. 0.5 ms)
Tii = L/R;   % Cancellazione polo elettrico
Kpi = L/ti;  % Guadagno P calcolato su tempo target ti

%% PI regulations Speed
% L'anello di velocità deve essere 5-10 volte più lento di quello di corrente
tw = 10 * ti; % Target dinamica velocità (es. 5 ms)

tm = 85 * 10^-3; % Assunzione costante di tempo meccanica
b = J/tm;        % Derivazione attrito viscoso 

Tiw = tm;          % Cancellazione polo meccanico
Kpw = J/(tw*Km);   % Usa tw per definire la reattività del loop, non tm
EnableSaturation = 1;

%% common interface
comport = "COM1";
