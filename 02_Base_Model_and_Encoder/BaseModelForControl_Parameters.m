%% MCU Parameters
% MCU frequency
MCU_Frequency = 200e6;
MCU_Period = 1/MCU_Frequency;
%PWM Switching frequency
PWM_Frequency 	= 10e3;    			
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
OffsetADCINC4=2271;

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
TaoFilterOmega=1; % Choose right value <-----------------

%% PI Current parameters

%......