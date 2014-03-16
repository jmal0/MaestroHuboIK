classdef Leg
    properties (Constant)
        RIGHT = 1;
        LEFT = 0;
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
        % Controlled joint names
        joints = [];
    end
    
    methods
        function leg = Leg(which)
            if which
                leg.joints = ['RHY';'RHR';'RHP';'RKP';'RAP';'RAR'];
            else
                leg.joints = ['LHY';'LHR';'LHP';'LKP';'LAP';'LAR'];
            end
            leg.joints = cellstr(leg.joints);
        end
        function getFootGlobalXYZ(y, r, p, k)
            
        end
        
        % A geometric IK solution for Hubo's leg, credit to KAIST
        function [HY, HR, HP, KP, AP, AR] = setFootLowerBodyXYZ(Leg, x, y, z, yaw)
            radius = sqrt(x^2 + y^2 + z^2);
            if(radius > Leg.THIGH + Leg.CALF)
                HY = NaN;
                return;
            end
            HY = yaw;
            KP = pi - acos((Leg.THIGH^2 + Leg.CALF^2 - radius^2)/ (2*Leg.THIGH*Leg.CALF));
            HR = atan2(y, -z);
            HP = asin((-sin(KP)*Leg.CALF*(-y * sin(HR) + z*cos(HR)) + x*(cos(KP)*Leg.CALF + Leg.THIGH)) / (-x^2 - (y*sin(HR) - z*cos(HR))*(y*sin(HR) - z * cos(HR))));
            AR = -HR;
            AP = -HP - KP;
            % Check that computed joint angles are within joint limits
            if(HY<Leg.HY_L || HY>Leg.HY_U || HR<Leg.HR_L || HR>Leg.HR_U || HP<Leg.HP_L || HP>Leg.HP_U || KP<Leg.KP_L || KP>Leg.KP_U || AP<Leg.AP_L || AP>Leg.AP_U || AR<Leg.AR_L || AR>Leg.AR_U)
                HY = Nan;
                return;
            end
        end
    end
    
end

