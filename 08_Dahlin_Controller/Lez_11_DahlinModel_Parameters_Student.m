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

%% common interface
comport = "COM6";


%% DC MOTOR PARAMETER

L = 4.1e-3;         % Inductance (H)
R = 3.2;            % Resistance (Ohm) 
In = 1.9;           % Nominal current (A)
Cn = 0.22;          % Nominal Torque (Nm)
Km = 0.11;          %  (Nm/A)
Jm = 0.352e-4;      % (kg m2)
Jm=Jm*2;
Nv = 1750;          % Idle speed
Nn = 1500;          % Nominal speed in rpm 
Wn = Nn*2*pi/60;    % Nominal speed in rad/s 
b=0.0003;            % Coefficient of friction

%% OTHER PARAMETER

Fsw  = 10e3;        % PWM Frequency
TSample = 0.1e-3;    % TSample
Jmbl = 0.38e-4;


J = Jm+Jmbl;      % Total Inertia;

% Write here Estimated value (R-L-J-b) for 1000rpm
R = 3.1532
L = 0.0061
J = 8.1035e-5
b = 0.000498967

%%Encoder
PulseNumber = 2048*4;
RadiantsPerCount=2*pi/(PulseNumber-1);

%% CONVERSION
RadToRpm=60/(2*pi); %Convert rad->RPM
RpmToRads = 2*pi/60;

%% Omega filter
TaoFilterOmega=0.002;
%Offset Current Filter
TaoFilterOffsetCurrent=1; 

%% TRANSFER FUNCION DAHLIN
s=tf('s');          
z=tf('z',TSample);

%DC Motor continuous transfer function
Gmot=tf([Km],[L*J R*J Km*Km]);
%Gmot=tf([Km],[L*J R*J+b*L Km*Km+b*R]);

%DC Motor discrete transfer function
Gpz=c2d(Gmot,TSample)

lambda=0.02;
Theta=0.0001;
N=floor(Theta/TSample)

%Yz= ( 1-exp(-TSample/lambda) )*z^(-N-1) / (1-z^-1)*(1-exp(-TSample/lambda)*z^-1)

Gmz= ( 1-exp(-TSample/lambda) )*z^(-N-1) / (1-exp(-TSample/lambda)*z^-1)

Dz = 1/Gpz *(Gmz/(1-Gmz))

Dz =minreal(Dz)
%fine dahlin-----------------

%inizio antiwindup-----------

%Estrai numeratore e denominatore del controllore
Az = Dz.Denominator;
Bz = Dz.Numerator;

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