%% DC MOTOR PARAMETER

%clear;

%% DC MOTOR PARAMETER

L = 4.1e-3; 	% Inductance (H)
R = 3.2;     	% Resistance (Ohm) 
Km = 0.11;   	% Torque constant (Nm/A)
J = 0.352e-4; 	% Rotor Inertia(kg m2)
b =0;        	% Coefficient of friction


Cn=0.22;        % Nominal Torque (Nm)

%% CONVERSION
RadToRpm=60/(2*pi); %Convert rad->RPM
RpmToRad = 2*pi/60;

%%OTHER
Tsample=0.0001;


%%Encoder
PulseNumber = 2048*4;
RadiantsPerCount=2*pi/(PulseNumber-1);

