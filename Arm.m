%syms SP SR SY EP;
classdef Arm < Limb
    properties (Constant)
    	RIGHT = 1;
    	LEFT = 0;
    	% Limb lengths
    	UPPER_ARM_X = ;
    	UPPER_ARM_Z = ;
    	LOWER_ARM = ;
	end

	properties
		% Shoulder pitch to wrist pitch transform
		T_04;
	end

	methods
		function arm = Arm(which)
			% Symbolicly solve transformation matrices
            % SP: Shoulder pitch
            % SR: Shoulder roll
            % SY: Shoulder yaw
            % EP: Elbow pitch
			SP = sym('SP');
            SR = sym('SR');
            SY = sym('SY');
            EP = sym('EP');
            % Shoulder pitch to shoulder roll transform
            A_1 = [	cos(SP),	0,	sin(SP),	0;...
            		sin(SP),	0,	-cos(SP),	0;...
            		0,			1,	0,			0;...
            		0,			0,	0,			1];
            % Shoulder roll to shoulder yaw transform
            A_2 = [	-sin(SR),	0,	-cos(SR),	0;...
            		cos(SR),	0,	-sin(SR),	0;...
            		0,			-1,	0,			0]...
            		0,			0,	0,			1];
            % Shoulder yaw to elbow pitch transform
            A_3 = [	sin(SY),	0,	cos(SY),	Leg.UPPER_ARM_X*sin(SY);...
            		-cos(SY),	0,	sin(SY),	-Leg.UPPER_ARM_X*cos(SY);...
            		0,			-1,	0,			-Leg.UPPER_ARM_Z;...
            		0,			0,	0,			1];
            % Elbow pitch to wrist pitch transform
            A_4 = [	-sin(EP),	-cos(EP),	0,	-Leg.LOWER_ARM*sin(EP);...
            		cos(EP),	-sin(EP),	0,	Leg.LOWER_ARM*cos(EP);...
            		0,			0,			1,	0;...
            		0,			0,			0,	1];
            arm.T_14 = symfun(A_1*A_2*A_3*A_4, [SP SR SY EP])

            arm.joints = ['RSP';'RSR';'RSY';'REP'];

		end
	end