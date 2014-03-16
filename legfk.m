% HY: Hip yaw
% HR: Hip roll
% HP: Hip pitch
% HK: Knee pitch
% LU: Upper leg length
% LL: Lower leg length
syms HY HR HP KP
LU = .28
LL = .28

% Hip yaw to hip roll transform
A_L1 = [	cos(HY),	-sin(HY),0,	0;
	sin(HY),	cos(HY),	0,	0;
	0,	0,	1,	0;
	0,	0,	0,	1];

% Hip roll to hip pitch transform
A_L2 = [	cos(HR), 0, -sin(HR),	0;
	sin(HR), 0, cos(HR),	0;
	0,	-1, 0,		0;
	0,	 0, 0,		1];

% Hip pitch to knee pitch transform
A_L3 = [	cos(HP),-sin(HP),0,LU*cos(HP);
	sin(HP),cos(HP) ,0,LU*sin(HP);
	0,	0,	1,0	 ;
	0,	0,	0,1	 ];

% Knee Pitch to ankle pitch transform 
A_L4 = [ 	cos(KP),-sin(KP),0,:L*cos(KP);
	sin(KP),cos(KP),	0,LL*sin(KP);
	0,	0,	1,0	  ;
	0,	0,	0,1	  ];

% Transform from hip roll to ankle pitch reference frame
T_L14 = A_L2*A_L3*A_L4;
% Transform from hip yaw to ankle pitch reference frame
T_L04 = A_L1*T_L14;

T_L04_inv = inv(T_L04);
T_L14_inv = inv(T_L14);

hr2apT(R, P, K, U, L) = T_14;
hy2apT(Y, R, P, K, U, L) = T_04;

% SP: Shoulder pitch
% SR: Shoulder roll
% SY: Shoulder yaw
% EP: Elbow pitch
% AUX: Upper arm length in x direction
% AUZ: Upper arm length in z direction
% AL: Lower arm length
% SR_OFF: Shoulder roll offset
% EP_OFF: Elbow pitch offset
syms SY SR SP SK
AUX = .02;
AUZ = .182;
AL = (.164*.164 + .022*.022)^.5;
SR_OFF = .2618;
EP_OFF = .0411;

% Shoulder pitch to shoulder roll transform
A_A1 = [    cos(SP),0, sin(SP),0;
		    sin(SP),0,-cos(SP),0;
		    0,      1,0,       0;
		    0,      0,0,       1];

% Shoulder roll to shoulder yaw transform
A_A2 = [    -sin(SR),0, -cos(SR),0;
		    cos(SR), 0, -sin(SR),0;
		    0,       -1,0,       0;
		    0,       0, 0,       1];

% Shoulder yaw to elbow pitch transform
A_A3 = [	sin(SY), 0, cos(SY),AUX*sin(YP);
			-cos(SY),0, sin(SY),-AUX*cos(SY);
			0,       -1,0,      -AUZ;
			0,       0, 0,      1];

% Elbow Pitch to wrist pitch transform 
A_A4 = [ 	cos(K),-sin(K),0,L*cos(K);
	sin(K),cos(K),	0,L*sin(K);
	0,	0,	1,0	  ;
	0,	0,	0,1	  ];

hipRollToAnklePitchTransform(0, 0, 0, .28, .28)