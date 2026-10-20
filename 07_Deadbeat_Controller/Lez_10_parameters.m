%% MCU Parameters
% MCU frequency
MCU_Frequency = 200e6;
MCU_Period = 1/MCU_Frequency;
%PWM Switching frequency
PWM_Frequency 	= 10e3; %10^4   			
PWM_Period      = 1/PWM_Frequency;  % 	// PWM switching time period
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


%% common interface
comport = "COM6";

%% Write here Estimated value (R-L-J-b) for 1000rpm
R = 3.1532
L = 0.0061
J = 8.1035e-5
b = 0.000498967
%% deadbeat
%% TRANSFER FUNCION
s=tf('s');          
z=tf('z',TSample);

%DC Motor continuous transfer function
Gmot=tf([Km],[L*J R*J Km*Km])
%Gmot=tf([Km],[L*J R*J+b*L Km*Km+b*R]);
Gmot=24*Gmot;

%DC Motor discrete transfer function
Gpz=c2d(Gmot,TSample)

kd=1;   %prova a cambiare diversi valori di kd

Dz=(1/Gpz)*((z^-kd)/(1-(z^-kd)))

Dzmr = minreal(Dz); %semplifica la frazione al minimo ordine

%Estrai numeratore e denominatore del controllore
Az = Dzmr.Denominator;
Bz = Dzmr.Numerator;

Bz_coeff = Bz{1,1} 

%Costruzione F(z)
% Verificare che l'-ordine sia >= all'ordine di Bz.
% Calcolare F(z)-A(z)
% Aggiustare la costante 'K' per assicurarsi che B(1)/F(1) >= 1
Kf = 100;

Fz=Kf*(z-0.95)*(z-0.8)*z;
FFeedNum = Fz.Numerator{1,1};

for i=0:length(Az{1,1})-1
FFeedNum(1,length(Fz.Numerator{1,1})-i) = FFeedNum(1,length(Fz.Numerator{1,1})-i) - Az{1,1}(1,length(Az{1,1})-i);

end
FFeedNum