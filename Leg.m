classdef Leg < Limb
    properties (Constant)
        RIGHT = 1;
        LEFT = 0;
        GLOBAL = 1;
        LOWER_BODY = 0;
        % Limb lengths
        CALF = .28;
        THIGH = .28;
        % Joint limits
        HY_L = -1.57;
        HY_U = 1.57;
        HR_L = -.5;
        HR_U = .5;
        HP_L = -1.47;
        HP_U = 1.6;
        KP_L = 0;
        KP_U = 2.6;
        AP_L = -1.3;
        AP_U = 1.7;
        AR_L = -.2;
        AR_U = .2;      
    end
    
    properties
        % Determines whether coordinate system is in hip roll refernce
        % frame (Rainbow style) or hip yaw reference frame
        frame;
        % Forward transformation matrices
        T_04; % Hip yaw to ankle pitch
        T_14; % Hip roll to ankle pitch
        % Inverse transformation matrices
        %T_40; % Ankle pitch to hip yaw
        %T_41; % Ankle pitch to hip roll
    end
    
    methods
        function leg = Leg(which, frame)
            leg.frame = frame;
            % Symbolicly solve transformation matrices
            % HY: Hip yaw
            % HR: Hip roll
            % HP: Hip pitch
            % KP: Knee pitch
            HY = sym('HY');
            HR = sym('HR');
            HP = sym('HP');
            KP = sym('KP');
            % Hip yaw to hip roll transform
            A_1 = [cos(HY),-sin(HY),0,	0;sin(HY),cos(HY),0,0;0,0,1,0;0,0,0,1];
            % Hip roll to hip pitch transform
            A_2 = [cos(HR),0,-sin(HR),0;sin(HR),0,cos(HR),0;0,-1,0,0;0,0,0,1];
            % Hip pitch to knee pitch transform
            A_3 = [cos(HP),-sin(HP),0,Leg.THIGH*cos(HP);sin(HP),cos(HP),0,Leg.THIGH*sin(HP);0,0,1,0;0,0,0,1];
            % Knee Pitch to ankle pitch transform
            A_4 = [cos(KP),-sin(KP),0,Leg.CALF*cos(KP);sin(KP),cos(KP),0,Leg.CALF*sin(KP);0,0,1,0;0,0,0,1];
            % Transform from hip roll to ankle pitch reference frame
            leg.T_14 = symfun(A_2*A_3*A_4, [HR HP KP]);
            % Transform from hip yaw to ankle pitch reference frame
            leg.T_04 = symfun(A_1*leg.T_14, [HY HR HP KP]);
            
            % I should learn how to use these
            %leg.T_41 = inv(leg.T_14);
            %leg.T_40 = inv(leg.T_04);
            
            if which
                leg.joints = ['RHY';'RHR';'RHP';'RKP';'RAP';'RAR'];
            else
                leg.joints = ['LHY';'LHR';'LHP';'LKP';'LAP';'LAR'];
            end
            leg.joints = cellstr(leg.joints);
        end
        
        % Calculate foot xyz position from joint angles using leg
        % transformation matrices
        function [x, y, z] = getXYZ(leg, xyzData)
            yaw = xyzData(1);
            roll = xyzData(2);
            pitch = xyzData(3);
            knee = xyzData(4);
            if(leg.frame)
                t = leg.T_14(roll, pitch, knee);
            else
                t = leg.T_04(yaw, roll, pitch, knee);
            end
            x = eval(t(3,4)); % X and Z axes are flipped
            y = eval(t(2,4));
            z = eval(t(1,4)); % X and Z axes are flipped
        end
        
        % A geometric IK solution for Hubo's leg, credit to KAIST
        function jointData = setXYZ(leg, xyzData)
            x = xyzData(1);
            y = xyzData(2);
            z = xyzData(3);
            yaw = xyzData(4);
            if(leg.frame)
                % Coordinates given in hip yaw reference frame. Convert to
                % hip roll reference frame before solving
                x = cos(yaw)*x + sin(yaw)*y;
                y = cos(yaw)*y - sin(yaw)*x;
            end
            radius = sqrt(x^2 + y^2 + z^2);
            if(radius > Leg.THIGH + Leg.CALF)
                error('myApp:argChk','Position out of reach');
            end
            HY = yaw;
            KP = pi - acos((Leg.THIGH^2 + Leg.CALF^2 - radius^2)/ (2*Leg.THIGH*Leg.CALF));
            HR = atan2(y, -z);
            HP = asin((-sin(KP)*Leg.CALF*(-y * sin(HR) + z*cos(HR)) + x*(cos(KP)*Leg.CALF + Leg.THIGH)) / (-x^2 - (y*sin(HR) - z*cos(HR))*(y*sin(HR) - z * cos(HR))));
            AP = -HP - KP;
            AR = -HR;
            % Check that computed joint angles are within joint limits
            if(HY<Leg.HY_L || HY>Leg.HY_U || HR<Leg.HR_L || HR>Leg.HR_U || HP<Leg.HP_L || HP>Leg.HP_U || KP<Leg.KP_L || KP>Leg.KP_U || AP<Leg.AP_L || AP>Leg.AP_U || AR<Leg.AR_L || AR>Leg.AR_U)
                error('myApp:argChk','One or more joint angle out of range')
            end
            
            jointData = [HY, HR, HP, KP, AP, AR];
        end
            
    end
    
end

