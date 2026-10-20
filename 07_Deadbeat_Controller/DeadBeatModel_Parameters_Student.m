
%% DC MOTOR PARAMETER

L = 4.1e-3;         % Inductance (H)
R = 3.2;            % Resistance (Ohm) 
In = 1.9;           % Nominal current (A)
Cn = 0.22;          % Nominal Torque (Nm)
Km = 0.11;          %  (Nm/A)
Jm = 0.352e-4;      % (kg m2)
Nv = 1750;          % Idle speed
Nn = 1500;          % Nominal speed in rpm 
Wn = Nn*2*pi/60;    % Nominal speed in rad/s 
b=0.0003;            % Coefficient of friction

%% OTHER PARAMETER

Fsw  = 10e3;        % PWM Frequency
TSample = 0.1e-3;    % TSample
Jmbl = 0.38e-4;


J = Jm+Jmbl;      % Total Inertia;

% Write here Estimated value (R-L-J-b)
% R=....;

%%Encoder
PulseNumber = 2048*4;
RadiantsPerCount=2*pi/(PulseNumber-1);

%% CONVERSION
RadToRpm=60/(2*pi); %Convert rad->RPM
RpmToRads = 2*pi/60;

%% Omega filter
TaoFilterOmega=0.002;

%% TRANSFER FUNCION
s=tf('s');          
z=tf('z',TSample);

%DC Motor continuous transfer function
Gmot=tf([Km],[L*J R*J Km*Km]);
%Gmot=tf([Km],[L*J R*J+b*L Km*Km+b*R]);
Gmot=24*Gmot;

%DC Motor discrete transfer function
Gpz=c2d(Gmot,TSample)

k=1;

Dz=(1/Gpz)*((z^-k)/(1-(z^-k)))


